import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/user/models/user.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/auth/splash_page.dart';
import '../../features/menu/menu_page.dart';
import '../../features/order/cart_page.dart';
import '../../features/order/checkout_page.dart';
import '../../features/order/order_controller.dart';
import '../../features/production_request/production_request_detail_page.dart';
import '../../features/production_request/production_request_list_page.dart';
import '../../features/purchase/purchase_create_page.dart';
import '../../features/purchase/purchase_detail_page.dart';
import '../../features/purchase/purchase_list_page.dart';
import '../../features/cashier_balance/cashier_balance_page.dart';
import '../../features/menu_disposal/dispose_food_page.dart';
import '../../features/purchase/smart_purchase_request_page.dart';
import '../../features/recurring_expense/recurring_expense_form_sheet.dart';
import '../../features/recurring_expense/recurring_expense_list_page.dart';
import '../../features/stock/stock_form_sheet.dart';
import '../../features/stock/stock_list_page.dart';
import '../../features/daily_menu_summary/daily_menu_summary_page.dart';
import '../../features/transaction/transaction_detail_page.dart';
import '../../features/transaction/transaction_history_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/settings/settings_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import 'navigation_config.dart';

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
  stock('/stock'),
  stockNew('/stock/new'),
  stockEdit('/stock/:id/edit'),
  purchases('/purchases'),
  purchasesNew('/purchases/new'),
  purchasesSmartRequest('/purchases/smart-request'),
  purchaseDetail('/purchases/:id'),
  recurringExpenses('/recurring-expenses'),
  recurringExpensesNew('/recurring-expenses/new'),
  recurringExpensesEdit('/recurring-expenses/:id/edit'),
  cashierBalance('/cashier-balance'),
  disposeFood('/dispose-food'),
  profile('/profile'),
  settings('/settings'),
  details('/details'),
  cart('/cart'),
  checkout('/checkout'),
  transactionDetail('/transactions/:id'),
  dailyMenuSummary('/transactions/daily-menu-summary'),
  productionRequestDetail('/production-requests/:id');

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
    final user = ref.read(authProvider).user;
    return defaultAuthenticatedRoute(user);
  }

  return null;
}

String? _featureRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  if (auth.status != AuthStatus.authenticated) return null;

  final user = auth.user;
  if (user == null) return null;

  final location = state.matchedLocation;
  final requiredFeature = requiredFeatureForLocation(location);
  if (requiredFeature != null && !user.hasFeature(requiredFeature)) {
    return defaultAuthenticatedRoute(user);
  }

  return null;
}

String? _legacyRouteRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  if (auth.status != AuthStatus.authenticated) return null;

  final location = state.uri.path;
  if (location == AppRoute.messages.path) {
    return defaultAuthenticatedRoute(auth.user);
  }

  return null;
}

String? _redirect(Ref ref, GoRouterState state) {
  final authResult = _authRedirect(ref, state);
  if (authResult != null) return authResult;
  final legacyResult = _legacyRouteRedirect(ref, state);
  if (legacyResult != null) return legacyResult;
  final featureResult = _featureRedirect(ref, state);
  if (featureResult != null) return featureResult;
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
    return defaultAuthenticatedRoute(auth.user);
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
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
                builder: (context, state) =>
                    const ProductionRequestListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.stock.path,
                name: AppRoute.stock.name,
                builder: (context, state) => const StockListPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.stockNew.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const StockFormPage(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    name: AppRoute.stockEdit.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => StockEditPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.purchases.path,
                name: AppRoute.purchases.name,
                builder: (context, state) => const PurchaseListPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.purchasesNew.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const PurchaseCreatePage(),
                  ),
                  GoRoute(
                    path: 'smart-request',
                    name: AppRoute.purchasesSmartRequest.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const SmartPurchaseRequestPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: AppRoute.purchaseDetail.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => PurchaseDetailPage(
                      purchaseId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.recurringExpenses.path,
                name: AppRoute.recurringExpenses.name,
                builder: (context, state) => const RecurringExpenseListPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: AppRoute.recurringExpensesNew.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        const RecurringExpenseFormPage(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    name: AppRoute.recurringExpensesEdit.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => RecurringExpenseEditPage(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.cashierBalance.path,
                name: AppRoute.cashierBalance.name,
                builder: (context, state) => const CashierBalancePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.disposeFood.path,
                name: AppRoute.disposeFood.name,
                builder: (context, state) => const DisposeFoodPage(),
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
        path: AppRoute.dailyMenuSummary.path,
        name: AppRoute.dailyMenuSummary.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DailyMenuSummaryPage(),
      ),
      GoRoute(
        path: AppRoute.transactionDetail.path,
        name: AppRoute.transactionDetail.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TransactionDetailPage(
          transactionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoute.productionRequestDetail.path,
        name: AppRoute.productionRequestDetail.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ProductionRequestDetailPage(
          requestId: state.pathParameters['id']!,
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
