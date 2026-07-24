import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/core/router/shell_branch_provider.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_page.dart';
import 'package:luna_pos/features/daily_menu_summary/models/daily_menu_summary.dart';
import 'package:luna_pos/features/transaction/transaction_history_controller.dart';
import 'package:luna_pos/features/transaction/transaction_history_page.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';

class _CashierAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: const ['cashier'],
          features: TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
        ),
      );
}

class _TransactionsShellNotifier extends ShellBranchNotifier {
  @override
  int build() => ShellBranch.transactions.branchIndex;
}

class _MockTransactionHistoryController extends TransactionHistoryController {
  @override
  TransactionHistoryState build() => const TransactionHistoryState(
        items: [],
        page: 1,
      );

  @override
  Future<void> loadIfNeeded() async {}
}

class _MockDailyMenuSummaryController extends DailyMenuSummaryController {
  @override
  DailyMenuSummaryState build() => DailyMenuSummaryState(
        summary: const DailyMenuSummaryResponse(
          dateFrom: '2026-07-24',
          dateTo: '2026-07-24',
          totalQuantity: 0,
          totalRevenue: 0,
          menus: [],
        ),
      );

  @override
  Future<void> loadIfNeeded() async {}
}

void main() {
  test('requiredFeatureForLocation guards daily menu summary route', () {
    expect(
      requiredFeatureForLocation('/transactions/daily-menu-summary'),
      PosFeatures.transactions,
    );
  });

  test('isCashierRoute includes daily menu summary route', () {
    expect(
      isCashierRoute('/transactions/daily-menu-summary'),
      isTrue,
    );
  });

  test('user without transactions feature is redirected from daily menu summary',
      () {
    const user = User(
      id: TestAccounts.cashierUserId,
      name: 'Menu Only',
      email: TestAccounts.cashierEmail,
      merchantId: TestAccounts.testMerchantId,
      roles: ['cashier'],
      features: [PosFeatures.menu],
    );

    final requiredFeature =
        requiredFeatureForLocation(AppRoute.dailyMenuSummary.path);

    expect(requiredFeature, PosFeatures.transactions);
    expect(user.hasFeature(requiredFeature!), isFalse);
    expect(defaultAuthenticatedRoute(user), isNot(AppRoute.dailyMenuSummary.path));
    expect(defaultAuthenticatedRoute(user), AppRoute.home.path);
  });

  testWidgets('transaction history app bar action navigates to summary screen',
      (tester) async {
    final router = GoRouter(
      initialLocation: AppRoute.transactionHistory.path,
      routes: [
        GoRoute(
          path: AppRoute.transactionHistory.path,
          name: AppRoute.transactionHistory.name,
          builder: (context, state) => const TransactionHistoryPage(),
        ),
        GoRoute(
          path: AppRoute.dailyMenuSummary.path,
          name: AppRoute.dailyMenuSummary.name,
          builder: (context, state) => const DailyMenuSummaryPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_CashierAuthController.new),
          shellCurrentBranchProvider.overrideWith(_TransactionsShellNotifier.new),
          transactionHistoryProvider
              .overrideWith(_MockTransactionHistoryController.new),
          dailyMenuSummaryController
              .overrideWith(_MockDailyMenuSummaryController.new),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TransactionHistoryPage), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('transaction_history_daily_menu_summary_button')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DailyMenuSummaryPage), findsOneWidget);
    expect(router.state.matchedLocation, AppRoute.dailyMenuSummary.path);
  });
}
