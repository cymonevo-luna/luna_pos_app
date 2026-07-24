import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/expense/data/expense_repository.dart';
import 'package:luna_pos/features/expense/expense_form_sheet.dart';
import 'package:luna_pos/features/expense/expense_list_controller.dart';
import 'package:luna_pos/features/expense/models/expense.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/auth_harness.dart';

class _AdminAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.adminUserId,
          name: 'Admin Test',
          email: TestAccounts.adminEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: const ['admin'],
          features: TestAccounts.apiFeaturesFor(TestAccountRole.admin),
        ),
      );
}

class _OperationalAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.operationalUserId,
          name: 'Operational Test',
          email: TestAccounts.operationalEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: const ['operational'],
          features: TestAccounts.apiFeaturesFor(TestAccountRole.operational),
        ),
      );
}

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  final existingExpense = Expense(
    id: 'exp-1',
    title: 'Office supplies',
    description: 'Printer paper',
    amount: 50000,
    sourceOfFund: ExpenseSourceOfFund.personalMoney,
    createdAt: DateTime.utc(2026, 7, 20, 10),
    updatedAt: DateTime.utc(2026, 7, 20, 10),
  );

  Widget buildFormApp({
    required AuthController Function() authFactory,
    Expense? existing,
  }) {
    return UncontrolledProviderScope(
      container: container,
      child: ProviderScope(
        overrides: [
          authProvider.overrideWith(authFactory),
        ],
        child: MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ExpenseFormSheet(existing: existing),
          ),
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
      ..registerLazySingleton<ExpenseRepository>(
        () => ExpenseRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
    container.read(expenseListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    for (var i = 0;
        i < 100 && container.read(expenseListProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  });

  tearDown(() async {
    for (var i = 0; i < 100; i++) {
      final state = container.read(expenseListProvider);
      if (!state.loading && !state.refreshing && !state.submitting) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    container.dispose();
  });

  testWidgets('admin sees reporting date picker on expense edit',
      (tester) async {
    await tester.pumpWidget(
      buildFormApp(
        authFactory: _AdminAuthController.new,
        existing: existingExpense,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('expense_reporting_date_field')), findsOneWidget);
    expect(find.text('Reporting date'), findsOneWidget);
  });

  testWidgets('operational user does not see reporting date picker',
      (tester) async {
    await tester.pumpWidget(
      buildFormApp(
        authFactory: _OperationalAuthController.new,
        existing: existingExpense,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('expense_reporting_date_field')), findsNothing);
    expect(find.text('Reporting date'), findsNothing);
  });

  testWidgets('admin save calls PATCH record-date after PUT when date changed',
      (tester) async {
    var putCalled = false;
    var patchCalled = false;

    adapter.onPut(
      '${ExpenseRepository.listPath}/exp-1',
      (server) {
        putCalled = true;
        return server.reply(200, {
          'success': true,
          'data': {
            'id': 'exp-1',
            'title': 'Office supplies',
            'description': 'Printer paper',
            'amount': 50000,
            'source_of_fund': 'PERSONAL_MONEY',
            'created_at': '2026-07-20T10:00:00Z',
            'updated_at': '2026-07-20T10:00:00Z',
          },
        });
      },
    );

    adapter.onPatch(
      '${ExpenseRepository.listPath}/exp-1/record-date',
      (server) {
        patchCalled = true;
        return server.reply(200, {
          'success': true,
          'data': {
            'id': 'exp-1',
            'title': 'Office supplies',
            'description': 'Printer paper',
            'amount': 50000,
            'source_of_fund': 'PERSONAL_MONEY',
            'created_at': '2026-07-15T10:00:00Z',
            'updated_at': '2026-07-24T10:00:00Z',
          },
        });
      },
    );

    await tester.pumpWidget(
      buildFormApp(
        authFactory: _AdminAuthController.new,
        existing: existingExpense,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('expense_reporting_date_field')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('expense_submit_button')));
    await tester.pumpAndSettle();

    expect(putCalled, isTrue);
    expect(patchCalled, isTrue);
  });

  test('admin test account includes records.edit_date feature', () {
    final features = TestAccounts.apiFeaturesFor(TestAccountRole.admin);
    expect(features, contains(PosFeatures.recordsEditDate));
  });

  test('operational test account excludes records.edit_date feature', () {
    final features = TestAccounts.apiFeaturesFor(TestAccountRole.operational);
    expect(features, isNot(contains(PosFeatures.recordsEditDate)));
    expect(features, contains(PosFeatures.expensesManage));
  });
}
