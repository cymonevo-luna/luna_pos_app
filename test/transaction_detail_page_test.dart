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
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/transaction_detail_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    secure = FakeSecureStorage();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SessionGuard>(SessionGuard())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      );

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
    );
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
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

  testWidgets('transaction detail shows line items and totals', (tester) async {
    adapter
      ..onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [
            {
              'id': 'tx-1',
              'method': 'OFFLINE',
              'amount': 35000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
          'meta': {'page': 1, 'per_page': 20, 'total': 1},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      )
      ..onGet(
        '/api/v1/pos/transactions/tx-1',
        (server) => server.reply(200, {
          'success': true,
          'data': {
            'id': 'tx-1',
            'method': 'OFFLINE',
            'items': [
              {
                'menu_id': 'm1',
                'title': 'Nasi Goreng',
                'quantity': 1,
                'unit_price': 35000,
                'line_total': 35000,
              },
            ],
            'subtotal_amount': 35000,
            'discount_amount': 0,
            'amount': 35000,
            'cash_tendered': 50000,
            'change_amount': 15000,
            'cashier_username': 'Cashier Test',
            'transaction_date': '2026-07-12T10:00:00Z',
          },
        }),
      );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rp 35.000'));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.textContaining('Cashier Test'), findsWidgets);
    expect(find.text('Rp 50.000'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
  });
}
