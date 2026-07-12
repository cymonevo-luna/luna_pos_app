import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;
  late ProviderContainer container;

  setUp(() async {
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<SessionGuard>(SessionGuard())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client);
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  Future<void> waitForResolution() async {
    for (var i = 0;
        i < 50 && container.read(authProvider).status == AuthStatus.unknown;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('login persists the session and authenticates cashier', () async {
    const email = TestAccounts.cashierEmail;
    const password = TestAccounts.password;

    stubDedicatedAccountLogin(adapter, TestAccountRole.cashier, userId: 'u1');

    final ok = await container
        .read(authProvider.notifier)
        .login(email: email, password: password);

    expect(ok, isTrue);
    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, email);
    expect(state.user?.roles, contains('cashier'));
    expect(state.merchant?.id, TestAccounts.testMerchantId);
    expect(secure.store[SecureKeys.authToken], 'acc');
    expect(secure.store[SecureKeys.refreshToken], 'ref');
    expect(secure.store[SecureKeys.userId], 'u1');
    expect(secure.store[SecureKeys.userJson], isNotNull);
    expect(secure.store[SecureKeys.merchantJson], isNotNull);
  });

  test('manager-only login is rejected without storing tokens', () async {
    stubDedicatedAccountLogin(adapter, TestAccountRole.manager, userId: 'mgr');

    final ok = await container.read(authProvider.notifier).login(
          email: TestAccounts.managerEmail,
          password: TestAccounts.password,
        );

    expect(ok, isFalse);
    final state = container.read(authProvider);
    expect(state.status, isNot(AuthStatus.authenticated));
    expect(state.error, kCashierAccessDeniedMessage);
    expect(secure.store[SecureKeys.authToken], isNull);
    expect(secure.store[SecureKeys.userJson], isNull);
  });

  test('multi-role cashier login succeeds', () async {
    stubDedicatedAccountLogin(
      adapter,
      TestAccountRole.cashier,
      userId: 'co-user',
      additionalRoles: const ['operational'],
    );

    final ok = await container.read(authProvider.notifier).login(
          email: TestAccounts.cashierEmail,
          password: TestAccounts.password,
        );

    expect(ok, isTrue);
    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.roles, containsAll(['cashier', 'operational']));
  });

  test('login failure surfaces the server message and stays signed out',
      () async {
    const email = TestAccounts.cashierEmail;

    adapter.onPost(
      '/api/v1/auth/login',
      (server) => server.reply(401, {
        'success': false,
        'error': {'code': 'unauthorized', 'message': 'invalid credentials'},
      }),
      data: {'email': email, 'password': 'wrong'},
    );

    final ok = await container
        .read(authProvider.notifier)
        .login(email: email, password: 'wrong');

    expect(ok, isFalse);
    final state = container.read(authProvider);
    expect(state.status, isNot(AuthStatus.authenticated));
    expect(state.error, 'invalid credentials');
    expect(secure.store[SecureKeys.authToken], isNull);
  });

  test('register creates the account then logs in as cashier', () async {
    adapter.onPost(
      '/api/v1/auth/register',
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'u2',
          'email': 'n@b.com',
          'name': 'New',
          'merchant_id': TestAccounts.testMerchantId,
          'roles': ['cashier'],
        },
      }),
      data: {'name': 'New', 'email': 'n@b.com', 'password': 'secret123'},
    );

    adapter.onPost(
      '/api/v1/auth/login',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'tokens': {
            'access_token': 'acc2',
            'refresh_token': 'ref2',
            'expires_in': 900,
          },
          'user': {
            'id': 'u2',
            'email': 'n@b.com',
            'name': 'New',
            'merchant_id': TestAccounts.testMerchantId,
            'roles': ['cashier'],
          },
          'merchant': {
            'id': TestAccounts.testMerchantId,
            'name': TestAccounts.testMerchantName,
          },
        },
      }),
      data: {'email': 'n@b.com', 'password': 'secret123'},
    );

    final ok = await container.read(authProvider.notifier).register(
          name: 'New',
          email: 'n@b.com',
          password: 'secret123',
        );

    expect(ok, isTrue);
    expect(container.read(authProvider).status, AuthStatus.authenticated);
    expect(secure.store[SecureKeys.userId], 'u2');
  });

  test('restore re-fetches the profile from a saved session', () async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
      userId: 'u1',
    );
    secure.store[SecureKeys.refreshToken] = 'ref';
    secure.store[SecureKeys.merchantJson] =
        '{"id":"${TestAccounts.testMerchantId}","name":"${TestAccounts.testMerchantName}"}';

    container.read(authProvider.notifier);
    await waitForResolution();

    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.name, 'Cashier Test');
    expect(state.user?.roles, contains('cashier'));
    expect(state.merchant?.id, TestAccounts.testMerchantId);
  });

  test('session expired callback clears auth state', () async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
      userId: 'u1',
    );

    container.read(authProvider.notifier);
    await waitForResolution();
    expect(container.read(authProvider).status, AuthStatus.authenticated);

    await locator<SessionGuard>().notifyExpired();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final state = container.read(authProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.error, kSessionExpiredMessage);
    expect(secure.store[SecureKeys.authToken], isNull);
  });
}
