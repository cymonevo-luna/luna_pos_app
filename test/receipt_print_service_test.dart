import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/receipt/models/receipt_data.dart';
import 'package:luna_pos/features/receipt/models/receipt_line_item.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';

import 'helpers/mock_bluetooth_printer_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBluetoothPrinterService mockPrinter;
  late ReceiptPrintService service;

  ReceiptData sampleReceiptData() {
    return ReceiptData(
      brandName: 'Luna Cafe',
      branchName: 'Cabang Sudirman',
      branchAddress: 'Jl. Sudirman No. 10, Jakarta',
      branchPhone: '021-1234567',
      cashierName: 'Budi Santoso',
      transactionId: 'TXN-001',
      transactionDate: DateTime(2026, 7, 11, 14, 30),
      paymentMethod: 'CASH',
      items: const [
        ReceiptLineItem(
          title: 'Es Teh Manis',
          quantity: 2,
          note: 'less ice',
          lineTotal: 16000,
        ),
      ],
      subtotalAmount: 16000,
      totalAmount: 16000,
      cashTendered: 20000,
      changeAmount: 4000,
      thankYouNote: 'Terima kasih!',
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await locator.reset();
    locator.registerSingleton<PreferencesService>(
      await PreferencesService.create(),
    );

    mockPrinter = MockBluetoothPrinterService();
    locator.registerSingleton<BluetoothPrinterService>(mockPrinter);
    service = ReceiptPrintService();
  });

  tearDown(() {
    mockPrinter.dispose();
  });

  test('printReceiptData prints ESC/POS bytes on success', () async {
    await mockPrinter.connect('00:11:22:33:44:55');

    final result = await service.printReceiptData(sampleReceiptData());

    expect(result.succeeded, isTrue);
    expect(result.error, isNull);
    expect(result.receiptBytes, isNotNull);
    expect(result.receiptBytes, isNotEmpty);
    expect(mockPrinter.lastPrintedBytes, isNotNull);
    expect(mockPrinter.lastPrintedBytes, isNotEmpty);
  });

  test('printReceiptData returns error when printer not connected', () async {
    final result = await service.printReceiptData(sampleReceiptData());

    expect(result.succeeded, isFalse);
    expect(result.error, isNotNull);
    expect(result.receiptBytes, isNotNull);
    expect(mockPrinter.lastPrintedBytes, isNull);
  });

  test('printReceiptData returns BluetoothPrinterException message', () async {
    mockPrinter.dispose();
    mockPrinter = MockBluetoothPrinterService(printSucceeds: false);
    locator.unregister<BluetoothPrinterService>();
    locator.registerSingleton<BluetoothPrinterService>(mockPrinter);
    service = ReceiptPrintService();
    await mockPrinter.connect('00:11:22:33:44:55');

    final result = await service.printReceiptData(sampleReceiptData());

    expect(result.succeeded, isFalse);
    expect(result.error, 'Print failed.');
  });
}
