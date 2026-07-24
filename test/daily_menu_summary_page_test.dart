import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_page.dart';
import 'package:luna_pos/features/daily_menu_summary/models/daily_menu_summary.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

class _MockDailyMenuSummaryController extends DailyMenuSummaryController {
  _MockDailyMenuSummaryController(this._initialState);

  final DailyMenuSummaryState _initialState;
  var refreshCalled = false;

  @override
  DailyMenuSummaryState build() => _initialState;

  @override
  Future<void> loadIfNeeded() async {}

  @override
  Future<void> refresh() async {
    refreshCalled = true;
  }
}

DailyMenuSummaryResponse sampleSummary({
  List<DailyMenuSummaryItem> menus = const [
    DailyMenuSummaryItem(
      menuId: 'menu-1',
      menuTitle: 'Nasi Goreng',
      quantitySold: 5,
      revenue: 75000,
    ),
    DailyMenuSummaryItem(
      menuId: 'menu-2',
      menuTitle: 'Es Teh',
      quantitySold: 3,
      revenue: 50000,
    ),
  ],
  int totalQuantity = 8,
  int totalRevenue = 125000,
}) {
  return DailyMenuSummaryResponse(
    dateFrom: '2026-07-24',
    dateTo: '2026-07-24',
    totalQuantity: totalQuantity,
    totalRevenue: totalRevenue,
    menus: menus,
  );
}

Widget buildTestApp({
  required DailyMenuSummaryState state,
  DailyMenuSummaryController? controller,
}) {
  final mockController = controller ??
      _MockDailyMenuSummaryController(state);

  final router = GoRouter(
    initialLocation: AppRoute.dailyMenuSummary.path,
    routes: [
      GoRoute(
        path: AppRoute.dailyMenuSummary.path,
        name: AppRoute.dailyMenuSummary.name,
        builder: (context, state) => const DailyMenuSummaryPage(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      dailyMenuSummaryController.overrideWith(() => mockController),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets('screen renders menu list with totals', (tester) async {
    final summary = sampleSummary();

    await tester.pumpWidget(
      buildTestApp(
        state: DailyMenuSummaryState(summary: summary),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Daily Menu Summary'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.text('Qty: 5'), findsOneWidget);
    expect(find.text('Qty: 3'), findsOneWidget);
    expect(find.text(formatRupiah(75000)), findsOneWidget);
    expect(find.text(formatRupiah(50000)), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text(formatRupiah(125000)), findsOneWidget);
    expect(find.text('Items sold'), findsOneWidget);
    expect(find.text('Total revenue'), findsOneWidget);
  });

  testWidgets('screen shows empty state', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        state: DailyMenuSummaryState(
          summary: sampleSummary(
            menus: const [],
            totalQuantity: 0,
            totalRevenue: 0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No menu sales today'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text(formatRupiah(0)), findsOneWidget);
  });

  testWidgets('pull to refresh triggers reload', (tester) async {
    final controller = _MockDailyMenuSummaryController(
      DailyMenuSummaryState(summary: sampleSummary()),
    );

    await tester.pumpWidget(
      buildTestApp(
        state: DailyMenuSummaryState(summary: sampleSummary()),
        controller: controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.refreshCalled, isFalse);

    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
      1000,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(controller.refreshCalled, isTrue);
  });
}
