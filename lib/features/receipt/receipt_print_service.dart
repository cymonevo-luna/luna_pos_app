import '../../core/di/locator.dart';
import '../../core/printer/bluetooth_printer_service.dart';
import '../../core/storage/preferences_service.dart';
import '../printer/printer_controller.dart';
import 'models/receipt_data.dart';
import 'receipt_builder.dart';

/// Result of a receipt print attempt.
typedef ReceiptPrintResult = ({
  bool succeeded,
  String? error,
  List<int>? receiptBytes,
});

/// Shared Bluetooth receipt printing: connect, build ESC/POS bytes, send to printer.
class ReceiptPrintService {
  ReceiptPrintService({
    BluetoothPrinterService? printer,
    PreferencesService? prefs,
  })  : _printer = printer ?? locator<BluetoothPrinterService>(),
        _prefs = prefs ?? locator<PreferencesService>();

  final BluetoothPrinterService _printer;
  final PreferencesService _prefs;

  /// Builds receipt bytes from [data] and prints them.
  Future<ReceiptPrintResult> printReceiptData(ReceiptData data) async {
    final builder = await ReceiptBuilder.create();
    final receiptBytes = builder.build(data);
    final result = await printBytes(receiptBytes);
    return (
      succeeded: result.succeeded,
      error: result.error,
      receiptBytes: receiptBytes,
    );
  }

  /// Sends pre-built ESC/POS [bytes] to the printer.
  Future<({bool succeeded, String? error})> printBytes(List<int> bytes) async {
    try {
      final connected = await _ensurePrinterConnected();
      if (!connected) {
        return (
          succeeded: false,
          error: 'Printer is not connected.',
        );
      }

      await _printer.printBytes(bytes);
      return (succeeded: true, error: null);
    } on BluetoothPrinterException catch (error) {
      return (succeeded: false, error: error.message);
    } catch (_) {
      return (succeeded: false, error: PrinterMessages.printFailed);
    }
  }

  Future<bool> _ensurePrinterConnected() async {
    if (_printer.isConnected) return true;

    final deviceId = _prefs.getString(PrefKeys.printerDeviceId);
    if (deviceId == null) return false;

    try {
      final granted = await _printer.requestPermissions();
      if (!granted) return false;

      await _printer.connect(deviceId);
      return _printer.isConnected;
    } catch (_) {
      return false;
    }
  }
}
