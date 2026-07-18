import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/production_request/production_request_list_page.dart';
import 'package:luna_pos/features/profile/profile_page.dart';
import 'package:luna_pos/features/purchase/purchase_list_page.dart';
import 'package:luna_pos/features/recurring_expense/recurring_expense_list_page.dart';
import 'package:luna_pos/features/stock/stock_list_page.dart';
import 'package:luna_pos/features/transaction/transaction_history_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/shared/widgets/main_scaffold.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('cashier bottom navigation', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu()
        ..stubStoreSettings()
        ..stubProductionRequestInbox(requestId: 'pr-nav-1');
      harness.adapter.onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [],
          'meta': {'page': 1, 'per_page': 20, 'total': 0},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      );
    });

    testWidgets('does not show Messages tab and lists expected cashier tabs',
        (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.byType(MainScaffold), findsOneWidget);
      expect(find.text('Messages'), findsNothing);
      expect(find.text('Pesan'), findsNothing);
      expect(find.text(l10n.menu), findsWidgets);
      expect(find.text(l10n.transactionHistory), findsWidgets);
      expect(find.text(l10n.deliveries), findsWidgets);
      expect(find.text(l10n.cashierBalanceTitle), findsWidgets);
      expect(find.text(l10n.profile), findsWidgets);
    });

    testWidgets('remaining tabs route to the correct screens', (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.byType(MenuPage), findsOneWidget);

      await tester.tap(find.text(l10n.transactionHistory));
      await tester.pumpAndSettle();
      expect(find.byType(TransactionHistoryPage), findsOneWidget);

      await harness.tapProductionTab(tester);
      expect(find.byType(ProductionRequestListPage), findsOneWidget);

      await tester.tap(find.text(l10n.profile));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);

      await tester.tap(find.text(l10n.menu));
      await tester.pumpAndSettle();
      expect(find.byType(MenuPage), findsOneWidget);
    });
  });

  group('operational bottom navigation', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      harness.stubLoginForRole(TestAccountRole.operational);
      harness.stubEmptyFoodSupplies();
      harness.adapter.onGet(
        '/api/admin/purchase-requests',
        (server) => server.reply(200, {
          'success': true,
          'data': [],
          'meta': {'page': 1, 'per_page': 20, 'total': 0},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      );
      harness.adapter.onGet(
        '/api/admin/recurring-expenses',
        (server) => server.reply(200, {
          'success': true,
          'data': [],
          'meta': {'page': 1, 'per_page': 20, 'total': 0},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      );
    });

    testWidgets('shows Stock, Purchases, and Recurring without Messages',
        (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);
      await harness.expectAuthenticatedProcurement(tester);

      expect(find.text('Messages'), findsNothing);
      expect(find.text('Pesan'), findsNothing);
      expect(find.text(l10n.stock), findsWidgets);
      expect(find.text(l10n.purchases), findsWidgets);
      expect(find.text(l10n.recurringExpensesTitle), findsWidgets);
      expect(find.text(l10n.profile), findsWidgets);
    });

    testWidgets('Stock, Purchases, and Recurring tabs open the correct pages',
        (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);
      await harness.expectAuthenticatedProcurement(tester);

      expect(find.byType(StockListPage), findsOneWidget);

      await tester.tap(find.text(l10n.purchases));
      await tester.pumpAndSettle();
      expect(find.byType(PurchaseListPage), findsOneWidget);

      await tester.tap(find.text(l10n.recurringExpensesTitle));
      await tester.pumpAndSettle();
      expect(find.byType(RecurringExpenseListPage), findsOneWidget);

      await tester.tap(find.text(l10n.stock));
      await tester.pumpAndSettle();
      expect(find.byType(StockListPage), findsOneWidget);
    });
  });
}
