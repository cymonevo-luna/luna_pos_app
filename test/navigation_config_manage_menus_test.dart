import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

void main() {
  test('cashier with menus manage feature sees manage menus branch', () {
    const user = User(
      id: TestAccounts.cashierUserId,
      name: 'Cashier Test',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['cashier'],
      features: [
        PosFeatures.menu,
        PosFeatures.transactions,
        PosFeatures.menusManage,
      ],
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.home.branchIndex));
    expect(branches, contains(ShellBranch.manageMenus.branchIndex));
    expect(branches, contains(ShellBranch.profile.branchIndex));
  });

  test('user without menus manage feature hides manage menus tab', () {
    const user = User(
      id: TestAccounts.cashierUserId,
      name: 'Cashier Test',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['cashier'],
      features: [
        PosFeatures.menu,
        PosFeatures.transactions,
      ],
    );

    final branches = visibleShellBranches(user);

    expect(branches, contains(ShellBranch.home.branchIndex));
    expect(branches, isNot(contains(ShellBranch.manageMenus.branchIndex)));
  });

  test('requiredFeatureForLocation guards manage menus routes', () {
    expect(
      requiredFeatureForLocation('/manage-menus'),
      PosFeatures.menusManage,
    );
    expect(
      requiredFeatureForLocation('/manage-menus/new'),
      PosFeatures.menusManage,
    );
    expect(
      requiredFeatureForLocation('/manage-menus/menu-1/edit'),
      PosFeatures.menusManage,
    );
  });

  test('isCashierRoute includes manage menus routes', () {
    expect(isCashierRoute('/manage-menus'), isTrue);
    expect(isCashierRoute('/manage-menus/new'), isTrue);
    expect(isCashierRoute('/manage-menus/menu-1/edit'), isTrue);
  });

  test('user without menus manage feature is redirected from manage menus', () {
    const user = User(
      id: TestAccounts.cashierUserId,
      name: 'Menu Only',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['cashier'],
      features: [PosFeatures.menu, PosFeatures.transactions],
    );

    final requiredFeature =
        requiredFeatureForLocation(AppRoute.manageMenus.path);

    expect(requiredFeature, PosFeatures.menusManage);
    expect(user.hasFeature(requiredFeature!), isFalse);
    expect(defaultAuthenticatedRoute(user), isNot(AppRoute.manageMenus.path));
    expect(defaultAuthenticatedRoute(user), AppRoute.home.path);
  });

  test('selling menu route still requires pos.menu feature', () {
    expect(
      requiredFeatureForLocation(AppRoute.home.path),
      PosFeatures.menu,
    );
  });
}
