import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  group('TestAccounts', () {
    test('defaults match luna_pos_service seeded dedicated accounts', () {
      expect(TestAccounts.adminEmail, 'admin-test@cymonevo.com');
      expect(TestAccounts.managerEmail, 'manager-test@cymonevo.com');
      expect(TestAccounts.cashierEmail, 'cashier-test@cymonevo.com');
      expect(TestAccounts.operationalEmail, 'operation-test@cymonevo.com');
      expect(TestAccounts.cookEmail, 'cook-test@cymonevo.com');
      expect(TestAccounts.password, 'LunaTesting123!');
    });

    test('emailFor returns the role-specific dedicated account', () {
      expect(
        TestAccounts.emailFor(TestAccountRole.admin),
        TestAccounts.adminEmail,
      );
      expect(
        TestAccounts.emailFor(TestAccountRole.manager),
        TestAccounts.managerEmail,
      );
      expect(
        TestAccounts.emailFor(TestAccountRole.cashier),
        TestAccounts.cashierEmail,
      );
      expect(
        TestAccounts.emailFor(TestAccountRole.operational),
        TestAccounts.operationalEmail,
      );
      expect(
        TestAccounts.emailFor(TestAccountRole.cook),
        TestAccounts.cookEmail,
      );
    });

    test('apiRoleFor maps to backend role strings', () {
      expect(TestAccounts.apiRoleFor(TestAccountRole.admin), 'admin');
      expect(TestAccounts.apiRoleFor(TestAccountRole.manager), 'manager');
      expect(TestAccounts.apiRoleFor(TestAccountRole.cashier), 'cashier');
      expect(
        TestAccounts.apiRoleFor(TestAccountRole.operational),
        'operational',
      );
      expect(TestAccounts.apiRoleFor(TestAccountRole.cook), 'cook');
    });

    test('apiRolesFor supports multi-role accounts', () {
      expect(
        TestAccounts.apiRolesFor(TestAccountRole.cashier),
        ['cashier'],
      );
      expect(
        TestAccounts.apiRolesFor(
          TestAccountRole.cashier,
          additionalRoles: const ['operational'],
        ),
        containsAll(['cashier', 'operational']),
      );
    });

    test('userIdFor maps to seeded stable UUIDs', () {
      expect(
        TestAccounts.userIdFor(TestAccountRole.cashier),
        '11111111-1111-4111-8111-111111111103',
      );
      expect(
        TestAccounts.userIdFor(TestAccountRole.admin),
        TestAccounts.adminUserId,
      );
    });
  });
}
