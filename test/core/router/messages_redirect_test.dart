import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../../integration_test/helpers/harness.dart';

/// Deep-link redirect coverage isolated from other navigation widget tests
/// to avoid isolate/state bleed between sequential testWidgets runs.
void main() {
  testWidgets('/messages redirects authenticated cashier to default route',
      (tester) async {
    final harness = await setUpIntegrationHarness();
    harness
      ..stubLoginForRole(TestAccountRole.cashier)
      ..stubSampleMenu()
      ..stubStoreSettings();

    await harness.pumpApp(tester);
    await harness.loginViaUi(tester, TestAccountRole.cashier);
    await harness.expectAuthenticatedHome(tester);

    final router = harness.readRouter();
    router.go(AppRoute.messages.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(router.state.uri.path, AppRoute.home.path);
    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.text('Messages'), findsNothing);
    expect(find.text('Coming soon'), findsNothing);
  });
}
