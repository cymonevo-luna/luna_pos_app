import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';

void main() {
  test('formatRupiah formats whole IDR amounts', () {
    expect(formatRupiah(35000), 'Rp 35.000');
    expect(formatRupiah(8000), 'Rp 8.000');
  });

  test('parseIdrAmount extracts whole-number digits', () {
    expect(parseIdrAmount('50000'), 50000);
    expect(parseIdrAmount('Rp 50.000'), 50000);
    expect(parseIdrAmount(''), 0);
  });

  test('payment change and sufficiency helpers', () {
    expect(
      calculatePaymentChange(cashReceived: 50000, grandTotal: 45000),
      5000,
    );
    expect(
      calculatePaymentChange(cashReceived: 45000, grandTotal: 45000),
      0,
    );
    expect(isPaymentSufficient(cashReceived: 50000, grandTotal: 45000), isTrue);
    expect(isPaymentSufficient(cashReceived: 40000, grandTotal: 45000), isFalse);
  });
}
