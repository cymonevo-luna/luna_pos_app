/// Formats a food-supply quantity with unit, converting large values to kg/L.
String formatMeasurementQuantity(num quantity, String unit) {
  switch (unit) {
    case 'gr':
      if (quantity >= 1000) {
        return '${_formatNum(quantity / 1000)} kg';
      }
      return '${_formatNum(quantity)} gr';
    case 'ml':
      if (quantity >= 1000) {
        return '${_formatNum(quantity / 1000)} L';
      }
      return '${_formatNum(quantity)} ml';
    case 'piece':
      return '${_formatNum(quantity)} pcs';
    default:
      return '${_formatNum(quantity)} $unit';
  }
}

String formatMeasurementUnitLabel(String unit) {
  return switch (unit) {
    'gr' => 'Grams (gr)',
    'ml' => 'Milliliters (ml)',
    'piece' => 'Pieces',
    _ => unit,
  };
}

String _formatNum(num value) {
  if (value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}
