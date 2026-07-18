import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/di/locator.dart';
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
    registerAuthTestServices(secure: secure, client: mocked.client);
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
    expect(state.user?.features, contains('pos.menu'));
    expect(state.merchant?.id, TestAccounts.testMerchantId);
    expect(secure.store[SecureKeys.authToken], 'acc');
    expect(secure.store[SecureKeys.refreshToken], 'ref');
    expect(secure.store[SecureKeys.accessExpiresAt], isNotNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNotNull);
    expect(secure.store[SecureKeys.userId], 'u1');
    expect(secure.store[SecureKeys.userJson], isNotNull);
    expect(secure.store[SecureKeys.merchantJson], isNotNull);
  });

  test('manager-only login persists the session and authenticates', () async {
    stubDedicatedAccountLogin(adapter, TestAccountRole.manager, userId: 'mgr');

    final ok = await container.read(authProvider.notifier).login(
          email: TestAccounts.managerEmail,
          password: TestAccounts.password,
        );

    expect(ok, isTrue);
    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.roles, contains('manager'));
    expect(secure.store[SecureKeys.authToken], 'acc');
    expect(secure.store[SecureKeys.userJson], isNotNull);
  });

  test('admin-only login is rejected without storing tokens', () async {
    stubDedicatedAccountLogin(adapter, TestAccountRole.admin, userId: 'adm');

    final ok = await container.read(authProvider.notifier).login(
          email: TestAccounts.adminEmail,
          password: TestAccounts.password,
        );

    expect(ok, isFalse);
    final state = container.read(authProvider);
    expect(state.status, isNot(AuthStatus.authenticated));
    expect(state.error, kPosAccessDeniedMessage);
    expect(state.user, isNull);
    expect(secure.store[SecureKeys.authToken], isNull);
    expect(secure.store[SecureKeys.userJson], isNull);
  });

  test('operational-only login persists the session and authenticates', () async {
    stubDedicatedAccountLogin(
      adapter,
      TestAccountRole.operational,
      userId: 'op-user',
    );

    final ok = await container.read(authProvider.notifier).login(
          email: TestAccounts.operationalEmail,
          password: TestAccounts.password,
        );

    expect(ok, isTrue);
    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.roles, contains('operational'));
    expect(state.user?.roles, isNot(contains('cashier')));
    expect(secure.store[SecureKeys.authToken], 'acc');
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
            'refresh_expires_in': 604800,
          },
          'user': {
            'id': 'u2',
            'email': 'n@b.com',
            'name': 'New',
            'merchant_id': TestAccounts.testMerchantId,
            'roles': ['cashier'],
            'features': TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
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

  test('restore refreshes tokens from secure storage on launch', () async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
      userId: 'u1',
    );
    secure.store[SecureKeys.merchantJson] =
        '{"id":"${TestAccounts.testMerchantId}","name":"${TestAccounts.testMerchantName}"}';

    container.read(authProvider.notifier);
    await waitForResolution();

    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.name, 'Cashier Test');
    expect(state.user?.roles, contains('cashier'));
    expect(state.user?.features, contains('pos.menu'));
    expect(state.merchant?.id, TestAccounts.testMerchantId);
    expect(secure.store[SecureKeys.authToken], 'acc-new');
    expect(secure.store[SecureKeys.refreshToken], 'ref-new');
    expect(secure.store[SecureKeys.accessExpiresAt], isNotNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNotNull);
  });

  test('restore replaces stored features from profile endpoint', () async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
      userId: 'op-user',
    );
    secure.store[SecureKeys.userJson] = jsonEncode({
      'id': 'op-user',
      'email': TestAccounts.operationalEmail,
      'name': 'Operational Test',
      'merchant_id': TestAccounts.testMerchantId,
      'roles': ['operational'],
      'features': TestAccounts.apiFeaturesFor(TestAccountRole.operational),
    });

    adapter.onGet(
      '/api/v1/users/op-user',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'op-user',
          'email': TestAccounts.operationalEmail,
          'name': 'Operational Test',
          'merchant_id': TestAccounts.testMerchantId,
          'roles': ['operational'],
          'features': const [
            'pos.purchases',
            'pos.recurring_expenses',
          ],
        },
      }),
    );

    container.read(authProvider.notifier);
    await waitForResolution();

    final state = container.read(authProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.features, contains('pos.purchases'));
    expect(state.user?.features, isNot(contains('pos.stock')));
  });

  test('expired refresh token on launch clears storage and stays signed out',
      () async {
    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
      userId: 'u1',
      refreshExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    container.read(authProvider.notifier);
    await waitForResolution();

    final state = container.read(authProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(secure.store[SecureKeys.authToken], isNull);
    expect(secure.store[SecureKeys.refreshToken], isNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNull);
  });

  test('logout clears all stored credentials including expiry', () async {
    stubDedicatedAccountLogin(adapter, TestAccountRole.cashier, userId: 'u1');

    await container.read(authProvider.notifier).login(
          email: TestAccounts.cashierEmail,
          password: TestAccounts.password,
        );
    expect(container.read(authProvider).status, AuthStatus.authenticated);

    await container.read(authProvider.notifier).logout();

    expect(container.read(authProvider).status, AuthStatus.unauthenticated);
    expect(secure.store[SecureKeys.authToken], isNull);
    expect(secure.store[SecureKeys.refreshToken], isNull);
    expect(secure.store[SecureKeys.accessExpiresAt], isNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNull);
    expect(secure.store[SecureKeys.userId], isNull);
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
    expect(secure.store[SecureKeys.refreshToken], isNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNull);
  });
}
