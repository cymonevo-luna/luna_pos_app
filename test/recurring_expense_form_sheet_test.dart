import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/recurring_expense/data/recurring_expense_repository.dart';
import 'package:luna_pos/features/recurring_expense/recurring_expense_form_sheet.dart';
import 'package:luna_pos/features/recurring_expense/recurring_expense_list_controller.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  Widget buildFormApp() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(AppAccent.blue),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: RecurringExpenseFormSheet(),
        ),
      ),
    );
  }

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<RecurringExpenseRepository>(
        () => RecurringExpenseRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
    container.read(recurringExpenseListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    for (var i = 0;
        i < 100 && container.read(recurringExpenseListProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  });

  tearDown(() async {
    for (var i = 0; i < 100; i++) {
      final state = container.read(recurringExpenseListProvider);
      if (!state.loading && !state.refreshing && !state.submitting) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    container.dispose();
  });

  testWidgets('DAILY hides value field and DATE shows day-of-month field',
      (tester) async {
    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recurring_expense_day_of_month_field')),
        findsNothing);
    expect(find.byKey(const Key('recurring_expense_weekday_field')),
        findsNothing);

    await tester.tap(find.byKey(const Key('recurring_expense_interval_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Monthly').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recurring_expense_day_of_month_field')),
        findsOneWidget);
    expect(find.byKey(const Key('recurring_expense_weekday_field')),
        findsNothing);

    await tester.tap(find.byKey(const Key('recurring_expense_interval_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daily').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recurring_expense_day_of_month_field')),
        findsNothing);
    expect(find.byKey(const Key('recurring_expense_weekday_field')),
        findsNothing);
  });

  testWidgets('empty title shows validation error and skips create',
      (tester) async {
    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('recurring_expense_amount_field')),
      '100000',
    );
    await tester.tap(find.byKey(const Key('recurring_expense_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsWidgets);
    expect(adapter.history, isEmpty);
  });
}
