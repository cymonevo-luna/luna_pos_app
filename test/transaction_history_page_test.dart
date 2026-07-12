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
import 'package:luna_pos/features/transaction/transaction_history_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;

  Map<String, dynamic> listResponse({
    required List<Map<String, dynamic>> items,
    int total = 1,
  }) =>
      {
        'success': true,
        'data': items,
        'meta': {
          'page': 1,
          'per_page': TransactionRepository.defaultPerPage,
          'total': total,
        },
      };

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

  testWidgets('transaction history list shows rows', (tester) async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(
          items: [
            {
              'id': 'tx-1',
              'method': 'CASH',
              'amount': 25000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionHistoryPage), findsOneWidget);
    expect(find.text('Rp 25.000'), findsOneWidget);
    expect(find.textContaining('Cashier Test'), findsOneWidget);
  });

  testWidgets('transaction history shows empty state', (tester) async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(items: [], total: 0),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
  });
}
