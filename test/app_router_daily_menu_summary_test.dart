import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/core/router/shell_branch_provider.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_page.dart';
import 'package:luna_pos/features/menu/menu_controller.dart' as menu_ctrl;
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';
import 'package:luna_pos/features/transaction/transaction_detail_controller.dart';
import 'package:luna_pos/features/transaction/transaction_detail_page.dart';
import 'package:luna_pos/features/transaction/transaction_history_controller.dart';
import 'package:luna_pos/features/transaction/transaction_history_page.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'daily_menu_summary_page_test.dart' show sampleSummary;
import 'helpers/auth_harness.dart';

const _transactionUuid = '550e8400-e29b-41d4-a716-446655440000';

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

class _MenuOnlyAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: const User(
          id: TestAccounts.cashierUserId,
          name: 'Menu Only',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: ['cashier'],
          features: [PosFeatures.menu],
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
  DailyMenuSummaryState build() =>
      DailyMenuSummaryState(summary: sampleSummary());

  @override
  Future<void> loadIfNeeded() async {}
}

class _MockMenuPageController extends menu_ctrl.MenuController {
  @override
  menu_ctrl.MenuState build() => const menu_ctrl.MenuState();

  @override
  Future<void> loadIfNeeded() async {}
}

class _MockTransactionDetailController extends TransactionDetailController {
  _MockTransactionDetailController(this._transactionId) : super(_transactionId);

  final String _transactionId;

  @override
  TransactionDetailState build() => TransactionDetailState(
        detail: TransactionDetail(
          id: _transactionId,
          method: 'CASH',
          items: const [
            TransactionItemRequest(
              menuId: 'menu-1',
              title: 'Nasi Goreng',
              quantity: 1,
              unitPrice: 35000,
              lineTotal: 35000,
            ),
          ],
          subtotalAmount: 35000,
          amount: 35000,
        ),
      );
}

ProviderContainer _buildContainer({
  AuthController Function()? authFactory,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(authFactory ?? _CashierAuthController.new),
      shellCurrentBranchProvider.overrideWith(_TransactionsShellNotifier.new),
      menu_ctrl.menuProvider.overrideWith(_MockMenuPageController.new),
      transactionHistoryProvider
          .overrideWith(_MockTransactionHistoryController.new),
      dailyMenuSummaryController
          .overrideWith(_MockDailyMenuSummaryController.new),
    ],
  );
}

Future<GoRouter> pumpRouterApp(
  WidgetTester tester, {
  required ProviderContainer container,
}) async {
  final router = container.read(routerProvider);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pump();

  return router;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await locator.reset();
    final mocked = buildMockedApiClient();
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerSingleton<PreferencesService>(
        await PreferencesService.create(),
      );
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets(
    'summarize button opens DailyMenuSummaryPage via full router',
    (tester) async {
      final container = _buildContainer();
      addTearDown(container.dispose);

      final router = await pumpRouterApp(tester, container: container);

      router.go(AppRoute.transactionHistory.path);
      await tester.pumpAndSettle();

      expect(find.byType(TransactionHistoryPage), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('transaction_history_daily_menu_summary_button')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DailyMenuSummaryPage), findsOneWidget);
      expect(find.byType(TransactionDetailPage), findsNothing);
      expect(router.state.matchedLocation, AppRoute.dailyMenuSummary.path);
      expect(find.text('Daily Menu Summary'), findsOneWidget);
      expect(find.text('Transaction Details'), findsNothing);
    },
  );

  testWidgets('deep link does not open transaction detail', (tester) async {
    final container = _buildContainer();
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.dailyMenuSummary.path);
    await tester.pumpAndSettle();

    expect(find.byType(DailyMenuSummaryPage), findsOneWidget);
    expect(find.byType(TransactionDetailPage), findsNothing);
    expect(router.state.matchedLocation, AppRoute.dailyMenuSummary.path);
    expect(find.text('Daily Menu Summary'), findsOneWidget);
    expect(find.text('Transaction Details'), findsNothing);
  });

  testWidgets('transaction detail route still works', (tester) async {
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_CashierAuthController.new),
        shellCurrentBranchProvider.overrideWith(_TransactionsShellNotifier.new),
        menu_ctrl.menuProvider.overrideWith(_MockMenuPageController.new),
        transactionHistoryProvider
            .overrideWith(_MockTransactionHistoryController.new),
        dailyMenuSummaryController
            .overrideWith(_MockDailyMenuSummaryController.new),
        transactionDetailProvider(_transactionUuid).overrideWith(
          () => _MockTransactionDetailController(_transactionUuid),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go('/transactions/$_transactionUuid');
    await tester.pumpAndSettle();

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.byType(DailyMenuSummaryPage), findsNothing);
    expect(router.state.matchedLocation, '/transactions/$_transactionUuid');
    expect(find.text('Transaction details'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });

  testWidgets('feature gate redirects unauthorized user', (tester) async {
    final container = _buildContainer(authFactory: _MenuOnlyAuthController.new);
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.dailyMenuSummary.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DailyMenuSummaryPage), findsNothing);
    expect(find.byType(MenuPage), findsOneWidget);
    expect(router.state.matchedLocation, AppRoute.home.path);
  });
}
