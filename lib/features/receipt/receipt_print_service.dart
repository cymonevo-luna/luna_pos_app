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

typedef PrinterConnectionResult = ({bool connected, String? error});

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
  Future<ReceiptPrintResult> printReceiptData(
    ReceiptData data, {
    String? deviceAddress,
  }) async {
    final builder = await ReceiptBuilder.create();
    final receiptBytes = builder.build(data);
    final result = await printBytes(
      receiptBytes,
      deviceAddress: deviceAddress,
    );
    return (
      succeeded: result.succeeded,
      error: result.error,
      receiptBytes: receiptBytes,
    );
  }

  /// Sends pre-built ESC/POS [bytes] to the printer.
  Future<({bool succeeded, String? error})> printBytes(
    List<int> bytes, {
    String? deviceAddress,
  }) async {
    try {
      final connection = await _ensurePrinterConnected(
        deviceAddress: deviceAddress,
      );
      if (!connection.connected) {
        return (succeeded: false, error: connection.error);
      }

      await _printer.printBytes(bytes);
      return (succeeded: true, error: null);
    } on BluetoothPrinterException catch (error) {
      return (succeeded: false, error: error.message);
    } catch (error) {
      final message = error is Exception ? '$error' : null;
      if (message != null && message.isNotEmpty) {
        return (succeeded: false, error: message);
      }
      return (succeeded: false, error: PrinterMessages.printFailed);
    }
  }

  Future<PrinterConnectionResult> _ensurePrinterConnected({
    String? deviceAddress,
  }) async {
    if (_printer.isConnected) {
      return (connected: true, error: null);
    }

    final targetAddress =
        deviceAddress ?? _prefs.getString(PrefKeys.printerDeviceId);
    if (targetAddress == null || targetAddress.isEmpty) {
      return (connected: false, error: PrinterMessages.noPrinterSelected);
    }

    if (!await _printer.isBluetoothEnabled()) {
      return (connected: false, error: PrinterMessages.bluetoothOff);
    }

    final granted = await _printer.requestPermissions();
    if (!granted) {
      return (connected: false, error: PrinterMessages.permissionDenied);
    }

    try {
      await _printer.connect(targetAddress);
      if (_printer.isConnected) {
        return (connected: true, error: null);
      }
      return (connected: false, error: PrinterMessages.connectionFailed);
    } on BluetoothPrinterException catch (error) {
      return (connected: false, error: error.message);
    } catch (error) {
      final message = error is Exception ? '$error' : null;
      if (message != null && message.isNotEmpty) {
        return (connected: false, error: message);
      }
      return (connected: false, error: PrinterMessages.connectionFailed);
    }
  }
}
