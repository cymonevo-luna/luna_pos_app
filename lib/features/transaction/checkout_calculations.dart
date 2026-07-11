import 'dart:math';

import '../menu/models/cart_line.dart';

int cartSubtotal(Map<String, CartLine> cart) =>
    cart.values.fold(0, (sum, line) => sum + line.lineTotal);

int cartItemCount(Map<String, CartLine> cart) =>
    cart.values.fold(0, (sum, line) => sum + line.quantity);

int computeChangeAmount({required int cashTendered, required int total}) =>
    max(0, cashTendered - total);

bool isPaymentSufficient({required int cashTendered, required int total}) =>
    cashTendered >= total;
