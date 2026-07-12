import 'dart:async';

import 'package:luna_pos/core/printer/bluetooth_printer_device.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';

class MockBluetoothPrinterService implements BluetoothPrinterService {
  MockBluetoothPrinterService({
    this.bluetoothEnabled = true,
    this.permissionGranted = true,
    this.connectSucceeds = true,
    this.printSucceeds = true,
    List<BluetoothPrinterDevice>? devices,
  }) : _devices = devices ?? const [];

  final bool bluetoothEnabled;
  final bool permissionGranted;
  final bool connectSucceeds;
  final bool printSucceeds;
  List<BluetoothPrinterDevice> _devices;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  bool _isConnected = false;
  String? connectedAddress;
  List<int>? lastPrintedBytes;
  int permissionRequestCount = 0;
  int connectCallCount = 0;

  void setDevices(List<BluetoothPrinterDevice> devices) {
    _devices = devices;
  }

  @override
  Stream<bool> get connectionStatus => _connectionController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<bool> requestPermissions() async {
    permissionRequestCount++;
    return permissionGranted;
  }

  @override
  Future<bool> isBluetoothEnabled() async => bluetoothEnabled;

  @override
  Future<bool> isPermissionGranted() async => permissionGranted;

  @override
  Future<List<BluetoothPrinterDevice>> scanPairedDevices() =>
      getAvailableDevices();

  @override
  Future<List<BluetoothPrinterDevice>> getAvailableDevices() async =>
      List<BluetoothPrinterDevice>.from(_devices);

  @override
  Future<void> connect(String deviceAddress) async {
    connectCallCount++;
    if (!connectSucceeds) {
      throw BluetoothPrinterException('Could not connect to the printer.');
    }
    connectedAddress = deviceAddress;
    _isConnected = true;
    _connectionController.add(true);
  }

  @override
  Future<void> disconnect() async {
    connectedAddress = null;
    _isConnected = false;
    _connectionController.add(false);
  }

  @override
  Future<void> printBytes(List<int> data) async {
    if (!_isConnected) {
      throw BluetoothPrinterException('Printer is not connected.');
    }
    if (!printSucceeds || data.isEmpty) {
      throw BluetoothPrinterException('Print failed.');
    }
    lastPrintedBytes = List<int>.from(data);
  }

  @override
  void dispose() {
    _connectionController.close();
  }
}
