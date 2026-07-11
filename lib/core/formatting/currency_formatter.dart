import 'package:intl/intl.dart';

final _idrFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

/// Formats a whole-number IDR amount (e.g. 35000 → "Rp 35.000").
String formatRupiah(int amount) => _idrFormatter.format(amount);
