import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'bluetooth_printer_device.dart';

/// Thrown when Bluetooth is unavailable or the user denied required access.
class BluetoothPrinterException implements Exception {
  BluetoothPrinterException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Contract for Bluetooth thermal printer operations. Override in tests.
abstract class BluetoothPrinterService {
  Stream<bool> get connectionStatus;

  bool get isConnected;

  Future<bool> requestPermissions();

  Future<bool> isBluetoothEnabled();

  Future<bool> isPermissionGranted();

  Future<List<BluetoothPrinterDevice>> scanPairedDevices();

  Future<List<BluetoothPrinterDevice>> getAvailableDevices();

  Future<void> connect(String deviceAddress);

  Future<void> disconnect();

  Future<void> printBytes(List<int> data);

  void dispose();
}

/// Production implementation backed by [PrintBluetoothThermal].
class PrintBluetoothThermalService implements BluetoothPrinterService {
  PrintBluetoothThermalService() {
    _connectionController = StreamController<bool>.broadcast(
      onListen: () => _connectionController.add(_isConnected),
    );
  }

  late final StreamController<bool> _connectionController;
  bool _isConnected = false;

  @override
  Stream<bool> get connectionStatus => _connectionController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    if (!Platform.isAndroid) {
      return PrintBluetoothThermal.isPermissionBluetoothGranted;
    }

    final permissions = <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ];

    final statuses = await permissions.request();
    final granted = statuses.values.every((status) => status.isGranted);
    if (!granted) {
      return PrintBluetoothThermal.isPermissionBluetoothGranted;
    }
    return true;
  }

  @override
  Future<bool> isPermissionGranted() async {
    if (kIsWeb) return false;
    if (Platform.isAndroid) {
      final scan = await Permission.bluetoothScan.status;
      final connect = await Permission.bluetoothConnect.status;
      if (scan.isGranted && connect.isGranted) return true;
    }
    return PrintBluetoothThermal.isPermissionBluetoothGranted;
  }

  @override
  Future<bool> isBluetoothEnabled() =>
      PrintBluetoothThermal.bluetoothEnabled;

  @override
  Future<List<BluetoothPrinterDevice>> scanPairedDevices() =>
      getAvailableDevices();

  @override
  Future<List<BluetoothPrinterDevice>> getAvailableDevices() async {
    final paired = await PrintBluetoothThermal.pairedBluetooths;
    return paired
        .map(
          (info) => BluetoothPrinterDevice(
            address: info.macAdress,
            name: info.name,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> connect(String deviceAddress) async {
    final connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: deviceAddress,
    );
    await _setConnected(connected);
    if (!connected) {
      throw BluetoothPrinterException('Could not connect to the printer.');
    }
  }

  @override
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    await _setConnected(false);
  }

  @override
  Future<void> printBytes(List<int> data) async {
    if (data.isEmpty) {
      throw BluetoothPrinterException('Nothing to print.');
    }

    final connected = await PrintBluetoothThermal.connectionStatus;
    await _setConnected(connected);
    if (!connected) {
      throw BluetoothPrinterException('Printer is not connected.');
    }

    final success = await PrintBluetoothThermal.writeBytes(data);
    if (!success) {
      throw BluetoothPrinterException('Print failed.');
    }
  }

  @override
  void dispose() {
    _connectionController.close();
  }

  Future<void> _setConnected(bool connected) async {
    _isConnected = connected;
    if (!_connectionController.isClosed) {
      _connectionController.add(connected);
    }
  }
}

/// Returns the first paired device that matches common thermal printer names.
BluetoothPrinterDevice? findLikelyThermalPrinter(
  List<BluetoothPrinterDevice> devices,
) {
  for (final device in devices) {
    if (device.isLikelyThermalPrinter) return device;
  }
  return null;
}
