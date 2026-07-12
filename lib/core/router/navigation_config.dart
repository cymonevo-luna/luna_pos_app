import '../../features/user/models/user.dart';
import 'app_router.dart';

/// Indexed shell branch indices. Order must match [app_router] branch list.
enum ShellBranch {
  home(0),
  transactions(1),
  calendar(2),
  messages(3),
  stock(4),
  purchases(5),
  profile(6);

  const ShellBranch(this.branchIndex);
  final int branchIndex;
}

/// Returns the post-login landing route for an authenticated user.
String defaultAuthenticatedRoute(User? user) {
  if (user == null) return AppRoute.login.path;
  if (user.hasCashierAccess) return AppRoute.home.path;
  if (user.hasOperationalAccess) return AppRoute.stock.path;
  return AppRoute.login.path;
}

bool _matchesPrefix(String location, String prefix) {
  return location == prefix || location.startsWith('$prefix/');
}

bool isCashierRoute(String location) {
  return location == AppRoute.home.path ||
      location == AppRoute.transactionHistory.path ||
      location == AppRoute.calendar.path ||
      location == AppRoute.messages.path ||
      location == AppRoute.cart.path ||
      location == AppRoute.checkout.path ||
      _matchesPrefix(location, AppRoute.transactionDetail.path.split(':').first);
}

bool isOperationalRoute(String location) {
  return _matchesPrefix(location, AppRoute.stock.path) ||
      _matchesPrefix(location, AppRoute.purchases.path);
}

/// Shell branch indices visible for the given user roles.
List<int> visibleShellBranches(User? user) {
  if (user == null) return const [];

  final branches = <int>[];
  if (user.hasCashierAccess) {
    branches.addAll([
      ShellBranch.home.branchIndex,
      ShellBranch.transactions.branchIndex,
      ShellBranch.calendar.branchIndex,
      ShellBranch.messages.branchIndex,
    ]);
  }
  if (user.hasOperationalAccess) {
    branches.addAll([
      ShellBranch.stock.branchIndex,
      ShellBranch.purchases.branchIndex,
    ]);
  }
  branches.add(ShellBranch.profile.branchIndex);
  return branches;
}
