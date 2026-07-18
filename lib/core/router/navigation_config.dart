import '../../features/user/models/user.dart';
import 'app_router.dart';
import 'pos_features.dart';

/// Indexed shell branch indices. Order must match [app_router] branch list.
enum ShellBranch {
  home(0),
  transactions(1),
  calendar(2),
  stock(3),
  purchases(4),
  recurringExpenses(5),
  cashierBalance(6),
  profile(7);

  const ShellBranch(this.branchIndex);
  final int branchIndex;
}

final _defaultRoutePriority = <({String feature, String route})>[
  (feature: PosFeatures.menu, route: AppRoute.home.path),
  (
    feature: PosFeatures.transactions,
    route: AppRoute.transactionHistory.path,
  ),
  (feature: PosFeatures.productionRequests, route: AppRoute.calendar.path),
  (feature: PosFeatures.stock, route: AppRoute.stock.path),
  (feature: PosFeatures.purchases, route: AppRoute.purchases.path),
  (
    feature: PosFeatures.recurringExpenses,
    route: AppRoute.recurringExpenses.path,
  ),
  (
    feature: PosFeatures.cashierBalance,
    route: AppRoute.cashierBalance.path,
  ),
];

/// Returns the post-login landing route for an authenticated user.
String defaultAuthenticatedRoute(User? user) {
  if (user == null || !user.canAccessPosApp) return AppRoute.login.path;

  for (final entry in _defaultRoutePriority) {
    if (user.hasFeature(entry.feature)) return entry.route;
  }

  return AppRoute.profile.path;
}

bool _matchesPrefix(String location, String prefix) {
  return location == prefix || location.startsWith('$prefix/');
}

bool isCashierRoute(String location) {
  return location == AppRoute.home.path ||
      location == AppRoute.transactionHistory.path ||
      location == AppRoute.calendar.path ||
      location == AppRoute.cart.path ||
      location == AppRoute.checkout.path ||
      _matchesPrefix(location, AppRoute.transactionDetail.path.split(':').first) ||
      _matchesPrefix(
        location,
        AppRoute.productionRequestDetail.path.split(':').first,
      ) ||
      _matchesPrefix(location, AppRoute.cashierBalance.path);
}

bool isOperationalRoute(String location) {
  return _matchesPrefix(location, AppRoute.stock.path) ||
      _matchesPrefix(location, AppRoute.purchases.path);
}

bool isRecurringExpenseRoute(String location) {
  return _matchesPrefix(location, AppRoute.recurringExpenses.path);
}

bool hasRecurringExpenseAccess(User user) {
  return user.hasFeature(PosFeatures.recurringExpenses);
}

/// Feature key required to access [location], or null when unrestricted.
String? requiredFeatureForLocation(String location) {
  if (location == AppRoute.home.path) return PosFeatures.menu;
  if (location == AppRoute.transactionHistory.path ||
      _matchesPrefix(location, AppRoute.transactionDetail.path.split(':').first)) {
    return PosFeatures.transactions;
  }
  if (location == AppRoute.calendar.path ||
      _matchesPrefix(
        location,
        AppRoute.productionRequestDetail.path.split(':').first,
      )) {
    return PosFeatures.productionRequests;
  }
  if (_matchesPrefix(location, AppRoute.stock.path)) return PosFeatures.stock;
  if (_matchesPrefix(location, AppRoute.purchases.path)) {
    return PosFeatures.purchases;
  }
  if (_matchesPrefix(location, AppRoute.recurringExpenses.path)) {
    return PosFeatures.recurringExpenses;
  }
  if (_matchesPrefix(location, AppRoute.cashierBalance.path)) {
    return PosFeatures.cashierBalance;
  }
  if (location == AppRoute.cart.path || location == AppRoute.checkout.path) {
    return PosFeatures.menu;
  }
  return null;
}

/// Shell branch indices visible for the given user features.
List<int> visibleShellBranches(User? user) {
  if (user == null || !user.canAccessPosApp) return const [];

  final branches = <int>[];
  if (user.hasFeature(PosFeatures.menu)) {
    branches.add(ShellBranch.home.branchIndex);
  }
  if (user.hasFeature(PosFeatures.transactions)) {
    branches.add(ShellBranch.transactions.branchIndex);
  }
  if (user.hasFeature(PosFeatures.productionRequests)) {
    branches.add(ShellBranch.calendar.branchIndex);
  }
  if (user.hasFeature(PosFeatures.stock)) {
    branches.add(ShellBranch.stock.branchIndex);
  }
  if (user.hasFeature(PosFeatures.purchases)) {
    branches.add(ShellBranch.purchases.branchIndex);
  }
  if (user.hasFeature(PosFeatures.recurringExpenses)) {
    branches.add(ShellBranch.recurringExpenses.branchIndex);
  }
  if (user.hasFeature(PosFeatures.cashierBalance)) {
    branches.add(ShellBranch.cashierBalance.branchIndex);
  }
  branches.add(ShellBranch.profile.branchIndex);
  return branches;
}
