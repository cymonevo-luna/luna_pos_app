/// Supported IDR banknote denominations in ascending order (whole rupiah).
const List<int> idrBanknoteDenominations = [
  1000,
  2000,
  5000,
  10000,
  20000,
  50000,
  100000,
];

const Set<int> _idrBanknoteDenominationSet = {
  1000,
  2000,
  5000,
  10000,
  20000,
  50000,
  100000,
};

/// Short display labels for supported denominations (e.g. 50000 → "50K").
const Map<int, String> idrBanknoteDisplayLabels = {
  1000: '1K',
  2000: '2K',
  5000: '5K',
  10000: '10K',
  20000: '20K',
  50000: '50K',
  100000: '100K',
};

/// Returns the short UI label for [denomination], or an empty string if unknown.
String idrBanknoteDisplayLabel(int denomination) =>
    idrBanknoteDisplayLabels[denomination] ?? '';

/// Sums `denomination * count` for known denominations; ignores unknown keys.
int calculateCashTotalFromBanknotes(Map<int, int> counts) {
  var total = 0;
  for (final entry in counts.entries) {
    if (_idrBanknoteDenominationSet.contains(entry.key)) {
      total += entry.key * entry.value;
    }
  }
  return total;
}

/// Returns a new map with [denomination] count increased by one.
Map<int, int> incrementBanknoteCount(Map<int, int> counts, int denomination) {
  final current = counts[denomination] ?? 0;
  return {...counts, denomination: current + 1};
}

/// Returns a new map with [denomination] count decreased by one.
/// No-op (returns the same map) when the count is already zero.
Map<int, int> decrementBanknoteCount(Map<int, int> counts, int denomination) {
  final current = counts[denomination] ?? 0;
  if (current <= 0) return counts;
  return {...counts, denomination: current - 1};
}

/// Returns an empty banknote count map.
Map<int, int> clearBanknoteCounts() => {};
