import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/auth/token_refresh_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';

import 'helpers/auth_harness.dart';

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;
  late TokenRefreshService tokenRefresh;

  setUp(() {
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient(
      secure: secure,
      withAuthInterceptor: false,
    );
    adapter = mocked.adapter;
    tokenRefresh = TokenRefreshService(
      secureStorage: secure,
      dio: mocked.client.raw,
      onSessionExpired: () {},
    );
  });

  test('refresh persists rotated tokens and expiry timestamps', () async {
    secure.store[SecureKeys.refreshToken] = 'ref';
    secure.store[SecureKeys.refreshExpiresAt] =
        '${DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch}';

    stubTokenRefresh(adapter, refreshToken: 'ref');

    final ok = await tokenRefresh.refresh();

    expect(ok, isTrue);
    expect(secure.store[SecureKeys.authToken], 'acc-new');
    expect(secure.store[SecureKeys.refreshToken], 'ref-new');
    expect(secure.store[SecureKeys.accessExpiresAt], isNotNull);
    expect(secure.store[SecureKeys.refreshExpiresAt], isNotNull);
  });

  test('refresh returns false when refresh token is expired', () async {
    secure.store[SecureKeys.refreshToken] = 'ref';
    secure.store[SecureKeys.refreshExpiresAt] =
        '${DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch}';

    final ok = await tokenRefresh.refresh();

    expect(ok, isFalse);
  });

  test('isAccessExpiringSoon is true within the 2-minute buffer', () async {
    secure.store[SecureKeys.accessExpiresAt] =
        '${DateTime.now().add(const Duration(minutes: 1)).millisecondsSinceEpoch}';

    expect(await tokenRefresh.isAccessExpiringSoon, isTrue);
  });

  test('isAccessExpiringSoon is false when access token has ample TTL',
      () async {
    secure.store[SecureKeys.accessExpiresAt] =
        '${DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch}';

    expect(await tokenRefresh.isAccessExpiringSoon, isFalse);
  });
}
