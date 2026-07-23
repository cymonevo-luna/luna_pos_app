import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/menu/widgets/menu_item_list_row.dart';
import 'package:luna_pos/features/menu/widgets/menu_photo.dart';

POSMenuItem sampleListRowItem({
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

Future<void> pumpMenuItemListRow(
  WidgetTester tester, {
  required POSMenuItem item,
  int cartQuantity = 0,
  VoidCallback? onIncrement,
  VoidCallback? onDecrement,
  VoidCallback? onAddNote,
  double viewportWidth = 360,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccent.blue),
      home: MediaQuery(
        data: MediaQueryData(size: Size(viewportWidth, 640)),
        child: Scaffold(
          body: MenuItemListRow(
            item: item,
            cartQuantity: cartQuantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onAddNote: onAddNote,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

IconButton iconButtonByKey(WidgetTester tester, String keyValue) {
  return tester.widget<IconButton>(
    find.descendant(
      of: find.byKey(Key(keyValue)),
      matching: find.byType(IconButton),
    ),
  );
}

void main() {
  group('MenuItemListRow', () {
    testWidgets('list row renders single-line content', (WidgetTester tester) async {
      final item = sampleListRowItem();
      await pumpMenuItemListRow(tester, item: item);

      expect(tester.takeException(), isNull);
      expect(find.byType(MenuItemListRow), findsOneWidget);
      expect(find.byKey(Key('menu_list_row_${item.id}')), findsOneWidget);
      expect(find.text(item.title), findsOneWidget);
      expect(find.text(formatRupiah(item.sellPrice)), findsOneWidget);
      expect(find.byKey(Key('menu_list_dec_${item.id}')), findsOneWidget);
      expect(find.byKey(Key('menu_list_qty_${item.id}')), findsOneWidget);
      expect(find.byKey(Key('menu_list_inc_${item.id}')), findsOneWidget);
      expect(find.byKey(Key('menu_list_note_${item.id}')), findsOneWidget);
      expect(find.byType(MenuPhoto), findsNothing);
      expect(find.byType(Image), findsNothing);

      final rowBox = tester.renderObject<RenderBox>(
        find.byKey(Key('menu_list_row_${item.id}')),
      );
      expect(rowBox.size.height, MenuItemListRow.rowHeight);

      final titleTexts = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(MenuItemListRow),
              matching: find.text(item.title),
            ),
          )
          .toList();
      expect(titleTexts, hasLength(1));
      expect(titleTexts.single.maxLines, 1);
      expect(titleTexts.single.overflow, TextOverflow.ellipsis);
    });

    testWidgets('list row shows cart quantity', (WidgetTester tester) async {
      final item = sampleListRowItem();
      await pumpMenuItemListRow(tester, item: item, cartQuantity: 3);

      expect(find.text('3'), findsOneWidget);
      expect(find.byKey(Key('menu_list_qty_${item.id}')), findsOneWidget);
    });

    testWidgets('out of stock disables actions', (WidgetTester tester) async {
      final item = sampleListRowItem(availableStock: 0);
      await pumpMenuItemListRow(
        tester,
        item: item,
        cartQuantity: 2,
        onIncrement: () {},
        onDecrement: () {},
        onAddNote: () {},
      );

      expect(
        iconButtonByKey(tester, 'menu_list_inc_${item.id}').onPressed,
        isNull,
      );
      expect(
        iconButtonByKey(tester, 'menu_list_dec_${item.id}').onPressed,
        isNull,
      );
      expect(
        iconButtonByKey(tester, 'menu_list_note_${item.id}').onPressed,
        isNull,
      );
      expect(find.text('Out of stock'), findsOneWidget);

      final opacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byKey(Key('menu_list_row_${item.id}')),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, lessThan(1));
    });

    testWidgets('action callbacks fire', (WidgetTester tester) async {
      final item = sampleListRowItem();
      var incrementCount = 0;
      var decrementCount = 0;
      var noteCount = 0;

      await pumpMenuItemListRow(
        tester,
        item: item,
        cartQuantity: 1,
        onIncrement: () => incrementCount++,
        onDecrement: () => decrementCount++,
        onAddNote: () => noteCount++,
      );

      await tester.tap(find.byKey(Key('menu_list_inc_${item.id}')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('menu_list_dec_${item.id}')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('menu_list_note_${item.id}')));
      await tester.pumpAndSettle();

      expect(incrementCount, 1);
      expect(decrementCount, 1);
      expect(noteCount, 1);
    });

    testWidgets('long title ellipsizes without overflow on narrow phones', (
      WidgetTester tester,
    ) async {
      final longTitle =
          'Extra Spicy Chicken Wings With Special House Sauce And Fries';
      final item = sampleListRowItem(title: longTitle);
      await pumpMenuItemListRow(tester, item: item, viewportWidth: 320);

      expect(tester.takeException(), isNull);
      expect(find.text(longTitle), findsOneWidget);
    });
  });
}
