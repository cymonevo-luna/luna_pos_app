import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/shell_branch_provider.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/theme/app_tokens.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/cashier_balance/cashier_balance_page.dart';
import 'package:luna_pos/features/cashier_balance/data/cashier_balance_repository.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

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

class _CashierBalanceShellNotifier extends ShellBranchNotifier {
  @override
  int build() => ShellBranch.cashierBalance.branchIndex;
}

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<CashierBalanceRepository>(
        () => CashierBalanceRepository(locator<ApiClient>(), testResourceCache()),
      );
  });

  Widget buildTestApp() {
    final router = GoRouter(
      initialLocation: AppRoute.cashierBalance.path,
      routes: [
        GoRoute(
          path: AppRoute.cashierBalance.path,
          name: AppRoute.cashierBalance.name,
          builder: (context, state) => const CashierBalancePage(),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authProvider.overrideWith(_CashierAuthController.new),
        shellCurrentBranchProvider.overrideWith(_CashierBalanceShellNotifier.new),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  testWidgets('displays current balance card', (tester) async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 175000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Cashier Balance'), findsOneWidget);
    expect(find.text('Rp 175.000'), findsOneWidget);
    expect(find.text('Current balance'), findsOneWidget);
  });

  testWidgets('deduct button uses danger styling', (tester) async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 100000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    final deductButton = tester.widget<IconButton>(
      find.byKey(const Key('cashier_balance_deduct_button')),
    );
    final addButton = tester.widget<IconButton>(
      find.byKey(const Key('cashier_balance_add_button')),
    );
    final dangerColor = tester.element(find.byType(CashierBalancePage))
        .tokens
        .danger;

    expect(deductButton.style?.foregroundColor?.resolve({}), dangerColor);
    expect(addButton.style?.foregroundColor?.resolve({}), isNull);
  });

  testWidgets('manual add shows success snackbar and updates balance', (tester) async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 100000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onPost(
      CashierBalanceRepository.adjustmentsPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'balance': {
            'balance': 125000,
            'updated_at': '2026-07-18T10:05:00Z',
          },
          'entry': {
            'id': 'entry-1',
            'amount': 25000,
            'purpose': 'POS test',
            'requested_by_username': 'cashier-test',
            'type': 'ADD',
            'created_at': '2026-07-18T10:05:00Z',
          },
        },
      }),
      data: {
        'amount': 25000,
        'purpose': 'POS test',
        'type': 'ADD',
      },
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cashier_balance_add_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('cashier_balance_adjust_amount')),
      '25000',
    );
    await tester.enterText(
      find.byKey(const Key('cashier_balance_adjust_purpose')),
      'POS test',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Cashier balance updated'), findsOneWidget);
    expect(find.text('Rp 125.000'), findsOneWidget);
    expect(find.text('POS test'), findsOneWidget);
    expect(find.textContaining('cashier-test'), findsOneWidget);
  });

  testWidgets('manual deduct shows success snackbar and updates balance',
      (tester) async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 100000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onPost(
      CashierBalanceRepository.adjustmentsPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'balance': {
            'balance': 75000,
            'updated_at': '2026-07-18T10:05:00Z',
          },
          'entry': {
            'id': 'entry-2',
            'amount': -25000,
            'purpose': 'POS deduct test',
            'requested_by_username': 'cashier-test',
            'type': 'DEDUCT',
            'created_at': '2026-07-18T10:05:00Z',
          },
        },
      }),
      data: {
        'amount': 25000,
        'purpose': 'POS deduct test',
        'type': 'DEDUCT',
      },
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cashier_balance_deduct_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('cashier_balance_adjust_amount')),
      '25000',
    );
    await tester.enterText(
      find.byKey(const Key('cashier_balance_adjust_purpose')),
      'POS deduct test',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Cashier balance updated'), findsOneWidget);
    expect(find.text('Rp 75.000'), findsOneWidget);
    expect(find.text('POS deduct test'), findsOneWidget);
    expect(find.textContaining('cashier-test'), findsOneWidget);
  });
}
