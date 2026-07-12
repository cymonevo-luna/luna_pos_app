import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/purchase/purchase_request_estimator.dart';

void main() {
  test('estimateLineTotal uses round half up', () {
    final total = estimateLineTotal(
      quantity: 1000,
      priceAmount: 140000,
      priceQuantity: 1000,
    );

    expect(total, 140000);
  });
}
