import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/order/widgets/banknote_keyboard_panel.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

void main() {
  const denominations = [
    1000,
    2000,
    5000,
    10000,
    20000,
    50000,
    100000,
  ];

  Widget buildTestApp({
    required Map<int, int> counts,
    ValueChanged<Map<int, int>>? onCountsChanged,
  }) {
    return _BanknotePanelHarness(
      initialCounts: counts,
      onCountsChanged: onCountsChanged,
    );
  }

  group('BanknoteKeyboardPanel', () {
    testWidgets('keyboard renders seven denomination rows', (tester) async {
      await tester.pumpWidget(buildTestApp(counts: {}));
      await tester.pumpAndSettle();

      for (final denomination in denominations) {
        expect(
          find.byKey(Key('banknote_row_$denomination')),
          findsOneWidget,
        );
      }
    });

    testWidgets('increment updates quantity display', (tester) async {
      Map<int, int>? lastChanged;

      await tester.pumpWidget(
        buildTestApp(
          counts: {},
          onCountsChanged: (updated) => lastChanged = updated,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('banknote_increment_50000')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('banknote_increment_50000')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('banknote_qty_50000')),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
      expect(lastChanged, {50000: 2});
    });

    testWidgets('decrement disabled at zero', (tester) async {
      await tester.pumpWidget(buildTestApp(counts: {10000: 0}));
      await tester.pumpAndSettle();

      final decrement = tester.widget<IconButton>(
        find.descendant(
          of: find.byKey(const Key('banknote_decrement_10000')),
          matching: find.byType(IconButton),
        ),
      );
      expect(decrement.onPressed, isNull);

      await tester.tap(find.byKey(const Key('banknote_increment_10000')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('banknote_qty_10000')),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('banknote_decrement_10000')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('banknote_qty_10000')),
          matching: find.text('0'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('clear all resets counts', (tester) async {
      Map<int, int>? lastChanged;

      await tester.pumpWidget(
        buildTestApp(
          counts: {1000: 2, 50000: 1},
          onCountsChanged: (updated) => lastChanged = updated,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('banknote_clear_all')));
      await tester.pumpAndSettle();

      for (final denomination in denominations) {
        expect(
          find.descendant(
            of: find.byKey(Key('banknote_qty_$denomination')),
            matching: find.text('0'),
          ),
          findsOneWidget,
        );
      }
      expect(lastChanged, isEmpty);
    });
  });
}

class _BanknotePanelHarness extends StatefulWidget {
  const _BanknotePanelHarness({
    required this.initialCounts,
    this.onCountsChanged,
  });

  final Map<int, int> initialCounts;
  final ValueChanged<Map<int, int>>? onCountsChanged;

  @override
  State<_BanknotePanelHarness> createState() => _BanknotePanelHarnessState();
}

class _BanknotePanelHarnessState extends State<_BanknotePanelHarness> {
  late Map<int, int> counts;

  @override
  void initState() {
    super.initState();
    counts = Map<int, int>.from(widget.initialCounts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(AppAccent.blue),
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: BanknoteKeyboardPanel(
          counts: counts,
          onCountsChanged: (updated) {
            setState(() => counts = updated);
            widget.onCountsChanged?.call(updated);
          },
        ),
      ),
    );
  }
}
