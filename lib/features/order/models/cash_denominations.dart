/// Supported IDR banknote denominations in ascending order (whole rupiah).
const List<int> supportedCashDenominations = [
  1000,
  2000,
  5000,
  10000,
  20000,
  50000,
  100000,
];

/// Short display labels keyed by denomination value.
const Map<int, String> cashDenominationShortLabels = {
  1000: '1K',
  2000: '2K',
  5000: '5K',
  10000: '10K',
  20000: '20K',
  50000: '50K',
  100000: '100K',
};

/// Non-negative quantity per supported denomination value.
typedef DenominationCounts = Map<int, int>;

bool _isSupportedDenomination(int denomination) =>
    cashDenominationShortLabels.containsKey(denomination);

/// Returns the short label for [denomination], or an empty string when unknown.
String denominationShortLabel(int denomination) =>
    cashDenominationShortLabels[denomination] ?? '';

/// Zero quantity for every supported denomination.
Map<int, int> emptyDenominationCounts() => {
      for (final denomination in supportedCashDenominations) denomination: 0,
    };

/// Sums `denomination * quantity` for supported denominations only.
///
/// Missing keys are treated as zero. Unknown denomination keys are ignored.
int calculateCashTenderedFromCounts(Map<int, int> counts) {
  var total = 0;
  for (final denomination in supportedCashDenominations) {
    final quantity = counts[denomination] ?? 0;
    if (quantity > 0) {
      total += denomination * quantity;
    }
  }
  return total;
}

/// Returns a new map with +1 for a valid [denomination]; unchanged when invalid.
Map<int, int> incrementDenominationCount(
  Map<int, int> counts,
  int denomination,
) {
  if (!_isSupportedDenomination(denomination)) {
    return Map<int, int>.from(counts);
  }

  final updated = Map<int, int>.from(counts);
  updated[denomination] = (updated[denomination] ?? 0) + 1;
  return updated;
}

/// Returns a new map with -1 for a valid [denomination], floored at 0.
Map<int, int> decrementDenominationCount(
  Map<int, int> counts,
  int denomination,
) {
  if (!_isSupportedDenomination(denomination)) {
    return Map<int, int>.from(counts);
  }

  final updated = Map<int, int>.from(counts);
  final next = (updated[denomination] ?? 0) - 1;
  updated[denomination] = next < 0 ? 0 : next;
  return updated;
}
