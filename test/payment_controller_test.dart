import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/order/models/order_line_item.dart';
import 'package:luna_pos/features/transaction/payment_controller.dart';

void main() {
  test('buildTransactionItems maps order lines to line item snapshots', () {
    final lines = [
      const OrderLineItem(
        id: 'l1',
        menuId: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        quantity: 2,
        note: 'less ice',
      ),
      const OrderLineItem(
        id: 'l2',
        menuId: 'm2',
        title: 'Nasi Goreng',
        sellPrice: 35000,
        quantity: 1,
      ),
      const OrderLineItem(
        id: 'l3',
        menuId: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        quantity: 1,
        note: 'no ice',
      ),
    ];

    final items = buildTransactionItems(lines);

    expect(items, hasLength(3));
    expect(items[0].menuId, 'm1');
    expect(items[0].title, 'Es Teh');
    expect(items[0].quantity, 2);
    expect(items[0].unitPrice, 8000);
    expect(items[0].lineTotal, 16000);
    expect(items[0].note, 'less ice');

    expect(items[1].menuId, 'm2');
    expect(items[1].title, 'Nasi Goreng');
    expect(items[1].quantity, 1);
    expect(items[1].unitPrice, 35000);
    expect(items[1].lineTotal, 35000);
    expect(items[1].note, isNull);

    expect(items[2].menuId, 'm1');
    expect(items[2].quantity, 1);
    expect(items[2].note, 'no ice');
  });
}
