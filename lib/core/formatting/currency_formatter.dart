import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _idrFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

/// Formats a whole-number IDR amount (e.g. 35000 → "Rp 35.000").
String formatRupiah(int amount) => _idrFormatter.format(amount);

final _receiptIdrFormatter = NumberFormat('#,###', 'id_ID');

/// Receipt-safe IDR formatting with plain ASCII (no locale-specific bytes).
String formatRupiahForReceipt(int amount) =>
    'Rp ${_receiptIdrFormatter.format(amount)}';

/// Parses user-entered digits into a whole-number IDR amount.
int parseIdrAmount(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  return int.parse(digits);
}

/// Restricts input to whole-number IDR digits (no decimals or separators).
class IdrWholeNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

/// Cash payment change: [cashReceived] minus [grandTotal].
int calculatePaymentChange({
  required int cashReceived,
  required int grandTotal,
}) =>
    cashReceived - grandTotal;

/// Whether [cashReceived] covers [grandTotal].
bool isPaymentSufficient({
  required int cashReceived,
  required int grandTotal,
}) =>
    cashReceived >= grandTotal;
