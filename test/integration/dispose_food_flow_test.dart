import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';
import 'package:luna_pos/shared/widgets/app_button.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import '../../integration_test/helpers/harness.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('dispose food flow', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      harness
        ..stubSampleMenu()
        ..stubStoreSettings()
        ..stubProductionRequestInbox(requestId: 'pr-dispose-1')
        ..stubCashierBalance(balance: 175000);
      stubTokenRefresh(harness.adapter);
      harness.adapter.onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [],
          'meta': {'page': 1, 'per_page': 20, 'total': 0},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      );
    });

    testWidgets('dispose entry visible for cashier with menu disposals', (
      tester,
    ) async {
      harness.stubLoginForRole(TestAccountRole.cashier);

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.text(l10n.disposeFoodTitle), findsOneWidget);
    });

    testWidgets('feature gate hides dispose food entry', (tester) async {
      harness.stubLoginForRole(
        TestAccountRole.cashier,
        features: const [
          PosFeatures.menu,
          PosFeatures.transactions,
          PosFeatures.productionRequests,
          PosFeatures.cashierBalance,
        ],
      );

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      expect(find.text(l10n.disposeFoodTitle), findsNothing);
    });

    testWidgets('successful disposal flow updates menu stock', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu(availableStock: 5)
        ..stubCreateMenuDisposal(lossAmount: 70000, quantity: 2);

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      await tester.tap(find.text(l10n.disposeFoodTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('dispose_food_quantity_field')),
        '2',
      );
      await tester.pumpAndSettle();

      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder.at(0));
      await tester.tap(submitFinder.at(0));
      await tester.pumpAndSettle();

      expect(find.text(l10n.disposeFoodSelectMenu), findsOneWidget);
      expect(find.byKey(const Key('dispose_menu_row_m1')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Scaffold).first,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
      expect(find.textContaining('Loss:'), findsOneWidget);
      expect(find.textContaining('Available stock: 3'), findsOneWidget);

      await tester.tap(find.text(l10n.menu));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Stock: 3'), findsOneWidget);
    });

    testWidgets('API error keeps user on form', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu(availableStock: 5);

      harness.adapter.onPost(
        MenuDisposalRepository.listPath,
        (server) => server.reply(422, {
          'success': false,
          'error': {
            'message': 'Insufficient stock for this menu item',
          },
        }),
        data: {'menu_id': 'm1', 'quantity': 2},
      );

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      await tester.tap(find.text(l10n.disposeFoodTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('dispose_food_quantity_field')),
        '2',
      );
      await tester.pumpAndSettle();

      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder.at(0));
      await tester.tap(submitFinder.at(0));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('dispose_food_submit')), findsOneWidget);
      expect(find.textContaining('Insufficient stock'), findsWidgets);
      expect(find.text(l10n.disposeFoodSelectMenu), findsNothing);
      final submitButton = tester.widget<AppButton>(submitFinder.at(0));
      expect(submitButton.loading, isFalse);
    });

    testWidgets('client blocks over-stock quantity', (tester) async {
      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubSampleMenu(availableStock: 1);

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      await tester.tap(find.text(l10n.disposeFoodTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('dispose_food_quantity_field')),
        '5',
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('exceeds available stock'), findsOneWidget);
      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder.at(0));
      expect(tester.widget<AppButton>(submitFinder.at(0)).onPressed, isNull);
    });
  });
}
