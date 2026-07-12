/// A paired Bluetooth device that may be used as a thermal receipt printer.
class BluetoothPrinterDevice {
  const BluetoothPrinterDevice({
    required this.address,
    required this.name,
  });

  final String address;
  final String name;

  static const _thermalKeywords = [
    'rp',
    'pos',
    'printer',
    'mtp',
    'innerprinter',
  ];

  /// Heuristic check for common thermal printer Bluetooth names.
  bool get isLikelyThermalPrinter {
    final normalized = name.toLowerCase();
    return _thermalKeywords.any(normalized.contains);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothPrinterDevice &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          name == other.name;

  @override
  int get hashCode => Object.hash(address, name);
}
