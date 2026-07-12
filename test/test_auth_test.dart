import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart';

import 'helpers/auth_harness.dart';

void main() {
  group('loginAsTestRole', () {
    late FakeSecureStorage secure;

    setUp(() {
      secure = FakeSecureStorage();
    });

    test('returns cashier session with seeded user id and persists tokens',
        () async {
      final mocked = buildMockedApiClient();
      stubDedicatedAccountLogin(mocked.adapter, TestAccountRole.cashier);

      final session = await loginAsTestRole(
        mocked.client,
        secure,
        TestAccountRole.cashier,
      );

      expect(session.accessToken, 'acc');
      expect(session.refreshToken, 'ref');
      expect(session.user.role, 'cashier');
      expect(session.user.id, TestAccounts.cashierUserId);
      expect(session.user.email, TestAccounts.cashierEmail);
      expect(secure.store[SecureKeys.authToken], 'acc');
      expect(secure.store[SecureKeys.refreshToken], 'ref');
      expect(secure.store[SecureKeys.userId], TestAccounts.cashierUserId);
    });

    test('admin login uses dedicated admin account', () async {
      final mocked = buildMockedApiClient();
      stubDedicatedAccountLogin(mocked.adapter, TestAccountRole.admin);

      final session = await loginAsTestRole(
        mocked.client,
        secure,
        TestAccountRole.admin,
      );

      expect(session.accessToken, isNotEmpty);
      expect(session.user.role, 'admin');
      expect(session.user.email, TestAccounts.adminEmail);
      expect(session.user.id, TestAccounts.adminUserId);
    });
  });
}
