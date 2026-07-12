import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/harness.dart';

/// POS cashier auth checklist for device/desktop integration tests.
/// Role-based Tester Agent smoke paths log in via the app UI with dedicated
/// seeded accounts (login only, no new user creation).
void main() {
  group('cashier role login checklist', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
    });

    tearDown(() async {
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

    testWidgets('manager-only login rejected', (tester) async {
      harness.stubLoginForRole(TestAccountRole.manager);

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.manager);
      await harness.expectLoginRejected(tester);
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
    });
  });
}
