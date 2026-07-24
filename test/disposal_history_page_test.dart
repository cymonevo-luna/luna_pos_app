import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';
import 'package:luna_pos/features/menu_disposal/disposal_history_page.dart';
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
          'per_page': MenuDisposalRepository.defaultPerPage,
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
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<MenuDisposalRepository>(
        () => MenuDisposalRepository(
          locator<ApiClient>(),
          testResourceCache(),
        ),
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

  testWidgets('disposal history list shows rows', (tester) async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(
          items: [
            {
              'id': 'disposal-1',
              'menu_title': 'Nasi Goreng',
              'quantity': 2,
              'loss_amount': 15000,
              'disposed_at': '2026-07-24T10:00:00Z',
              'disposed_by_username': 'Cashier Test',
            },
          ],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await pumpApp(tester);

    await tester.tap(find.text('Dispose Food'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dispose_food_history_button')));
    await tester.pumpAndSettle();

    expect(find.byType(DisposalHistoryPage), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
    expect(find.textContaining('Cashier Test'), findsOneWidget);
  });

  testWidgets('disposal history shows empty state', (tester) async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(items: [], total: 0),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await pumpApp(tester);

    await tester.tap(find.text('Dispose Food'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dispose_food_history_button')));
    await tester.pumpAndSettle();

    expect(find.text('No disposals yet'), findsOneWidget);
  });
}
