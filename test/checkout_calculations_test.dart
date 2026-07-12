import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/features/order/models/order_line_item.dart';

void main() {
  test('cart subtotal and change calculation', () {
    final lines = [
      const OrderLineItem(
        id: 'l1',
        menuId: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        quantity: 2,
      ),
      const OrderLineItem(
        id: 'l2',
        menuId: 'm2',
        title: 'Nasi Goreng',
        sellPrice: 35000,
        quantity: 1,
      ),
    ];

    final amount = lines.fold(0, (sum, line) => sum + line.lineTotal);
    expect(amount, 51000);
    expect(
      calculatePaymentChange(cashReceived: 60000, grandTotal: amount),
      9000,
    );
    expect(
      isPaymentSufficient(cashReceived: 60000, grandTotal: amount),
      isTrue,
    );
    expect(
      isPaymentSufficient(cashReceived: 50000, grandTotal: amount),
      isFalse,
    );
  });
}
