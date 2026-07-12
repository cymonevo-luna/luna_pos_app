import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/order/models/order_line_item.dart';
import 'package:luna_pos/features/transaction/payment_controller.dart';

void main() {
  test('buildTransactionItems aggregates quantities by menu id', () {
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

    expect(items, hasLength(2));
    expect(
      items.map((item) => (item.menuId, item.quantity)).toSet(),
      {
        ('m1', 3),
        ('m2', 1),
      },
    );
  });
}
