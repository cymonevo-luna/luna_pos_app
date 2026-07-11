import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/menu/models/cart_line.dart';
import 'package:luna_pos/features/transaction/checkout_calculations.dart';

void main() {
  test('cart subtotal and change calculation', () {
    final cart = <String, CartLine>{
      'm1': const CartLine(
        menuId: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        quantity: 2,
      ),
      'm2': const CartLine(
        menuId: 'm2',
        title: 'Nasi Goreng',
        sellPrice: 35000,
        quantity: 1,
      ),
    };

    expect(cartSubtotal(cart), 51000);
    expect(cartItemCount(cart), 3);
    expect(
      computeChangeAmount(cashTendered: 60000, total: 51000),
      9000,
    );
    expect(
      isPaymentSufficient(cashTendered: 60000, total: 51000),
      isTrue,
    );
    expect(
      isPaymentSufficient(cashTendered: 50000, total: 51000),
      isFalse,
    );
  });
}
