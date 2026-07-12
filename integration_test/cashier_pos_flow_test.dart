import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/menu/widgets/menu_item_card.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/harness.dart';

/// Cashier/POS automation: dedicated login then menu load (no registration).
void main() {
  testWidgets('cashier POS flow uses dedicated account login', (tester) async {
    final harness = await setUpIntegrationHarness();
    harness
      ..forbidRegistration()
      ..stubLoginForRole(TestAccountRole.cashier)
      ..stubSampleMenu();

    await harness.pumpApp(tester);
    await harness.loginViaUi(tester, TestAccountRole.cashier);
    await harness.expectAuthenticatedHome(tester);

    expect(find.byType(MenuItemCard), findsWidgets);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(TestAccounts.cashierEmail, 'cashier-test@cymonevo.com');
    expect(TestAccounts.password, 'LunaTesting123!');
  });
}
