import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:luna_pos/features/purchase/data/purchase_proof_upload.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/purchase_request.dart';
import 'package:luna_pos/features/purchase/purchase_detail_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';
import 'helpers/purchase_test_fakes.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;
  late FakePurchaseImagePicker imagePicker;
  late FakePurchaseProofUpload proofUpload;

  Map<String, dynamic> detailPayload({
    String id = 'pr-detail',
    PurchaseRequestStatus status = PurchaseRequestStatus.requested,
    List<Map<String, dynamic>>? items,
    String? paidProofUrl,
    String? deliveredProofUrl,
  }) =>
      {
        'id': id,
        'supplier_id': 'sup-1',
        'supplier_name': 'Supplier A',
        'supplier_contact_info': '081234567890',
        'status': switch (status) {
          PurchaseRequestStatus.pending => 'PENDING',
          PurchaseRequestStatus.requested => 'REQUESTED',
          PurchaseRequestStatus.paid => 'PAID',
          PurchaseRequestStatus.delivered => 'DELIVERED',
        },
        'total_estimated_amount': 250000,
        'items': items ??
            [
              {
                'food_supply_id': 'fs-1',
                'food_supply_title': 'Flour',
                'quantity': '2',
                'unit': 'kg',
                'unit_price': 50000,
                'line_total': 100000,
              },
              {
                'food_supply_id': 'fs-2',
                'food_supply_title': 'Sugar',
                'quantity': '3',
                'unit': 'kg',
                'unit_price': 50000,
                'line_total': 150000,
              },
            ],
        'notes': 'Weekly restock',
        'created_by_username': 'Operational Test',
        'created_at': '2026-07-12T10:00:00Z',
        'paid_proof_url': ?paidProofUrl,
        'delivered_proof_url': ?deliveredProofUrl,
      };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    secure = FakeSecureStorage();
    imagePicker = FakePurchaseImagePicker();
    proofUpload = FakePurchaseProofUpload();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SessionGuard>(SessionGuard())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<PurchaseProofUpload>(() => proofUpload)
      ..registerLazySingleton<PurchaseImagePicker>(() => imagePicker);

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
    );
  });

  Future<void> pumpDetail(
    WidgetTester tester, {
    Map<String, dynamic>? detail,
    String id = 'pr-detail',
  }) async {
    adapter.onGet(
      '/api/admin/purchase-requests/$id',
      (server) => server.reply(200, {
        'success': true,
        'data': detail ?? detailPayload(),
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PurchaseDetailPage(purchaseId: id),
        ),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('detail renders line items', (tester) async {
    await pumpDetail(tester);
    await tester.scrollUntilVisible(
      find.text('Flour'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Flour'), findsOneWidget);
    expect(find.text('Sugar'), findsOneWidget);
    expect(find.textContaining('2 kg'), findsOneWidget);
    expect(find.textContaining('3 kg'), findsOneWidget);
  });

  testWidgets('PAID status prompts photo', (tester) async {
    await pumpDetail(tester);

    final l10n = AppLocalizationsEn();
    await tester.tap(find.byKey(const Key('purchase_status_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.purchaseStatusPaid).last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('purchase_photo_sheet')), findsOneWidget);
    expect(find.byKey(const Key('purchase_take_photo')), findsOneWidget);
    expect(find.byKey(const Key('purchase_choose_gallery')), findsOneWidget);
  });

  testWidgets('REQUESTED status skips photo', (tester) async {
    await pumpDetail(
      tester,
      detail: detailPayload(status: PurchaseRequestStatus.pending),
    );

    var patchCalled = false;
    adapter.onPatch(
      '/api/admin/purchase-requests/pr-detail/status',
      (server) {
        patchCalled = true;
        return server.reply(200, {
          'success': true,
          'data': detailPayload(status: PurchaseRequestStatus.requested),
        });
      },
      data: {'status': 'REQUESTED'},
    );

    final l10n = AppLocalizationsEn();
    await tester.tap(find.byKey(const Key('purchase_status_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.purchaseStatusRequested).last);
    await tester.pumpAndSettle();

    expect(patchCalled, isTrue);
    expect(find.byKey(const Key('purchase_photo_sheet')), findsNothing);
  });

  testWidgets('proof thumbnails displayed', (tester) async {
    await pumpDetail(
      tester,
      detail: detailPayload(
        status: PurchaseRequestStatus.paid,
        paidProofUrl: '/uploads/paid-proof.jpg',
      ),
    );

    await tester.scrollUntilVisible(
      find.text(AppLocalizationsEn().purchaseProofPaid),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(Image), findsWidgets);
    expect(find.text(AppLocalizationsEn().purchaseProofPaid), findsOneWidget);
  });
}
