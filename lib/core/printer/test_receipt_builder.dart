import 'package:esc_pos_utils/esc_pos_utils.dart';

/// Builds a short ESC/POS sample receipt for printer connectivity tests.
Future<List<int>> buildTestReceiptBytes() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  final now = DateTime.now();

  return [
    ...generator.text(
      'Luna POS',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ),
    ...generator.text(
      'Test Print',
      styles: const PosStyles(align: PosAlign.center),
    ),
    ...generator.text('--------------------------------'),
    ...generator.text('Printer connection OK'),
    ...generator.text(
      '${now.year}-${_two(now.month)}-${_two(now.day)} '
      '${_two(now.hour)}:${_two(now.minute)}',
      styles: const PosStyles(align: PosAlign.center),
    ),
    ...generator.feed(2),
    ...generator.cut(mode: PosCutMode.partial),
  ];
}

String _two(int value) => value.toString().padLeft(2, '0');
