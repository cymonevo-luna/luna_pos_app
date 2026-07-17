import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  test('operational user sees recurring expenses branch', () {
    const user = User(
      id: TestAccounts.operationalUserId,
      name: 'Operational Test',
      email: TestAccounts.operationalEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['operational'],
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.recurringExpenses.branchIndex));
    expect(branches, contains(ShellBranch.stock.branchIndex));
    expect(branches, contains(ShellBranch.purchases.branchIndex));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });

  test('manager user sees recurring expenses without procurement tabs', () {
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
    expect(branches, isNot(contains(ShellBranch.purchases.branchIndex)));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });
}
