import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/login_page.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), testResourceCache()),
      );
  });

  Future<void> pumpPastSplash(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();
  }

  testWidgets('unauthenticated startup routes to the login screen',
      (WidgetTester tester) async {
    await pumpPastSplash(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('restored session routes to POS home after cold start',
      (WidgetTester tester) async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
    );
    secure.store[SecureKeys.merchantJson] =
        '{"id":"${TestAccounts.testMerchantId}","name":"${TestAccounts.testMerchantName}"}';
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
    );

    await pumpPastSplash(tester);

    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('expired refresh token on cold start routes to login',
      (WidgetTester tester) async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
      refreshExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    await pumpPastSplash(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(secure.store[SecureKeys.refreshToken], isNull);
  });
}
