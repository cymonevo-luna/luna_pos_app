import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  Future<void> printBytes(List<int> data, {String? deviceAddress});

  void dispose();
}

/// Production implementation backed by [PrintBluetoothThermal].
class PrintBluetoothThermalService implements BluetoothPrinterService {
  PrintBluetoothThermalService() {
    _connectionController = StreamController<bool>.broadcast(
      onListen: () => _connectionController.add(_isConnected),
    );
  }

  static const int _writeChunkSize = 512;

  late final StreamController<bool> _connectionController;
  bool _isConnected = false;
  String? _lastConnectedAddress;

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
    try {
      final connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: deviceAddress,
      );
      await _setConnected(connected);
      if (connected) {
        _lastConnectedAddress = deviceAddress;
      }
      if (!connected) {
        throw BluetoothPrinterException('Could not connect to the printer.');
      }
    } on BluetoothPrinterException {
      rethrow;
    } on PlatformException catch (error) {
      final message = error.message?.trim();
      throw BluetoothPrinterException(
        message != null && message.isNotEmpty
            ? message
            : 'Could not connect to the printer.',
      );
    } catch (error) {
      throw BluetoothPrinterException(
        error is Exception && '$error'.isNotEmpty
            ? '$error'
            : 'Could not connect to the printer.',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    await _setConnected(false);
  }

  @override
  Future<void> printBytes(List<int> data, {String? deviceAddress}) async {
    if (data.isEmpty) {
      throw BluetoothPrinterException('Nothing to print.');
    }

    await _ensureConnectedForPrint(deviceAddress: deviceAddress);
    await _writeBytesChunked(data);
  }

  Future<void> _ensureConnectedForPrint({String? deviceAddress}) async {
    var connected = await PrintBluetoothThermal.connectionStatus;
    await _setConnected(connected);

    final reconnectAddress = _lastConnectedAddress ?? deviceAddress;
    if (!connected && reconnectAddress != null) {
      await connect(reconnectAddress);
      connected = await PrintBluetoothThermal.connectionStatus;
      await _setConnected(connected);
    }

    if (!connected) {
      throw BluetoothPrinterException('Printer is not connected.');
    }
  }

  Future<void> _writeBytesChunked(List<int> data) async {
    if (data.length <= _writeChunkSize) {
      await _writeSingleChunk(data);
      return;
    }

    for (var offset = 0; offset < data.length; offset += _writeChunkSize) {
      final end = offset + _writeChunkSize;
      final chunk = data.sublist(
        offset,
        end > data.length ? data.length : end,
      );
      await _writeSingleChunk(chunk);
    }
  }

  Future<void> _writeSingleChunk(List<int> chunk) async {
    bool success;
    try {
      success = await PrintBluetoothThermal.writeBytes(chunk);
    } on PlatformException catch (error) {
      final message = error.message?.trim();
      throw BluetoothPrinterException(
        message != null && message.isNotEmpty
            ? message
            : 'Print data was rejected by the printer.',
      );
    } catch (error) {
      if (error is BluetoothPrinterException) rethrow;
      throw BluetoothPrinterException(
        error is Exception && '$error'.isNotEmpty
            ? '$error'
            : 'Print data was rejected by the printer.',
      );
    }

    if (success) return;

    final stillConnected = await PrintBluetoothThermal.connectionStatus;
    await _setConnected(stillConnected);
    if (!stillConnected) {
      throw BluetoothPrinterException('Printer is not connected.');
    }
    throw BluetoothPrinterException('Print data was rejected by the printer.');
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
