import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/order/widgets/cash_payment_summary.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({required Widget child}) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: kSupportedLocales,
      theme: AppTheme.light(AppAccent.blue),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    );
  }

  testWidgets('Shows prominent change when payment sufficient',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const CashPaymentSummary(
          totalAmount: 78000,
          cashReceived: 100000,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('change_amount_display')), findsOneWidget);
    expect(find.byKey(const Key('insufficient_payment_message')), findsNothing);
    expect(find.text(formatRupiah(22000)), findsOneWidget);
  });

  testWidgets('Shows insufficient message when underpaid',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const CashPaymentSummary(
          totalAmount: 78000,
          cashReceived: 50000,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('insufficient_payment_message')), findsOneWidget);
    expect(find.byKey(const Key('change_amount_display')), findsNothing);
  });

  testWidgets('Hides change when no cash entered', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const CashPaymentSummary(
          totalAmount: 78000,
          cashReceived: 0,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('change_amount_display')), findsNothing);
    expect(find.byKey(const Key('cash_received_amount')), findsOneWidget);
    expect(find.text(formatRupiah(0)), findsOneWidget);
  });
}
