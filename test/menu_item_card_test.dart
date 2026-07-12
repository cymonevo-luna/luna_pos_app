import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_spacing.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/menu/widgets/menu_item_card.dart';

/// Grid cell size for a 2-column phone layout at [viewportWidth], matching
/// [MenuPage]'s `SliverGridDelegateWithFixedCrossAxisCount` formula.
Size phoneGridCellSize({double viewportWidth = 360}) {
  const padding = AppSpacing.md;
  const crossAxisSpacing = AppSpacing.sm;
  const crossAxisCount = 2;
  const childAspectRatio = 0.68;

  final innerWidth =
      viewportWidth - padding * 2 - crossAxisSpacing * (crossAxisCount - 1);
  final cellWidth = innerWidth / crossAxisCount;
  final cellHeight = cellWidth / childAspectRatio;
  return Size(cellWidth, cellHeight);
}

POSMenuItem sampleItem({
  String id = 'm1',
  String title = 'Nasi Goreng',
  int availableStock = 5,
  int sellPrice = 35000,
}) {
  return POSMenuItem(
    id: id,
    title: title,
    availableStock: availableStock,
    sellPrice: sellPrice,
  );
}

Future<void> pumpMenuItemCard(
  WidgetTester tester, {
  required POSMenuItem item,
  VoidCallback? onAdd,
  Size? cellSize,
  double textScaleFactor = 1.0,
}) async {
  var addCount = 0;
  final callback = onAdd ?? () => addCount++;

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccent.blue),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScaleFactor)),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: cellSize?.width ?? phoneGridCellSize().width,
              height: cellSize?.height ?? phoneGridCellSize().height,
              child: MenuItemCard(item: item, onAdd: callback),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('MenuItemCard', () {
    testWidgets('in-stock card renders without overflow at grid cell size', (
      WidgetTester tester,
    ) async {
      final item = sampleItem(availableStock: 7);
      await pumpMenuItemCard(tester, item: item);

      expect(tester.takeException(), isNull);
      expect(find.text(item.title), findsOneWidget);
      expect(find.text(formatRupiah(item.sellPrice)), findsOneWidget);
      expect(find.text('Stock: ${item.availableStock}'), findsOneWidget);
    });

    testWidgets('in-stock card triggers onAdd when tapped', (
      WidgetTester tester,
    ) async {
      var tapped = false;
      await pumpMenuItemCard(
        tester,
        item: sampleItem(),
        onAdd: () => tapped = true,
      );

      await tester.tap(find.byType(MenuItemCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('out-of-stock card renders without overflow', (
      WidgetTester tester,
    ) async {
      var tapped = false;
      final item = sampleItem(title: 'Sold Out Item', availableStock: 0);
      await pumpMenuItemCard(tester, item: item, onAdd: () => tapped = true);

      expect(tester.takeException(), isNull);
      expect(find.text('Out of stock'), findsWidgets);

      await tester.tap(find.byType(MenuItemCard));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('long menu title ellipsizes instead of overflowing', (
      WidgetTester tester,
    ) async {
      final longTitle =
          'Extra Spicy Chicken Wings With Special House Sauce And Fries';
      final item = sampleItem(title: longTitle);
      await pumpMenuItemCard(tester, item: item);

      expect(tester.takeException(), isNull);

      final titleTexts = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(MenuItemCard),
              matching: find.text(longTitle),
            ),
          )
          .toList();
      expect(titleTexts, hasLength(1));
      expect(titleTexts.single.maxLines, 1);
      expect(titleTexts.single.overflow, TextOverflow.ellipsis);
    });

    testWidgets('renders without overflow at elevated text scale', (
      WidgetTester tester,
    ) async {
      await pumpMenuItemCard(
        tester,
        item: sampleItem(
          title:
              'Very Long Menu Item Name That Should Still Fit In The Grid Cell',
        ),
        textScaleFactor: 1.3,
      );

      expect(tester.takeException(), isNull);
    });
  });
}
