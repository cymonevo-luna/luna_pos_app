import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  test('cashier user sees cashier balance branch', () {
    final user = User(
      id: TestAccounts.cashierUserId,
      name: 'Cashier Test',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['cashier'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.cashierBalance.branchIndex));
    expect(branches, contains(ShellBranch.home.branchIndex));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });

  test('operational user sees cashier balance branch', () {
    final user = User(
      id: TestAccounts.operationalUserId,
      name: 'Operational Test',
      email: TestAccounts.operationalEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['operational'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.operational),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.cashierBalance.branchIndex));
    expect(branches, contains(ShellBranch.stock.branchIndex));
  });

  test('manager user sees cashier balance branch', () {
    final user = User(
      id: TestAccounts.managerUserId,
      name: 'Manager Test',
      email: TestAccounts.managerEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['manager'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.manager),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.cashierBalance.branchIndex));
    expect(branches, isNot(contains(ShellBranch.stock.branchIndex)));
  });

  test('user without cashier balance feature hides tab', () {
    const user = User(
      id: TestAccounts.cashierUserId,
      name: 'Cashier Test',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['cashier'],
      features: [
        PosFeatures.menu,
        PosFeatures.transactions,
        PosFeatures.productionRequests,
      ],
    );

    final branches = visibleShellBranches(user);

    expect(branches, isNot(contains(ShellBranch.cashierBalance.branchIndex)));
    expect(branches, contains(ShellBranch.home.branchIndex));
  });

  test('requiredFeatureForLocation guards cashier balance route', () {
    expect(
      requiredFeatureForLocation('/cashier-balance'),
      PosFeatures.cashierBalance,
    );
  });
}
