import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/cashier_balance/cashier_balance_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// Cashier Balance navigation checklist runnable via `flutter test test/integration/`.
void main() {
  final l10n = AppLocalizationsEn();

  group('cashier balance navigation', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu()
        ..stubCashierBalance(balance: 175000);
    });

    tearDown(() async {
      harness.container.dispose();
      await locator.reset();
    });

    testWidgets('cashier with pos.cashier_balance sees Cashier Balance tab',
        (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.text(l10n.cashierBalanceTitle), findsWidgets);
    });

    testWidgets('cashier without pos.cashier_balance hides Cashier Balance tab',
        (tester) async {
      harness.stubLoginForRole(
        TestAccountRole.cashier,
        features: const [
          PosFeatures.menu,
          PosFeatures.transactions,
          PosFeatures.productionRequests,
        ],
      );

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.text(l10n.cashierBalanceTitle), findsNothing);
    });

    testWidgets('Cashier Balance tab opens screen with balance card',
        (tester) async {
      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      await tester.tap(find.text(l10n.cashierBalanceTitle));
      await tester.pumpAndSettle();

      expect(find.byType(CashierBalancePage), findsOneWidget);
      expect(find.text('Rp 175.000'), findsOneWidget);
      expect(find.text(l10n.cashierBalanceCurrent), findsOneWidget);
    });
  });
}
