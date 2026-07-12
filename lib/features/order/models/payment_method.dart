enum PaymentMethod {
  cash,
  qris;

  String get apiValue => switch (this) {
        PaymentMethod.cash => 'CASH',
        PaymentMethod.qris => 'QRIS',
      };

  static PaymentMethod? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'CASH' || 'OFFLINE' => PaymentMethod.cash,
      'QRIS' => PaymentMethod.qris,
      _ => null,
    };
  }
}
