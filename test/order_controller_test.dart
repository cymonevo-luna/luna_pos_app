import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/order_controller.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  POSMenuItem sampleItem({
    String id = 'm1',
    String title = 'Es Teh',
    int sellPrice = 8000,
    int availableStock = 10,
  }) {
    return POSMenuItem(
      id: id,
      title: title,
      availableStock: availableStock,
      sellPrice: sellPrice,
    );
  }

  test('add line computes line and grand totals', () {
    final controller = container.read(orderProvider.notifier);

    controller.addLine(sampleItem(), quantity: 2);

    final state = container.read(orderProvider);
    expect(state.lines, hasLength(1));
    expect(state.lines.first.lineTotal, 16000);
    expect(state.grandTotal, 16000);
    expect(state.itemCount, 2);
  });

  test('merge duplicate menu and note increments quantity', () {
    final controller = container.read(orderProvider.notifier);
    final item = sampleItem(sellPrice: 5000);

    controller.addLine(item, quantity: 1, note: 'less ice');
    controller.addLine(item, quantity: 2, note: 'less ice');

    final state = container.read(orderProvider);
    expect(state.lines, hasLength(1));
    expect(state.lines.first.quantity, 3);
    expect(state.lines.first.note, 'less ice');
    expect(state.grandTotal, 15000);
    expect(state.itemCount, 3);
  });

  test('reject quantity above available stock', () {
    final controller = container.read(orderProvider.notifier);
    final item = sampleItem(availableStock: 3);

    controller.addLine(item, quantity: 2);
    controller.addLine(item, quantity: 2);

    final state = container.read(orderProvider);
    expect(state.lines, hasLength(1));
    expect(state.lines.first.quantity, 2);
    expect(state.itemCount, 2);
    expect(state.errorMessage, isNotNull);
    expect(state.grandTotal, 16000);
  });

  test('quantityForMenu targets empty-note line only', () {
    final controller = container.read(orderProvider.notifier);
    final item = sampleItem();

    controller.addLine(item, quantity: 2, note: 'less ice');
    controller.addLine(item, quantity: 3);

    final state = container.read(orderProvider);
    expect(state.quantityForMenu('m1'), 3);
    expect(state.quantityForMenu('m1', note: 'less ice'), 2);
    expect(state.findLineIdForMenu('m1'), isNotNull);
    expect(state.findLineIdForMenu('m1', note: 'missing'), isNull);
  });

  test('clear empties cart', () {
    final controller = container.read(orderProvider.notifier);

    controller
      ..addLine(sampleItem(), quantity: 2)
      ..addLine(
        sampleItem(id: 'm2', title: 'Kopi', sellPrice: 12000),
        quantity: 1,
      )
      ..clear();

    final state = container.read(orderProvider);
    expect(state.lines, isEmpty);
    expect(state.itemCount, 0);
    expect(state.grandTotal, 0);
    expect(state.errorMessage, isNull);
  });
}
