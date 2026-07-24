import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  test('cashier user sees dispose food branch', () {
    final user = User(
      id: TestAccounts.cashierUserId,
      name: 'Cashier Test',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: const ['cashier'],
      features: TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.disposeFood.branchIndex));
    expect(branches, contains(ShellBranch.home.branchIndex));
  });

  test('user without menu disposals feature hides dispose food tab', () {
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
        PosFeatures.cashierBalance,
      ],
    );

    final branches = visibleShellBranches(user);

    expect(branches, isNot(contains(ShellBranch.disposeFood.branchIndex)));
    expect(branches, contains(ShellBranch.home.branchIndex));
  });

  test('requiredFeatureForLocation guards dispose food route', () {
    expect(
      requiredFeatureForLocation('/dispose-food'),
      PosFeatures.menuDisposals,
    );
  });
}
