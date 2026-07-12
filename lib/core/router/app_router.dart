import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/auth/splash_page.dart';
import '../../features/menu/menu_page.dart';
import '../../features/order/cart_page.dart';
import '../../features/order/checkout_page.dart';
import '../../features/order/order_controller.dart';
import '../../features/placeholder/coming_soon_page.dart';
import '../../features/transaction/transaction_detail_page.dart';
import '../../features/transaction/transaction_history_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/settings/settings_page.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/main_scaffold.dart';

/// Centralized route names/paths. Reference these instead of raw strings:
/// `context.goNamed(AppRoute.home.name)`.
enum AppRoute {
  splash('/'),
  login('/login'),
  register('/register'),
  home('/home'),
  transactionHistory('/transactions'),
  calendar('/calendar'),
  messages('/messages'),
  profile('/profile'),
  settings('/settings'),
  details('/details'),
  cart('/cart'),
  checkout('/checkout'),
  transactionDetail('/transactions/:id');

  const AppRoute(this.path);
  final String path;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(this.ref) {
    _subscription = ref.listen(authProvider, (_, _) => notifyListeners());
  }

  final Ref ref;
  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

String? _orderRedirect(Ref ref, GoRouterState state) {
  final location = state.matchedLocation;
  final isCheckout = location == AppRoute.checkout.path;

  if (!isCheckout) return null;

  final order = ref.read(orderProvider);
  if (order.lines.isEmpty) {
    return AppRoute.home.path;
  }

  return null;
}

String? _redirect(Ref ref, GoRouterState state) {
  final authResult = _authRedirect(ref, state);
  if (authResult != null) return authResult;
  return _orderRedirect(ref, state);
}

String? _authRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final location = state.matchedLocation;
  final isSplash = location == AppRoute.splash.path;
  final isAuthRoute =
      location == AppRoute.login.path || location == AppRoute.register.path;

  if (auth.status == AuthStatus.unknown) return null;

  if (auth.status == AuthStatus.unauthenticated) {
    if (isSplash || isAuthRoute) return null;
    return AppRoute.login.path;
  }

  if (auth.status == AuthStatus.authenticated && (isSplash || isAuthRoute)) {
    return AppRoute.home.path;
  }

  return null;
}

/// The app's router. Bottom-navigation tabs live inside a
/// [StatefulShellRoute.indexedStack] so each tab is instantiated only once and
/// kept alive; everything else (auth, settings, details) sits on the root
/// navigator and is presented over the shell.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
    GoRoute(
      path: AppRoute.splash.path,
      name: AppRoute.splash.name,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoute.register.path,
      name: AppRoute.register.name,
      builder: (context, state) => const RegisterPage(),
    ),
    StatefulShellRoute(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      navigatorContainerBuilder: (context, navigationShell, children) =>
          AnimatedBranchContainer(
        currentIndex: navigationShell.currentIndex,
        children: children,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              name: AppRoute.home.name,
              builder: (context, state) => const MenuPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.transactionHistory.path,
              name: AppRoute.transactionHistory.name,
              builder: (context, state) => const TransactionHistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.calendar.path,
              name: AppRoute.calendar.name,
              builder: (context, state) => ComingSoonPage(
                title: AppLocalizations.of(context).calendar,
                icon: Icons.calendar_today_outlined,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.messages.path,
              name: AppRoute.messages.name,
              builder: (context, state) => ComingSoonPage(
                title: AppLocalizations.of(context).messages,
                icon: Icons.chat_bubble_outline,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.profile.path,
              name: AppRoute.profile.name,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.settings.path,
      name: AppRoute.settings.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoute.details.path,
      name: AppRoute.details.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const _DetailsPage(),
    ),
    GoRoute(
      path: AppRoute.cart.path,
      name: AppRoute.cart.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: AppRoute.checkout.path,
      name: AppRoute.checkout.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: AppRoute.transactionDetail.path,
      name: AppRoute.transactionDetail.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => TransactionDetailPage(
        transactionId: state.pathParameters['id']!,
      ),
    ),
  ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

/// Placeholder destination to demonstrate navigation. Replace with real pages.
class _DetailsPage extends StatelessWidget {
  const _DetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: const Center(child: Text('Details page')),
    );
  }
}
