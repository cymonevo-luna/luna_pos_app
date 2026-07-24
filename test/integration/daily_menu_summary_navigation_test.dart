import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/auth/login_page.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_page.dart';
import 'package:luna_pos/features/daily_menu_summary/data/daily_menu_summary_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/transaction_history_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

Map<String, dynamic> sampleSummaryEnvelope({
  List<Map<String, dynamic>> menus = const [
    {
      'menu_id': 'menu-1',
      'menu_title': 'Nasi Goreng',
      'quantity_sold': 5,
      'revenue': 75000,
      'revenue_share_percent': 60.0,
      'quantity_share_percent': 62.5,
    },
    {
      'menu_id': 'menu-2',
      'menu_title': 'Es Teh',
      'quantity_sold': 3,
      'revenue': 50000,
      'revenue_share_percent': 40.0,
      'quantity_share_percent': 37.5,
    },
  ],
  int totalQuantity = 8,
  int totalRevenue = 125000,
}) =>
    {
      'success': true,
      'data': {
        'date_from': '2026-07-24',
        'date_to': '2026-07-24',
        'total_revenue': totalRevenue,
        'total_quantity': totalQuantity,
        'menus': menus,
      },
    };

Map<String, dynamic> emptyTransactionsResponse() => {
      'success': true,
      'data': <Map<String, dynamic>>[],
      'meta': {
        'page': 1,
        'per_page': TransactionRepository.defaultPerPage,
        'total': 0,
      },
    };

void registerDailyMenuSummaryRepositories() {
  locator
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepository(
        locator<ApiClient>(),
        locator<ResourceCache>(),
      ),
    )
    ..registerLazySingleton<DailyMenuSummaryRepository>(
      () => DailyMenuSummaryRepository(
        locator<ApiClient>(),
        locator<ResourceCache>(),
      ),
    );
}

void stubEmptyTransactionHistory(IntegrationTestHarness harness) {
  harness.adapter.onGet(
    TransactionRepository.listPath,
    (server) => server.reply(200, emptyTransactionsResponse()),
    queryParameters: {'page': '1', 'per_page': '20'},
  );
}

Future<void> openDailyMenuSummaryFromTransactions(
  WidgetTester tester,
  IntegrationTestHarness harness,
  AppLocalizationsEn l10n,
) async {
  await harness.pumpApp(tester);
  await harness.loginViaUi(tester, TestAccountRole.cashier);
  await harness.expectAuthenticatedHome(tester);

  await tester.tap(find.text(l10n.transactionHistory));
  await tester.pumpAndSettle();

  expect(find.byType(TransactionHistoryPage), findsOneWidget);

  await tester.tap(
    find.byKey(const Key('transaction_history_daily_menu_summary_button')),
  );
  await tester.pumpAndSettle();

  expect(find.byType(DailyMenuSummaryPage), findsOneWidget);
}

/// Daily menu summary navigation checklist runnable via `flutter test test/integration/`.
void main() {
  final l10n = AppLocalizationsEn();

  group('daily menu summary navigation', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      registerDailyMenuSummaryRepositories();
      stubTokenRefresh(harness.adapter);
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu();
      stubEmptyTransactionHistory(harness);
    });

    tearDown(() async {
      harness.container.dispose();
      await locator.reset();
    });

    testWidgets('cashier sees summary stat cards and menu rows', (tester) async {
      harness.adapter.onGet(
        DailyMenuSummaryRepository.summaryPath,
        (server) => server.reply(200, sampleSummaryEnvelope()),
      );

      await openDailyMenuSummaryFromTransactions(tester, harness, l10n);

      expect(
        find.byKey(const Key('daily_menu_summary_total_items_card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('daily_menu_summary_total_revenue_card')),
        findsOneWidget,
      );
      expect(find.text('8'), findsOneWidget);
      expect(find.text(formatRupiah(125000)), findsOneWidget);
      expect(find.text('Nasi Goreng'), findsOneWidget);
      expect(find.text('Es Teh'), findsOneWidget);
      expect(find.byKey(const Key('daily_menu_summary_row_menu-1')), findsOneWidget);
      expect(find.byKey(const Key('daily_menu_summary_row_menu-2')), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text(l10n.retry), findsNothing);
    });

    testWidgets('empty sales day shows localized empty state without error',
        (tester) async {
      harness.adapter.onGet(
        DailyMenuSummaryRepository.summaryPath,
        (server) => server.reply(
          200,
          sampleSummaryEnvelope(menus: const [], totalQuantity: 0, totalRevenue: 0),
        ),
      );

      await openDailyMenuSummaryFromTransactions(tester, harness, l10n);

      expect(find.text(l10n.dailyMenuSummaryNoSales), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text(formatRupiah(0)), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text(l10n.retry), findsNothing);
    });

    testWidgets('404 on summary endpoint shows retry without logging out',
        (tester) async {
      harness.adapter.onGet(
        DailyMenuSummaryRepository.summaryPath,
        (server) => server.reply(404, {
          'success': false,
          'error': {'message': 'Not found.'},
        }),
      );

      await openDailyMenuSummaryFromTransactions(tester, harness, l10n);

      expect(find.text('Not found.'), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(DailyMenuSummaryPage), findsOneWidget);
    });
  });
}
