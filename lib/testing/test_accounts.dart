/// Dedicated test accounts seeded by `luna_pos_service`.
///
/// Use these credentials for integration tests, Tester Agent flows, and manual
/// QA against an API where the dedicated-accounts migration has been applied.
/// Override via `--dart-define` in CI (e.g.
/// `--dart-define=TEST_CASHIER_EMAIL=...`).
abstract final class TestAccounts {
  static const adminEmail = String.fromEnvironment(
    'TEST_ADMIN_EMAIL',
    defaultValue: 'admin-test@cymonevo.com',
  );

  static const managerEmail = String.fromEnvironment(
    'TEST_MANAGER_EMAIL',
    defaultValue: 'manager-test@cymonevo.com',
  );

  static const cashierEmail = String.fromEnvironment(
    'TEST_CASHIER_EMAIL',
    defaultValue: 'cashier-test@cymonevo.com',
  );

  static const operationalEmail = String.fromEnvironment(
    'TEST_OPERATIONAL_EMAIL',
    defaultValue: 'operation-test@cymonevo.com',
  );

  static const password = String.fromEnvironment(
    'TEST_ACCOUNT_PASSWORD',
    defaultValue: 'LunaTesting123!',
  );

  static const testMerchantId = 'test-merchant-id';
  static const testMerchantName = 'Luna Test Merchant';

  /// Returns the email for [role].
  static String emailFor(TestAccountRole role) => switch (role) {
        TestAccountRole.admin => adminEmail,
        TestAccountRole.manager => managerEmail,
        TestAccountRole.cashier => cashierEmail,
        TestAccountRole.operational => operationalEmail,
      };

  /// Backend role string returned by the login API for each dedicated account.
  static String apiRoleFor(TestAccountRole role) => switch (role) {
        TestAccountRole.admin => 'admin',
        TestAccountRole.manager => 'manager',
        TestAccountRole.cashier => 'cashier',
        TestAccountRole.operational => 'operational',
      };

  /// Role list for API stubs. Pass [additionalRoles] for multi-role accounts.
  static List<String> apiRolesFor(
    TestAccountRole role, {
    List<String> additionalRoles = const [],
  }) {
    final roles = <String>{apiRoleFor(role), ...additionalRoles};
    return roles.toList();
  }
}

/// Role-specific dedicated test accounts from `luna_pos_service` seed data.
enum TestAccountRole {
  admin,
  manager,
  cashier,
  operational,
}
