import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/order/widgets/cash_payment_summary.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/shared/widgets/app_text.dart';

Future<void> pumpCashPaymentSummary(
  WidgetTester tester, {
  required int cashTendered,
  required int grandTotal,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccent.blue),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: CashPaymentSummary(
              cashTendered: cashTendered,
              grandTotal: grandTotal,
              l10n: l10n,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('CashPaymentSummary', () {
    testWidgets('zero cash shows no change or error', (WidgetTester tester) async {
      await pumpCashPaymentSummary(
        tester,
        cashTendered: 0,
        grandTotal: 78000,
      );

      expect(find.byKey(const Key('change_summary')), findsNothing);
      expect(find.byKey(const Key('insufficient_payment_message')), findsNothing);
      expect(find.byKey(const Key('cash_received_summary')), findsOneWidget);
      expect(find.text(formatRupiah(0)), findsOneWidget);
    });

    testWidgets('insufficient payment message', (WidgetTester tester) async {
      await pumpCashPaymentSummary(
        tester,
        cashTendered: 50000,
        grandTotal: 78000,
      );

      final l10n = AppLocalizationsEn();
      expect(find.byKey(const Key('insufficient_payment_message')), findsOneWidget);
      expect(find.text(l10n.insufficientPayment), findsOneWidget);
      expect(find.byKey(const Key('change_summary')), findsNothing);
    });

    testWidgets('sufficient payment shows prominent change', (WidgetTester tester) async {
      await pumpCashPaymentSummary(
        tester,
        cashTendered: 100000,
        grandTotal: 78000,
      );

      final changeFinder = find.byKey(const Key('change_summary'));
      expect(changeFinder, findsOneWidget);
      expect(find.text('-${formatRupiah(22000)}'), findsOneWidget);
      expect(find.byKey(const Key('insufficient_payment_message')), findsNothing);

      final changeText = tester.widget<AppText>(changeFinder);
      expect(changeText.weight, FontWeight.w700);

      final theme = AppTheme.light(AppAccent.blue);
      expect(changeText.color, theme.colorScheme.error);
    });

    testWidgets('cash received summary displays formatted total', (
      WidgetTester tester,
    ) async {
      await pumpCashPaymentSummary(
        tester,
        cashTendered: 80000,
        grandTotal: 78000,
      );

      final receivedFinder = find.byKey(const Key('cash_received_summary'));
      expect(receivedFinder, findsOneWidget);
      expect(find.text(formatRupiah(80000)), findsOneWidget);
    });
  });
}
