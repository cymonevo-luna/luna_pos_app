import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/currency_formatter.dart';
import 'models/receipt_data.dart';
import 'models/receipt_line_item.dart';

/// Builds ESC/POS byte payloads for 58mm thermal printers (~32 chars/line).
class ReceiptBuilder {
  ReceiptBuilder(this._profile);

  static const int _charsPerLine = 32;
  static const String _separator = '--------------------------------';

  final CapabilityProfile _profile;

  /// Loads the default printer capability profile and returns a builder.
  static Future<ReceiptBuilder> create() async {
    final profile = await CapabilityProfile.load();
    return ReceiptBuilder(profile);
  }

  /// Produces deterministic ESC/POS bytes for [data].
  List<int> build(ReceiptData data) {
    final generator = Generator(PaperSize.mm58, _profile);
    final bytes = <int>[];
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    bytes
      ..addAll(
        generator.text(
          data.brandName,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      )
      ..addAll(
        generator.text(
          data.branchName,
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(
        generator.text(
          data.branchAddress,
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(
        generator.text(
          data.branchPhone,
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(
        generator.text(
          data.cashierName,
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(
        generator.text(
          '${data.transactionId}  ${dateFormat.format(data.transactionDate)}',
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(_separatorLine(generator));

    for (final item in data.items) {
      bytes.addAll(_buildLineItem(generator, item));
    }

    bytes
      ..addAll(_separatorLine(generator))
      ..addAll(
        _totalRow(generator, 'Subtotal', formatRupiahForReceipt(data.subtotalAmount)),
      );

    if (data.discountAmount > 0) {
      bytes.addAll(
        _totalRow(
          generator,
          'Discount',
          formatRupiahForReceipt(data.discountAmount),
        ),
      );
    }

    bytes.addAll(
      _totalRow(
        generator,
        'TOTAL',
        formatRupiahForReceipt(data.totalAmount),
        bold: true,
      ),
    );

    final paymentLabel = _paymentMethodReceiptLabel(data.paymentMethod);
    if (paymentLabel != null) {
      bytes.addAll(_totalRow(generator, 'Metode', paymentLabel));
    }

    final orderOptionName = data.orderOptionName?.trim();
    if (orderOptionName != null && orderOptionName.isNotEmpty) {
      bytes.addAll(_totalRow(generator, 'Tipe', orderOptionName));
    }

    if (data.cashTendered != null) {
      bytes.addAll(
        _totalRow(
          generator,
          'Bayar',
          formatRupiahForReceipt(data.cashTendered!),
        ),
      );
      bytes.addAll(
        _totalRow(
          generator,
          'Kembalian',
          '-${formatRupiahForReceipt(data.changeAmount)}',
        ),
      );
    }

    bytes
      ..addAll(_separatorLine(generator))
      ..addAll(
        generator.text(
          data.thankYouNote,
          styles: const PosStyles(align: PosAlign.center),
        ),
      )
      ..addAll(generator.feed(2))
      ..addAll(generator.cut(mode: PosCutMode.partial));

    return bytes;
  }

  List<int> _separatorLine(Generator generator) {
    return generator.text(_separator);
  }

  List<int> _buildLineItem(Generator generator, ReceiptLineItem item) {
    final bytes = <int>[];
    final left = _truncate('${item.title} x${item.quantity}', 20);

    bytes.addAll(
      generator.row([
        PosColumn(
          text: left,
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: formatRupiahForReceipt(item.lineTotal),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    final note = item.note?.trim();
    if (note != null && note.isNotEmpty) {
      bytes.addAll(
        generator.text(
          _wrapNote('Note: $note'),
          styles: const PosStyles(align: PosAlign.left),
        ),
      );
    }

    return bytes;
  }

  List<int> _totalRow(
    Generator generator,
    String label,
    String amount, {
    bool bold = false,
  }) {
    return generator.row([
      PosColumn(
        text: label,
        width: 4,
        styles: PosStyles(align: PosAlign.left, bold: bold),
      ),
      PosColumn(
        text: amount,
        width: 8,
        styles: PosStyles(align: PosAlign.right, bold: bold),
      ),
    ]);
  }

  String? _paymentMethodReceiptLabel(String method) {
    return switch (method.toUpperCase()) {
      'CASH' || 'OFFLINE' => 'Tunai',
      'QRIS' => 'QRIS',
      _ => null,
    };
  }

  String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) {
      return value;
    }
    if (maxLength <= 3) {
      return value.substring(0, maxLength);
    }
    return '${value.substring(0, maxLength - 3)}...';
  }

  String _wrapNote(String note) {
    final buffer = StringBuffer();
    var line = '';

    for (final word in note.split(RegExp(r'\s+'))) {
      final candidate = line.isEmpty ? word : '$line $word';
      if (candidate.length > _charsPerLine) {
        if (line.isNotEmpty) {
          buffer.writeln(line);
        }
        line = word.length > _charsPerLine
            ? _truncate(word, _charsPerLine)
            : word;
      } else {
        line = candidate;
      }
    }

    if (line.isNotEmpty) {
      buffer.write(line);
    }

    return buffer.toString();
  }
}

/// Decodes printable ASCII portions of ESC/POS bytes for unit-test assertions.
String decodeReceiptText(List<int> bytes) {
  return String.fromCharCodes(bytes.where((b) => b >= 32 && b <= 126));
}
