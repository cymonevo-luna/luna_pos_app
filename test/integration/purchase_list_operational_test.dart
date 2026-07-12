import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/purchase_list_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;

  Map<String, dynamic> purchaseListResponse() => {
        'success': true,
        'data': [
          {
            'id': 'pr-live',
            'supplier_name': 'Live Supplier',
            'status': 'REQUESTED',
            'total_estimated_amount': 75000,
            'item_count': 2,
            'created_by_username': 'Operational Test',
            'created_at': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {
          'page': 1,
          'per_page': PurchaseRequestRepository.defaultPerPage,
          'total': 1,
        },
      };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SessionGuard>(SessionGuard())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      );

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  }

  testWidgets('operational user opens purchases and receives 200 list', (
    tester,
  ) async {
    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(200, purchaseListResponse()),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await pumpApp(tester);

    await tester.tap(find.text('Purchases'));
    await tester.pumpAndSettle();

    expect(find.byType(PurchaseListPage), findsOneWidget);
    expect(find.text('Live Supplier'), findsOneWidget);
    expect(find.text('Rp 75.000'), findsOneWidget);
  });
}
