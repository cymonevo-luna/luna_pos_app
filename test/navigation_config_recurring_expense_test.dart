import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  test('operational user sees recurring expenses branch', () {
    final user = User(
      id: TestAccounts.operationalUserId,
      name: 'Operational Test',
      email: TestAccounts.operationalEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['operational'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.operational),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.recurringExpenses.branchIndex));
    expect(branches, contains(ShellBranch.stock.branchIndex));
    expect(branches, contains(ShellBranch.purchases.branchIndex));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });

  test('manager user sees recurring expenses without procurement tabs', () {
    final user = User(
      id: TestAccounts.managerUserId,
      name: 'Manager Test',
      email: TestAccounts.managerEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['manager'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.manager),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.recurringExpenses.branchIndex));
    expect(branches, isNot(contains(ShellBranch.stock.branchIndex)));
    expect(branches, isNot(contains(ShellBranch.purchases.branchIndex)));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });

  test('operational user without stock feature hides stock tab', () {
    final user = User(
      id: TestAccounts.operationalUserId,
      name: 'Operational Test',
      email: TestAccounts.operationalEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['operational'],
      features: const [
        PosFeatures.purchases,
        PosFeatures.recurringExpenses,
      ],
    );

    final branches = visibleShellBranches(user);

    expect(branches, isNot(contains(ShellBranch.stock.branchIndex)));
    expect(branches, contains(ShellBranch.purchases.branchIndex));
    expect(branches, contains(ShellBranch.recurringExpenses.branchIndex));
  });

  test('legacy role mapping applies when features are absent', () {
    const user = User(
      id: TestAccounts.managerUserId,
      name: 'Manager Test',
      email: TestAccounts.managerEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['manager'],
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.recurringExpenses.branchIndex));
    expect(branches, isNot(contains(ShellBranch.stock.branchIndex)));
  });
}
