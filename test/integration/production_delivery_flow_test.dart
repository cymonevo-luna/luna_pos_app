import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/production_request/production_request_detail_page.dart';
import 'package:luna_pos/features/production_request/production_request_list_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

/// Cashier production delivery integration test runnable via `flutter test`.
void main() {
  testWidgets('cashier marks production delivery done from Production tab',
      (tester) async {
    const requestId = 'pr-e2e-1';

    final harness = await setUpIntegrationHarness();
    harness
      ..stubLoginForRole(TestAccountRole.cashier)
      ..stubSampleMenu()
      ..stubStoreSettings()
      ..stubProductionRequestInbox(requestId: requestId)
      ..stubProductionRequestDetail(requestId: requestId)
      ..stubMarkProductionRequestDone(requestId: requestId);

    await harness.pumpApp(tester);
    await harness.loginViaUi(tester, TestAccountRole.cashier);
    await harness.expectAuthenticatedHome(tester);

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.deliveries), findsWidgets);
    expect(find.text('Deliveries'), findsNothing);
    expect(find.byIcon(Icons.lunch_dining_outlined), findsWidgets);
    expect(find.byIcon(Icons.local_shipping_outlined), findsNothing);
    expect(find.byIcon(Icons.local_shipping), findsNothing);

    await harness.tapProductionTab(tester);

    expect(find.byIcon(Icons.lunch_dining), findsWidgets);
    expect(find.byIcon(Icons.local_shipping), findsNothing);
    expect(find.text(l10n.productionDeliveries), findsWidgets);
    expect(find.text(l10n.productionItemCount(1)), findsOneWidget);

    await tester.tap(find.text(l10n.productionItemCount(1)));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    expect(find.byType(ProductionRequestDetailPage), findsOneWidget);
    expect(find.text(l10n.productionDeliveryDetail), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_delivery_button')));
    await tester.pump();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    expect(find.text(l10n.deliveryConfirmed), findsOneWidget);
    expect(find.byType(ProductionRequestListPage), findsOneWidget);
    expect(find.text(l10n.productionItemCount(1)), findsNothing);
    expect(find.text(l10n.noDeliveriesPending), findsOneWidget);
  });
}
