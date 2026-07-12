import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// Role-based Tester Agent smoke paths runnable via `flutter test test/integration/`.
void main() {
  group('dedicated account login automation', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
    });

    testWidgets('admin logs in without registration', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.admin)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.admin);
      await harness.expectAuthenticatedHome(tester);

      expect(TestAccounts.emailFor(TestAccountRole.admin), TestAccounts.adminEmail);
    });

    testWidgets('cashier logs in without registration', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(
        TestAccounts.emailFor(TestAccountRole.cashier),
        TestAccounts.cashierEmail,
      );
    });

    testWidgets('manager logs in without registration', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.manager)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.manager);
      await harness.expectAuthenticatedHome(tester);

      expect(
        TestAccounts.emailFor(TestAccountRole.manager),
        TestAccounts.managerEmail,
      );
    });

    testWidgets('operational logs in without registration', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.operational)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.operational);
      await harness.expectAuthenticatedHome(tester);

      expect(
        TestAccounts.emailFor(TestAccountRole.operational),
        TestAccounts.operationalEmail,
      );
    });
  });
}
