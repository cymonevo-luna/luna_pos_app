import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/auth/token_refresh_service.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;
  late ApiClient client;
  late TokenRefreshService tokenRefresh;
  late SessionGuard sessionGuard;
  var sessionExpiredCalls = 0;

  setUp(() async {
    await locator.reset();
    secure = FakeSecureStorage();
    sessionGuard = SessionGuard();
    sessionExpiredCalls = 0;

    final mocked = buildMockedApiClient(
      sessionGuard: sessionGuard,
      secure: secure,
      withAuthInterceptor: true,
    );
    client = mocked.client;
    adapter = mocked.adapter;
    tokenRefresh = mocked.tokenRefresh!;

    locator
      ..registerSingleton<SessionGuard>(sessionGuard)
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<TokenRefreshService>(tokenRefresh)
      ..registerSingleton<ApiClient>(client)
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>()),
      );
  });

  void seedValidSession({
    String accessToken = 'stale-access',
    String refreshToken = 'ref',
    DateTime? accessExpiresAt,
    DateTime? refreshExpiresAt,
  }) {
    secure.store[SecureKeys.authToken] = accessToken;
    secure.store[SecureKeys.refreshToken] = refreshToken;
    secure.store[SecureKeys.refreshExpiresAt] =
        '${(refreshExpiresAt ?? DateTime.now().add(const Duration(days: 7))).millisecondsSinceEpoch}';
    if (accessExpiresAt != null) {
      secure.store[SecureKeys.accessExpiresAt] =
          '${accessExpiresAt.millisecondsSinceEpoch}';
    }
  }

  test('401 on POS API triggers refresh and retries the request once', () async {
    seedValidSession();
    stubTokenRefresh(adapter, refreshToken: 'ref');

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(401, {
        'success': false,
        'error': {'code': 'unauthorized', 'message': 'expired'},
      }),
      headers: {'Authorization': 'Bearer stale-access'},
    );
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
      headers: {'Authorization': 'Bearer acc-new'},
    );

    final menus = await locator<MenuRepository>().fetchPOSMenus();

    expect(menus.categories, isEmpty);
    expect(secure.store[SecureKeys.authToken], 'acc-new');
    expect(sessionExpiredCalls, 0);
  });

  test('proactive refresh runs before request when access expires within 2 min',
      () async {
    seedValidSession(
      accessExpiresAt: DateTime.now().add(const Duration(minutes: 1)),
    );
    stubTokenRefresh(adapter, refreshToken: 'ref');

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
    );

    await locator<MenuRepository>().fetchPOSMenus();

    expect(secure.store[SecureKeys.authToken], 'acc-new');
  });

  test('offline refresh failure keeps session when refresh token is still valid',
      () async {
    seedValidSession();
    adapter.onPost(
      '/api/v1/auth/refresh',
      (server) => server.reply(500, {
        'success': false,
        'error': {'code': 'server_error', 'message': 'offline'},
      }),
      data: {'refresh_token': 'ref'},
    );

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(401, {
        'success': false,
        'error': {'code': 'unauthorized', 'message': 'expired'},
      }),
    );

    sessionGuard.onExpired = () async {
      sessionExpiredCalls++;
    };

    await expectLater(
      locator<MenuRepository>().fetchPOSMenus(),
      throwsA(isA<Exception>()),
    );
    expect(sessionExpiredCalls, 0);
    expect(secure.store[SecureKeys.refreshToken], 'ref');
  });

  test('expired refresh token on 401 clears the session', () async {
    seedValidSession(
      refreshExpiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
    );

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(401, {
        'success': false,
        'error': {'code': 'unauthorized', 'message': 'expired'},
      }),
    );

    sessionGuard.onExpired = () async {
      sessionExpiredCalls++;
    };

    await expectLater(
      locator<MenuRepository>().fetchPOSMenus(),
      throwsA(isA<Exception>()),
    );
    expect(sessionExpiredCalls, 1);
  });

  test('concurrent refresh calls share a single in-flight future', () async {
    seedValidSession();
    stubTokenRefresh(adapter, refreshToken: 'ref');

    final results = await Future.wait([
      tokenRefresh.refresh(),
      tokenRefresh.refresh(),
      tokenRefresh.refresh(),
    ]);

    expect(results, everyElement(isTrue));
    expect(secure.store[SecureKeys.authToken], 'acc-new');
  });

  test('activity refresh is debounced to once every 5 minutes', () async {
    seedValidSession();
    stubTokenRefresh(adapter, refreshToken: 'ref');

    await tokenRefresh.refreshOnActivity();
    await tokenRefresh.refreshOnActivity();
    await tokenRefresh.refreshOnActivity();

    expect(secure.store[SecureKeys.authToken], 'acc-new');
  });

  test('auth endpoints skip bearer injection and retry loops', () async {
    adapter.onPost(
      '/api/v1/auth/login',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'tokens': {
            'access_token': 'login-access',
            'refresh_token': 'login-refresh',
            'expires_in': 900,
            'refresh_expires_in': 604800,
          },
          'user': {
            'id': 'u1',
            'email': 'cashier-test@cymonevo.com',
            'name': 'Cashier',
            'merchant_id': 'm1',
            'roles': ['cashier'],
          },
          'merchant': {'id': 'm1', 'name': 'Test'},
        },
      }),
      data: {'email': 'cashier-test@cymonevo.com', 'password': 'secret'},
    );

    final data = await client.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      body: {'email': 'cashier-test@cymonevo.com', 'password': 'secret'},
      decoder: (raw) => (raw as Map)['data'] as Map<String, dynamic>,
    );

    expect(data['tokens'], isNotNull);
    expect(sessionExpiredCalls, 0);
  });
}
