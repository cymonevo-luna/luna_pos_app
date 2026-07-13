import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/auth/token_refresh_service.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/auth/login_page.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/production_request/data/production_request_repository.dart';
import 'package:luna_pos/features/production_request/production_request_list_page.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';
import 'package:luna_pos/features/stock/stock_list_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/l10n/app_localizations_id.dart';
import 'package:luna_pos/shared/widgets/main_scaffold.dart';
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

Map<String, dynamic> _loginUserPayload(
  TestAccountRole role, {
  required String userId,
  required String email,
  List<String> additionalRoles = const [],
}) =>
    {
      'id': userId,
      'email': email,
      'name': _displayNameFor(role),
      'merchant_id': TestAccounts.testMerchantId,
      'roles': TestAccounts.apiRolesFor(
        role,
        additionalRoles: additionalRoles,
      ),
    };

Map<String, dynamic> _merchantPayload() => {
      'id': TestAccounts.testMerchantId,
      'name': TestAccounts.testMerchantName,
    };

void stubDedicatedAccountLogin(
  DioAdapter adapter,
  TestAccountRole role, {
  String? userId,
  String accessToken = 'acc',
  String refreshToken = 'ref',
  List<String> additionalRoles = const [],
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
          'refresh_expires_in': 604800,
        },
        'user': _loginUserPayload(
          role,
          userId: resolvedUserId,
          email: email,
          additionalRoles: additionalRoles,
        ),
        'merchant': _merchantPayload(),
      },
    }),
    data: {'email': email, 'password': TestAccounts.password},
  );
}

void stubTokenRefresh(
  DioAdapter adapter, {
  String refreshToken = 'ref',
  String accessToken = 'acc-new',
  String newRefreshToken = 'ref-new',
}) {
  adapter.onPost(
    '/api/v1/auth/refresh',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'tokens': {
          'access_token': accessToken,
          'refresh_token': newRefreshToken,
          'expires_in': 900,
          'refresh_expires_in': 604800,
        },
      },
    }),
    data: {'refresh_token': refreshToken},
  );
}

/// Boots shared preferences mocks and a mocked API for automation tests.
Future<IntegrationTestHarness> setUpIntegrationHarness() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppConfig.load();
  await locator.reset();

  final secure = FakeSecureStorage();
  final sessionGuard = SessionGuard();
  final mocked = buildMockedApiClient();
  final tokenRefresh = TokenRefreshService(
    secureStorage: secure,
    dio: mocked.client.raw,
    onSessionExpired: () => sessionGuard.notifyExpired(),
  );
  mocked.client.attachAuthInterceptor(tokenRefresh);
  locator
    ..registerSingleton<PreferencesService>(await PreferencesService.create())
    ..registerSingleton<SecureStorageService>(secure)
    ..registerSingleton<SessionGuard>(sessionGuard)
    ..registerSingleton<TokenRefreshService>(tokenRefresh)
    ..registerSingleton<ApiClient>(mocked.client)
    ..registerLazySingleton<MenuRepository>(
      () => MenuRepository(locator<ApiClient>()),
    )
    ..registerLazySingleton<FoodSupplyRepository>(
      () => FoodSupplyRepository(locator<ApiClient>()),
    )
    ..registerLazySingleton<ProductionRequestRepository>(
      () => ProductionRequestRepository(locator<ApiClient>()),
    );

  return IntegrationTestHarness(
    secure: secure,
    adapter: mocked.adapter,
    container: ProviderContainer(),
  );
}

/// Shared state for mocked integration tests.
class IntegrationTestHarness {
  IntegrationTestHarness({
    required this.secure,
    required this.adapter,
    required this.container,
  });

  final FakeSecureStorage secure;
  final DioAdapter adapter;
  final ProviderContainer container;
  bool _productionDeliveryMarkedDone = false;
  String _productionRequestMenuTitle = 'Nasi Goreng';
  int _productionRequestQuantity = 2;
  String? _productionRequestNotes;

  GoRouter readRouter() => container.read(routerProvider);

  /// Rejects any accidental registration attempt during automation.
  void forbidRegistration() {
    adapter.onPost(
      '/api/v1/auth/register',
      (server) => server.reply(403, {
        'success': false,
        'error': {'message': 'register forbidden in tests'},
      }),
    );
  }

  void stubLoginForRole(
    TestAccountRole role, {
    List<String> additionalRoles = const [],
  }) {
    final userId = TestAccounts.userIdFor(role);
    stubDedicatedAccountLogin(
      adapter,
      role,
      userId: userId,
      additionalRoles: additionalRoles,
    );
    adapter.onGet(
      '/api/v1/users/$userId',
      (server) => server.reply(200, {
        'success': true,
        'data': _loginUserPayload(
          role,
          userId: userId,
          email: TestAccounts.emailFor(role),
          additionalRoles: additionalRoles,
        ),
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

  void stubEmptyFoodSupplies() {
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
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

  void stubCreateTransaction() {
    adapter.onPost(
      '/api/v1/pos/transactions',
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'tx-1',
          'method': 'CASH',
          'amount': 35000,
          'subtotal_amount': 35000,
          'tax_amount': 0,
          'discount_amount': 0,
          'items': [
            {
              'menu_id': 'm1',
              'title': 'Nasi Goreng',
              'quantity': 1,
              'unit_price': 35000,
              'line_total': 35000,
            },
          ],
          'receipt_number': 'RCP-001',
          'created_at': '2026-07-12T10:00:00Z',
        },
      }),
    );
  }

  void stubStoreSettings() {
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'brand_name': 'Luna Coffee',
          'branch_name': 'Test Branch',
          'address': 'Jl. Test 1',
          'phone': '021-0000000',
          'thank_you_note': 'Terima kasih!',
        },
      }),
    );
  }

  /// Stubs `GET /api/v1/pos/production-requests` for READY_TO_PICK inbox.
  ///
  /// Summaries match the live API: `item_count` only (no embedded line items).
  /// After mark-done, subsequent list fetches return an empty page.
  void stubProductionRequestInbox({
    required String requestId,
    String menuTitle = 'Nasi Goreng',
    int quantity = 2,
  }) {
    _productionDeliveryMarkedDone = false;
    _productionRequestMenuTitle = menuTitle;
    _productionRequestQuantity = quantity;

    adapter.onGet(
      ProductionRequestRepository.listPath,
      (server) => server.replyCallback(200, (_) => {
            'success': true,
            'data': _productionDeliveryMarkedDone
                ? <Map<String, dynamic>>[]
                : [
                    {
                      'id': requestId,
                      'status': 'READY_TO_PICK',
                      'item_count': 1,
                      'items': <Map<String, dynamic>>[],
                      'created_at': '2026-07-12T10:00:00Z',
                      'updated_at': '2026-07-12T10:00:00Z',
                    },
                  ],
            'meta': {
              'page': 1,
              'per_page': 20,
              'total': _productionDeliveryMarkedDone ? 0 : 1,
            },
          }),
      queryParameters: {
        'status': 'READY_TO_PICK',
        'page': '1',
        'per_page': '20',
      },
    );
  }

  /// Stubs `GET /api/v1/pos/production-requests/{id}` detail with line items.
  void stubProductionRequestDetail({
    required String requestId,
    String menuTitle = 'Nasi Goreng',
    int quantity = 2,
    String? notes,
  }) {
    _productionRequestMenuTitle = menuTitle;
    _productionRequestQuantity = quantity;
    _productionRequestNotes = notes;

    adapter.onGet(
      '${ProductionRequestRepository.listPath}/$requestId',
      (server) => server.replyCallback(200, (_) {
            final data = <String, dynamic>{
              'id': requestId,
              'status':
                  _productionDeliveryMarkedDone ? 'DONE' : 'READY_TO_PICK',
              'item_count': 1,
              'items': [
                {
                  'id': 'pri-1',
                  'menu_id': 'm1',
                  'menu_title': _productionRequestMenuTitle,
                  'quantity': _productionRequestQuantity,
                  'is_finished': _productionDeliveryMarkedDone,
                },
              ],
              'created_at': '2026-07-12T10:00:00Z',
              'updated_at': '2026-07-12T10:00:00Z',
            };
            if (_productionRequestNotes != null) {
              data['notes'] = _productionRequestNotes;
            }
            return {
              'success': true,
              'data': data,
            };
          }),
    );
  }

  /// Stubs `PATCH /api/v1/pos/production-requests/{id}/status` with DONE body.
  ///
  /// Flips list stub state so the next inbox fetch returns empty data.
  void stubMarkProductionRequestDone({required String requestId}) {
    adapter.onPatch(
      '${ProductionRequestRepository.listPath}/$requestId/status',
      (server) => server.replyCallback(200, (_) {
            _productionDeliveryMarkedDone = true;
            final data = <String, dynamic>{
              'id': requestId,
              'status': 'DONE',
              'item_count': 1,
              'items': [
                {
                  'id': 'pri-1',
                  'menu_id': 'm1',
                  'menu_title': _productionRequestMenuTitle,
                  'quantity': _productionRequestQuantity,
                  'is_finished': true,
                },
              ],
              'created_at': '2026-07-12T10:00:00Z',
              'updated_at': '2026-07-12T10:05:00Z',
            };
            if (_productionRequestNotes != null) {
              data['notes'] = _productionRequestNotes;
            }
            return {
              'success': true,
              'data': data,
            };
          }),
      data: {'status': 'DONE'},
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );
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

  Future<void> tapProductionTab(WidgetTester tester) async {
    final locale = container.read(localeProvider) ?? const Locale('en');
    final label = switch (locale.languageCode) {
      'id' => AppLocalizationsId().deliveries,
      _ => AppLocalizationsEn().deliveries,
    };
    await tester.tap(find.text(label));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
    expect(find.byType(ProductionRequestListPage), findsOneWidget);
  }

  Future<void> expectAuthenticatedProcurement(WidgetTester tester) async {
    expect(find.byType(StockListPage), findsOneWidget);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.stock), findsWidgets);
    expect(find.byType(MenuPage), findsNothing);
  }

  Future<void> expectProcurementTabsVisible(WidgetTester tester) async {
    expect(find.byType(MainScaffold), findsOneWidget);
    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.stock), findsWidgets);
    expect(find.text(l10n.purchases), findsWidgets);
    expect(find.text(l10n.menu), findsWidgets);
  }

  Future<void> expectLoginRejected(WidgetTester tester) async {
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(MenuPage), findsNothing);
    expect(find.byType(StockListPage), findsNothing);
    expect(find.text(kPosAccessDeniedMessage), findsOneWidget);
  }
}

String _displayNameFor(TestAccountRole role) => switch (role) {
      TestAccountRole.admin => 'Admin Test',
      TestAccountRole.manager => 'Manager Test',
      TestAccountRole.cashier => 'Cashier Test',
      TestAccountRole.operational => 'Operational Test',
    };
