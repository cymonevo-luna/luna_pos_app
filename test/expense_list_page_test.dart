import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/expense/data/expense_repository.dart';
import 'package:luna_pos/features/expense/expense_list_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  Map<String, dynamic> listResponse({
    required List<Map<String, dynamic>> items,
    int total = 0,
  }) =>
      {
        'success': true,
        'data': items,
        'meta': {
          'page': 1,
          'per_page': ExpenseRepository.defaultPerPage,
          'total': total == 0 ? items.length : total,
        },
      };

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<ExpenseRepository>(
        () => ExpenseRepository(locator<ApiClient>()),
      );
  });

  Future<void> pumpExpenseList(
    WidgetTester tester, {
    required List<Map<String, dynamic>> items,
  }) async {
    adapter.onGet(
      ExpenseRepository.listPath,
      (server) => server.reply(200, listResponse(items: items)),
      queryParameters: {
        'page': '1',
        'per_page': '20',
      },
    );

    final router = GoRouter(
      initialLocation: AppRoute.expenses.path,
      routes: [
        GoRoute(
          path: AppRoute.expenses.path,
          name: AppRoute.expenses.name,
          builder: (context, state) => const ExpenseListPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('expense list loads and scrolls without errors', (tester) async {
    await pumpExpenseList(
      tester,
      items: [
        for (var i = 0; i < 25; i++)
          {
            'id': 'exp-$i',
            'title': 'Expense $i',
            'description': 'Description $i',
            'amount': 10000 + i,
            'source_of_fund': 'PERSONAL_MONEY',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
      ],
    );

    expect(find.byType(ExpenseListPage), findsOneWidget);
    expect(find.byKey(const Key('expense_list')), findsOneWidget);
    expect(find.text('Expense 0'), findsOneWidget);

    await tester.drag(find.byKey(const Key('expense_list')), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.byType(ExpenseListPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when no expenses', (tester) async {
    await pumpExpenseList(tester, items: []);

    expect(find.text('No expenses yet'), findsOneWidget);
  });
}
