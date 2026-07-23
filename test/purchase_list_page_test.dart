import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/purchase_list_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;

  Map<String, dynamic> listResponse({
    required List<Map<String, dynamic>> items,
    int total = 0,
  }) =>
      {
        'success': true,
        'data': items,
        'meta': {
          'page': 1,
          'per_page': PurchaseRequestRepository.defaultPerPage,
          'total': total == 0 ? items.length : total,
        },
      };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    secure = FakeSecureStorage();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      );

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
    );
  });

  Future<void> pumpPurchaseList(
    WidgetTester tester, {
    List<Map<String, dynamic>>? items,
    Map<String, dynamic>? queryParameters,
  }) async {
    final resolvedItems = items ??
        [
          {
            'id': 'abc',
            'supplier_name': 'Supplier A',
            'status': 'REQUESTED',
            'total_estimated_amount': 100000,
            'item_count': 2,
            'created_by_username': 'Operational Test',
            'created_at': '2026-07-12T10:00:00Z',
          },
        ];

    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(
        200,
        listResponse(items: resolvedItems),
      ),
      queryParameters: queryParameters ??
          {
            'page': '1',
            'per_page': '20',
          },
    );

    final router = GoRouter(
      initialLocation: AppRoute.purchases.path,
      routes: [
        GoRoute(
          path: AppRoute.purchases.path,
          name: AppRoute.purchases.name,
          builder: (context, state) => const PurchaseListPage(),
          routes: [
            GoRoute(
              path: 'new',
              name: AppRoute.purchasesNew.name,
              builder: (context, state) =>
                  const Scaffold(body: Text('new-purchase-screen')),
            ),
            GoRoute(
              path: ':id',
              name: AppRoute.purchaseDetail.name,
              builder: (context, state) => Scaffold(
                body: Text('detail-${state.pathParameters['id']}'),
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('status filter passes PAID query param', (tester) async {
    await pumpPurchaseList(
      tester,
      items: [
        {
          'id': 'pr-all',
          'supplier_name': 'Supplier All',
          'status': 'REQUESTED',
          'total_estimated_amount': 50000,
          'item_count': 1,
          'created_at': '2026-07-12T10:00:00Z',
        },
      ],
    );

    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(
        200,
        listResponse(items: []),
      ),
      queryParameters: {
        'page': '1',
        'per_page': '20',
        'status': 'PAID',
      },
    );

    final l10n = AppLocalizationsEn();
    await tester.tap(find.widgetWithText(FilterChip, l10n.purchaseStatusPaid));
    await tester.pumpAndSettle();
  });

  testWidgets('list renders distinct status badges', (tester) async {
    await pumpPurchaseList(
      tester,
      items: [
        {
          'id': 'pr-1',
          'supplier_name': 'Supplier Pending',
          'status': 'PENDING',
          'total_estimated_amount': 10000,
          'item_count': 1,
          'created_at': '2026-07-12T10:00:00Z',
        },
        {
          'id': 'pr-2',
          'supplier_name': 'Supplier Requested',
          'status': 'REQUESTED',
          'total_estimated_amount': 20000,
          'item_count': 2,
          'created_at': '2026-07-12T11:00:00Z',
        },
        {
          'id': 'pr-3',
          'supplier_name': 'Supplier Paid',
          'status': 'PAID',
          'total_estimated_amount': 30000,
          'item_count': 3,
          'created_at': '2026-07-12T12:00:00Z',
        },
        {
          'id': 'pr-4',
          'supplier_name': 'Supplier Delivered',
          'status': 'DELIVERED',
          'total_estimated_amount': 40000,
          'item_count': 4,
          'created_at': '2026-07-12T13:00:00Z',
        },
      ],
    );

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.purchaseStatusPending), findsWidgets);
    expect(find.text(l10n.purchaseStatusRequested), findsWidgets);
    expect(find.text(l10n.purchaseStatusPaid), findsWidgets);
    expect(find.text(l10n.purchaseStatusDelivered), findsWidgets);
  });

  testWidgets('tap navigates to purchase detail', (tester) async {
    await pumpPurchaseList(tester);

    await tester.tap(find.text('Supplier A'));
    await tester.pumpAndSettle();

    expect(find.text('detail-abc'), findsOneWidget);
  });

  testWidgets('new request button navigates', (tester) async {
    await pumpPurchaseList(tester);

    final l10n = AppLocalizationsEn();
    await tester.tap(find.text(l10n.purchasesNew));
    await tester.pumpAndSettle();

    expect(find.text('new-purchase-screen'), findsOneWidget);
  });

  testWidgets('smart request button is visible', (tester) async {
    await pumpPurchaseList(tester);

    expect(find.byKey(const Key('smart_purchase_entry_button')), findsOneWidget);
  });

  testWidgets('list prefers actual total when available', (tester) async {
    await pumpPurchaseList(
      tester,
      items: [
        {
          'id': 'pr-actual',
          'supplier_name': 'Supplier Actual',
          'status': 'REQUESTED',
          'total_estimated_amount': 100000,
          'total_actual_amount': 135000,
          'item_count': 1,
          'created_at': '2026-07-12T10:00:00Z',
        },
      ],
    );

    expect(find.text(formatRupiah(135000)), findsOneWidget);
    expect(find.text(formatRupiah(100000)), findsNothing);
  });
}
