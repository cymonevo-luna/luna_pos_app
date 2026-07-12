import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/production_request/production_request_detail_page.dart';
import 'package:luna_pos/features/production_request/production_request_list_page.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/harness.dart';

/// Cashier production delivery E2E: login, open Deliveries tab, confirm delivery.
void main() {
  testWidgets('cashier marks production delivery done from Deliveries tab',
      (tester) async {
    final harness = await setUpIntegrationHarness();
    harness
      ..stubLoginForRole(TestAccountRole.cashier)
      ..stubSampleMenu()
      ..stubStoreSettings()
      ..stubProductionDeliveryFlow(menuTitle: 'Nasi Goreng', quantity: 2);

    await harness.pumpApp(tester);
    await harness.loginViaUi(tester, TestAccountRole.cashier);
    await harness.expectAuthenticatedHome(tester);

    await harness.openDeliveriesTab(tester);

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.productionDeliveries), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.textContaining('Qty: 2'), findsOneWidget);

    await tester.tap(find.text('Nasi Goreng'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    expect(find.byType(ProductionRequestDetailPage), findsOneWidget);
    expect(find.byKey(const Key('confirm_delivery_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_delivery_button')));
    await tester.pump();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );

    expect(find.text(l10n.deliveryConfirmed), findsOneWidget);
    expect(find.byType(ProductionRequestListPage), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsNothing);
    expect(find.text(l10n.noDeliveriesPending), findsOneWidget);
  });
}
