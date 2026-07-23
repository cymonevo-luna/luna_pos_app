import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/purchase/models/supplier.dart';
import 'package:luna_pos/features/purchase/purchase_request_estimator.dart';

void main() {
  final quote = PriceQuote(
    foodSupplyId: 'fs-1',
    foodSupplyTitle: 'Flour',
    unit: 'gr',
    priceAmount: 140000,
    priceQuantity: 1000,
    unitPrice: 140,
  );

  test('estimateLineTotal uses round half up', () {
    final total = estimateLineTotal(
      quantity: 1000,
      priceAmount: 140000,
      priceQuantity: 1000,
    );

    expect(total, 140000);
  });

  test('resolvedLineTotal uses actual amount when provided', () {
    final total = resolvedLineTotal(
      quantity: 1000,
      quote: quote,
      lineActualAmount: 135000,
    );

    expect(total, 135000);
  });

  test('resolvedGrandTotal coalesces actual and estimated per line', () {
    final total = resolvedGrandTotal([
      (quote: quote, quantity: 1000, lineActualAmount: 135000),
      (quote: quote, quantity: 500, lineActualAmount: null),
    ]);

    expect(total, 135000 + 70000);
  });
}
