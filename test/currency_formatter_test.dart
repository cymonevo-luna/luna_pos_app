import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/core/formatting/currency_formatter.dart';

void main() {
  test('formatRupiah formats whole IDR amounts', () {
    expect(formatRupiah(35000), 'Rp 35.000');
    expect(formatRupiah(8000), 'Rp 8.000');
  });
}
