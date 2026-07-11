import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Builds a short ESC/POS sample receipt for printer connectivity tests.
Future<List<int>> buildTestReceiptBytes() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  final now = DateTime.now();

  return [
    ...generator.reset(),
    ...generator.text(
      'Luna POS',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ),
    ...generator.text(
      'Test Print',
      styles: const PosStyles(align: PosAlign.center),
    ),
    ...generator.hr(),
    ...generator.text('Printer connection OK'),
    ...generator.text(
      '${now.year}-${_two(now.month)}-${_two(now.day)} '
      '${_two(now.hour)}:${_two(now.minute)}',
      styles: const PosStyles(align: PosAlign.center),
    ),
    ...generator.feed(2),
    ...generator.cut(),
  ];
}

String _two(int value) => value.toString().padLeft(2, '0');
