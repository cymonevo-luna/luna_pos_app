import 'dart:async';

import 'package:luna_pos/core/printer/bluetooth_printer_device.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';

class MockBluetoothPrinterService implements BluetoothPrinterService {
  MockBluetoothPrinterService({
    this.bluetoothEnabled = true,
    this.permissionGranted = true,
    this.connectSucceeds = true,
    this.printSucceeds = true,
    this.remainingPrintFailures = 0,
    List<BluetoothPrinterDevice>? devices,
  }) : _devices = devices ?? const [];

  final bool bluetoothEnabled;
  final bool permissionGranted;
  final bool connectSucceeds;
  final bool printSucceeds;
  int remainingPrintFailures;
  List<BluetoothPrinterDevice> _devices;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  bool _isConnected = false;
  bool _linkConnected = false;
  bool _staleConnection = false;
  String? connectedAddress;
  String? _lastConnectedAddress;
  List<int>? lastPrintedBytes;
  int permissionRequestCount = 0;
  int connectCallCount = 0;
  int printCallCount = 0;
  int reconnectBeforePrintCount = 0;

  void setDevices(List<BluetoothPrinterDevice> devices) {
    _devices = devices;
  }

  void simulateConnectionDrop({bool notifyListeners = true}) {
    _linkConnected = false;
    _isConnected = false;
    _staleConnection = false;
    connectedAddress = null;
    if (notifyListeners) {
      _connectionController.add(false);
    }
  }

  /// Simulates a stale UI/service flag: [isConnected] stays true while the
  /// underlying link is down (no stream notification).
  void simulateStaleConnectionDrop() {
    _staleConnection = true;
    _linkConnected = false;
    connectedAddress = null;
  }

  @override
  Stream<bool> get connectionStatus => _connectionController.stream;

  @override
  bool get isConnected => _staleConnection ? true : _isConnected;

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
    final isReconnect = !_linkConnected && _lastConnectedAddress != null;
    if (!connectSucceeds) {
      throw BluetoothPrinterException('Could not connect to the printer.');
    }
    if (isReconnect) {
      reconnectBeforePrintCount++;
    }
    connectedAddress = deviceAddress;
    _lastConnectedAddress = deviceAddress;
    _linkConnected = true;
    _isConnected = true;
    _staleConnection = false;
    _connectionController.add(true);
  }

  @override
  Future<void> disconnect() async {
    _lastConnectedAddress = connectedAddress ?? _lastConnectedAddress;
    connectedAddress = null;
    _linkConnected = false;
    _isConnected = false;
    _staleConnection = false;
    _connectionController.add(false);
  }

  @override
  Future<void> printBytes(List<int> data, {String? deviceAddress}) async {
    printCallCount++;

    if (data.isEmpty) {
      throw BluetoothPrinterException('Nothing to print.');
    }

    final reconnectAddress = _lastConnectedAddress ?? deviceAddress;
    if (!_linkConnected && reconnectAddress != null && connectSucceeds) {
      await connect(reconnectAddress);
    }

    if (!_linkConnected) {
      throw BluetoothPrinterException('Printer is not connected.');
    }

    if (remainingPrintFailures > 0) {
      remainingPrintFailures--;
      final stillConnected = _linkConnected;
      if (!stillConnected) {
        throw BluetoothPrinterException('Printer is not connected.');
      }
      throw BluetoothPrinterException('Print data was rejected by the printer.');
    }

    if (!printSucceeds) {
      final stillConnected = _linkConnected;
      if (!stillConnected) {
        throw BluetoothPrinterException('Printer is not connected.');
      }
      throw BluetoothPrinterException('Print data was rejected by the printer.');
    }

    lastPrintedBytes = List<int>.from(data);
  }

  @override
  void dispose() {
    _connectionController.close();
  }
}
