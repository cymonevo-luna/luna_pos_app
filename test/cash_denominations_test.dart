import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/features/order/models/cash_denominations.dart';

void main() {
  test('empty denomination counts total zero', () {
    expect(calculateCashTenderedFromCounts(emptyDenominationCounts()), 0);
  });

  test('mixed denomination tally', () {
    final counts = emptyDenominationCounts()
      ..[50000] = 2
      ..[20000] = 1
      ..[5000] = 3;

    expect(calculateCashTenderedFromCounts(counts), 135000);
  });

  test('decrement floored at zero', () {
    final counts = emptyDenominationCounts();
    final decremented = decrementDenominationCount(counts, 10000);

    expect(decremented[10000], 0);
    expect(() => decrementDenominationCount(decremented, 10000), returnsNormally);
  });

  test('supported denominations are complete and ordered', () {
    expect(
      supportedCashDenominations,
      [1000, 2000, 5000, 10000, 20000, 50000, 100000],
    );
    expect(supportedCashDenominations, hasLength(7));

    for (final denomination in supportedCashDenominations) {
      expect(denominationShortLabel(denomination), isNotEmpty);
      expect(
        denominationShortLabel(denomination),
        cashDenominationShortLabels[denomination],
      );
    }

    expect(denominationShortLabel(1000), '1K');
    expect(denominationShortLabel(2000), '2K');
    expect(denominationShortLabel(5000), '5K');
    expect(denominationShortLabel(10000), '10K');
    expect(denominationShortLabel(20000), '20K');
    expect(denominationShortLabel(50000), '50K');
    expect(denominationShortLabel(100000), '100K');
  });

  test('increment updates valid denomination counts immutably', () {
    final counts = emptyDenominationCounts();
    final updated = incrementDenominationCount(counts, 5000);

    expect(counts[5000], 0);
    expect(updated[5000], 1);
    expect(identical(counts, updated), isFalse);
  });

  test('unknown denomination keys are ignored when calculating total', () {
    final counts = {999: 10, 5000: 1};

    expect(calculateCashTenderedFromCounts(counts), 5000);
  });
}
