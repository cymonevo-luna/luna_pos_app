import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// POS auth and procurement navigation checklist runnable via
/// `flutter test test/integration/`.
void main() {
  group('role-based login and navigation checklist', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
    });

    tearDown(() async {
      harness.container.dispose();
      await locator.reset();
    });

    testWidgets('cashier login succeeds', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);
    });

    testWidgets('manager-only login succeeds and lands on expenses',
        (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.manager)
        ..adapter.onGet(
          '/api/admin/expenses',
          (server) => server.reply(200, {
            'success': true,
            'data': [],
            'meta': {'page': 1, 'per_page': 20, 'total': 0},
          }),
          queryParameters: {'page': '1', 'per_page': '20'},
        );

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.manager);

      final router = harness.readRouter();
      expect(router.state.matchedLocation, AppRoute.expenses.path);
    });

    testWidgets('operational-only login succeeds', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.operational)
        ..stubEmptyFoodSupplies();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);
      await harness.expectAuthenticatedProcurement(tester);
    });

    testWidgets('multi-role cashier login succeeds', (tester) async {
      harness
        ..stubLoginForRole(
          TestAccountRole.cashier,
          additionalRoles: const ['operational'],
        )
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);
      await harness.expectProcurementTabsVisible(tester);
    });

    testWidgets('operational-only lands on procurement', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.operational)
        ..stubEmptyFoodSupplies();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);

      final router = harness.readRouter();
      expect(
        router.state.matchedLocation,
        anyOf(AppRoute.stock.path, AppRoute.purchases.path),
      );
      expect(router.state.matchedLocation, isNot(AppRoute.home.path));
    });

    testWidgets('operational-only blocked from checkout', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.operational)
        ..stubEmptyFoodSupplies();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);
      await harness.expectAuthenticatedProcurement(tester);

      final router = harness.readRouter();
      router.go(AppRoute.checkout.path);
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );

      expect(router.state.matchedLocation, isNot(AppRoute.checkout.path));
      expect(
        router.state.matchedLocation,
        anyOf(AppRoute.stock.path, AppRoute.purchases.path),
      );
    });
  });
}
