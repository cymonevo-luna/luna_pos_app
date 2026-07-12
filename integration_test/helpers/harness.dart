import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/login_page.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart' as test_auth;
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory secure storage for integration tests.
class FakeSecureStorage extends SecureStorageService {
  final Map<String, String> store = <String, String>{};

  @override
  Future<String?> read(String key) async => store[key];

  @override
  Future<void> write(String key, String value) async => store[key] = value;

  @override
  Future<void> delete(String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}

({ApiClient client, DioAdapter adapter}) buildMockedApiClient() {
  final client = ApiClient(baseUrl: 'https://api.test');
  final adapter = DioAdapter(dio: client.raw);
  return (client: client, adapter: adapter);
}

void stubDedicatedAccountLogin(
  DioAdapter adapter,
  TestAccountRole role, {
  String? userId,
  String accessToken = 'acc',
  String refreshToken = 'ref',
}) {
  final email = TestAccounts.emailFor(role);
  final resolvedUserId = userId ?? TestAccounts.userIdFor(role);
  adapter.onPost(
    '/api/v1/auth/login',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'tokens': {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'expires_in': 900,
        },
        'user': {
          'id': resolvedUserId,
          'email': email,
          'name': _displayNameFor(role),
          'role': TestAccounts.apiRoleFor(role),
        },
      },
    }),
    data: {'email': email, 'password': TestAccounts.password},
  );
}

/// Boots shared preferences mocks and a mocked API for automation tests.
Future<IntegrationTestHarness> setUpIntegrationHarness() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppConfig.load();
  await locator.reset();

  final secure = FakeSecureStorage();
  final mocked = buildMockedApiClient();
  locator
    ..registerSingleton<PreferencesService>(await PreferencesService.create())
    ..registerSingleton<SecureStorageService>(secure)
    ..registerSingleton<ApiClient>(mocked.client)
    ..registerLazySingleton<MenuRepository>(
      () => MenuRepository(locator<ApiClient>()),
    );

  return IntegrationTestHarness(
    secure: secure,
    adapter: mocked.adapter,
  );
}

/// Shared state for mocked integration tests.
class IntegrationTestHarness {
  IntegrationTestHarness({
    required this.secure,
    required this.adapter,
  });

  final FakeSecureStorage secure;
  final DioAdapter adapter;

  void stubLoginForRole(TestAccountRole role) {
    final userId = TestAccounts.userIdFor(role);
    stubDedicatedAccountLogin(adapter, role, userId: userId);
    adapter.onGet(
      '/api/v1/users/$userId',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': userId,
          'email': TestAccounts.emailFor(role),
          'name': _displayNameFor(role),
          'role': TestAccounts.apiRoleFor(role),
        },
      }),
    );
  }

  /// Programmatic login via the shared test auth helper (mocked or live API).
  Future<test_auth.AuthSession> loginAsTestRole(TestAccountRole role) {
    return test_auth.loginAsTestRole(
      locator<ApiClient>(),
      secure,
      role,
    );
  }

  void stubEmptyMenu() {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
    );
  }

  void stubSampleMenu() {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'categories': [
            {
              'id': 'c1',
              'name': 'Mains',
              'menus': [
                {
                  'id': 'm1',
                  'title': 'Nasi Goreng',
                  'description': '',
                  'photo_url': '/static/default-food.png',
                  'available_stock': 3,
                  'sell_price': 35000,
                },
              ],
            },
          ],
        },
      }),
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  }

  Future<void> loginViaUi(
    WidgetTester tester,
    TestAccountRole role,
  ) async {
    expect(find.byType(LoginPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), TestAccounts.emailFor(role));
    await tester.enterText(fields.at(1), TestAccounts.password);
    await tester.pump();

    final l10n = AppLocalizationsEn();
    await tester.tap(find.widgetWithText(FilledButton, l10n.login));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  }

  Future<void> expectAuthenticatedHome(WidgetTester tester) async {
    expect(find.byType(MenuPage), findsOneWidget);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.menu), findsWidgets);
  }
}

String _displayNameFor(TestAccountRole role) => switch (role) {
      TestAccountRole.admin => 'Admin Test',
      TestAccountRole.manager => 'Manager Test',
      TestAccountRole.cashier => 'Cashier Test',
      TestAccountRole.operational => 'Operational Test',
    };
