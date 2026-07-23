import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/order/models/cash_denominations.dart';
import 'package:luna_pos/features/order/widgets/banknote_cash_keyboard.dart';

Future<void> pumpBanknoteCashKeyboard(
  WidgetTester tester, {
  Map<int, int>? counts,
  ValueChanged<Map<int, int>>? onCountsChanged,
  bool enabled = true,
}) async {
  final currentCounts = counts ?? emptyDenominationCounts();

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccent.blue),
      home: Scaffold(
        body: BanknoteCashKeyboard(
          counts: currentCounts,
          enabled: enabled,
          onCountsChanged: onCountsChanged ?? (_) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('BanknoteCashKeyboard', () {
    testWidgets('renders seven denomination rows', (WidgetTester tester) async {
      await pumpBanknoteCashKeyboard(tester);

      expect(find.byKey(const Key('cash_tendered_field')), findsOneWidget);

      for (final denomination in supportedCashDenominations) {
        expect(
          find.byKey(Key('banknote_${denomination}_increment')),
          findsOneWidget,
        );
        expect(
          find.byKey(Key('banknote_${denomination}_decrement')),
          findsOneWidget,
        );
        expect(
          find.byKey(Key('banknote_${denomination}_qty')),
          findsOneWidget,
        );
      }
    });

    testWidgets('increment updates quantity and callback', (
      WidgetTester tester,
    ) async {
      Map<int, int>? lastChanged;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          home: Scaffold(
            body: _TestHarness(
              onCountsChanged: (updated) => lastChanged = updated,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('banknote_50000_increment')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('banknote_50000_increment')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('banknote_50000_qty')), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(lastChanged, isNotNull);
      expect(lastChanged![50000], 2);
    });

    testWidgets('decrement blocked at zero', (WidgetTester tester) async {
      Map<int, int>? lastChanged;
      final counts = emptyDenominationCounts();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          home: Scaffold(
            body: BanknoteCashKeyboard(
              counts: counts,
              onCountsChanged: (updated) => lastChanged = updated,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final decrementButton = tester.widget<IconButton>(
        find.byKey(const Key('banknote_10000_decrement')),
      );
      expect(decrementButton.onPressed, isNull);

      await tester.tap(find.byKey(const Key('banknote_10000_decrement')));
      await tester.pumpAndSettle();

      expect(find.text('0'), findsWidgets);
      expect(lastChanged, isNull);
    });

    testWidgets('disabled keyboard ignores taps', (WidgetTester tester) async {
      Map<int, int>? lastChanged;
      final counts = emptyDenominationCounts();

      await pumpBanknoteCashKeyboard(
        tester,
        counts: counts,
        enabled: false,
        onCountsChanged: (updated) => lastChanged = updated,
      );

      final incrementButton = tester.widget<IconButton>(
        find.byKey(const Key('banknote_50000_increment')),
      );
      expect(incrementButton.onPressed, isNull);

      await tester.tap(find.byKey(const Key('banknote_50000_increment')));
      await tester.pumpAndSettle();

      expect(lastChanged, isNull);
      expect(find.text('0'), findsWidgets);
    });
  });
}

class _TestHarness extends StatefulWidget {
  const _TestHarness({required this.onCountsChanged});

  final ValueChanged<Map<int, int>> onCountsChanged;

  @override
  State<_TestHarness> createState() => _TestHarnessState();
}

class _TestHarnessState extends State<_TestHarness> {
  late Map<int, int> _counts;

  @override
  void initState() {
    super.initState();
    _counts = emptyDenominationCounts();
  }

  @override
  Widget build(BuildContext context) {
    return BanknoteCashKeyboard(
      counts: _counts,
      onCountsChanged: (updated) {
        setState(() => _counts = updated);
        widget.onCountsChanged(updated);
      },
    );
  }
}
