import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// POS cashier auth checklist runnable via `flutter test test/integration/`.
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
