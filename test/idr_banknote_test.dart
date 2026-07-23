import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/order/models/idr_banknote.dart';

void main() {
  test('calculateCashTotalFromBanknotes sums mixed counts', () {
    expect(
      calculateCashTotalFromBanknotes({50000: 2, 20000: 1}),
      120000,
    );
  });

  test('incrementBanknoteCount increases from zero', () {
    expect(incrementBanknoteCount({}, 1000), {1000: 1});
    expect(incrementBanknoteCount({1000: 1}, 1000), {1000: 2});
  });

  test('decrementBanknoteCount does not go below zero', () {
    final counts = {1000: 0};
    expect(decrementBanknoteCount(counts, 1000), {1000: 0});
    expect(decrementBanknoteCount(counts, 1000), same(counts));
  });

  test('calculateCashTotalFromBanknotes ignores unknown denominations', () {
    expect(
      calculateCashTotalFromBanknotes({50000: 1, 777: 10}),
      50000,
    );
  });

  test('clearBanknoteCounts returns empty map', () {
    expect(clearBanknoteCounts(), isEmpty);
  });

  test('idrBanknoteDenominations lists all supported values in order', () {
    expect(idrBanknoteDenominations, hasLength(7));
    expect(
      idrBanknoteDenominations,
      [
        1000,
        2000,
        5000,
        10000,
        20000,
        50000,
        100000,
      ],
    );
  });

  test('idrBanknoteDisplayLabels match expected short labels', () {
    expect(idrBanknoteDisplayLabel(1000), '1K');
    expect(idrBanknoteDisplayLabel(50000), '50K');
    expect(idrBanknoteDisplayLabel(100000), '100K');
    expect(idrBanknoteDisplayLabel(999), '');
  });
}
