import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/menu/widgets/menu_item_card.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// Cashier/POS automation runnable via `flutter test test/integration/`.
void main() {
  testWidgets('cashier POS flow uses dedicated account login', (tester) async {
    final harness = await setUpIntegrationHarness();
    harness
      ..stubLoginForRole(TestAccountRole.cashier)
      ..stubSampleMenu();

    await harness.pumpApp(tester);
    await harness.loginViaUi(tester, TestAccountRole.cashier);
    await harness.expectAuthenticatedHome(tester);

    expect(TestAccounts.cashierEmail, 'cashier-test@cymonevo.com');
    expect(TestAccounts.cashierUserId, '11111111-1111-4111-8111-111111111103');

    expect(find.byType(MenuItemCard), findsWidgets);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });
}
