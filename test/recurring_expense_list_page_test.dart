import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/recurring_expense/data/recurring_expense_repository.dart';
import 'package:luna_pos/features/recurring_expense/recurring_expense_list_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';

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
          'per_page': RecurringExpenseRepository.defaultPerPage,
          'total': total == 0 ? items.length : total,
        },
      };

  Map<String, dynamic> expenseItem({
    required String id,
    required String title,
    String? staffId,
  }) =>
      {
        'id': id,
        'title': title,
        'description': '',
        'amount': 100000,
        'is_active': true,
        'staff_id': ?staffId,
        'recurring': {
          'interval': 'DAILY',
          'time': {'hour': 9, 'minute': 0, 'second': 0},
        },
      };

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<RecurringExpenseRepository>(
        () => RecurringExpenseRepository(locator<ApiClient>()),
      );
  });

  Future<void> pumpRecurringExpenseList(
    WidgetTester tester, {
    required List<Map<String, dynamic>> items,
  }) async {
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, listResponse(items: items)),
      queryParameters: {
        'page': '1',
        'per_page': '20',
      },
    );

    final router = GoRouter(
      initialLocation: AppRoute.recurringExpenses.path,
      routes: [
        GoRoute(
          path: AppRoute.recurringExpenses.path,
          name: AppRoute.recurringExpenses.name,
          builder: (context, state) => const RecurringExpenseListPage(),
          routes: [
            GoRoute(
              path: 'new',
              name: AppRoute.recurringExpensesNew.name,
              builder: (context, state) =>
                  const Scaffold(body: Text('new-recurring-screen')),
            ),
            GoRoute(
              path: ':id/edit',
              name: AppRoute.recurringExpensesEdit.name,
              builder: (context, state) => Scaffold(
                body: Text('edit-${state.pathParameters['id']}'),
              ),
            ),
          ],
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

  testWidgets('shows Staff salary chip for staff-linked expense', (tester) async {
    await pumpRecurringExpenseList(
      tester,
      items: [
        expenseItem(id: 're-staff', title: 'Alice salary', staffId: 'staff-1'),
      ],
    );

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.recurringExpenseStaffSalaryBadge), findsOneWidget);
    expect(find.text('Alice salary'), findsOneWidget);
  });

  testWidgets('staff-linked item hides delete action', (tester) async {
    await pumpRecurringExpenseList(
      tester,
      items: [
        expenseItem(id: 're-staff', title: 'Alice salary', staffId: 'staff-1'),
      ],
    );

    expect(
      find.byKey(const Key('recurring_expense_delete_re-staff')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('recurring_expense_dismiss_re-staff')),
      findsNothing,
    );
  });

  testWidgets('staff-linked item does not open edit on tap', (tester) async {
    await pumpRecurringExpenseList(
      tester,
      items: [
        expenseItem(id: 're-staff', title: 'Alice salary', staffId: 'staff-1'),
      ],
    );

    await tester.tap(find.text('Alice salary'));
    await tester.pumpAndSettle();

    expect(find.text('edit-re-staff'), findsNothing);
  });

  testWidgets('non-staff item keeps delete action and edit navigation',
      (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const expenseId = 're-regular';
    await pumpRecurringExpenseList(
      tester,
      items: [
        expenseItem(id: expenseId, title: 'Office rent'),
      ],
    );

    expect(
      find.byKey(Key('recurring_expense_delete_$expenseId')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('recurring_expense_dismiss_$expenseId')),
      findsOneWidget,
    );
    expect(find.text(AppLocalizationsEn().recurringExpenseStaffSalaryBadge),
        findsNothing);

    adapter.onGet(
      '${RecurringExpenseRepository.listPath}/$expenseId',
      (server) => server.reply(
        200,
        {
          'success': true,
          'data': expenseItem(id: expenseId, title: 'Office rent'),
        },
      ),
    );

    await tester.tap(find.byKey(Key('recurring_expense_card_$expenseId')));
    await tester.pumpAndSettle();

    expect(find.text('edit-$expenseId'), findsOneWidget);
  });
}
