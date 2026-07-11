import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/printer/bluetooth_printer_device.dart';
import '../../core/printer/bluetooth_printer_service.dart';
import '../../core/printer/test_receipt_builder.dart';
import '../../core/storage/preferences_service.dart';

class PrinterState {
  const PrinterState({
    this.availableDevices = const [],
    this.selectedDevice,
    this.isConnected = false,
    this.bluetoothEnabled = false,
    this.isScanning = false,
    this.isPrinting = false,
    this.isConnecting = false,
    this.lastError,
  });

  final List<BluetoothPrinterDevice> availableDevices;
  final BluetoothPrinterDevice? selectedDevice;
  final bool isConnected;
  final bool bluetoothEnabled;
  final bool isScanning;
  final bool isPrinting;
  final bool isConnecting;
  final String? lastError;

  PrinterState copyWith({
    List<BluetoothPrinterDevice>? availableDevices,
    BluetoothPrinterDevice? selectedDevice,
    bool clearSelectedDevice = false,
    bool? isConnected,
    bool? bluetoothEnabled,
    bool? isScanning,
    bool? isPrinting,
    bool? isConnecting,
    String? lastError,
    bool clearError = false,
  }) {
    return PrinterState(
      availableDevices: availableDevices ?? this.availableDevices,
      selectedDevice: clearSelectedDevice
          ? null
          : (selectedDevice ?? this.selectedDevice),
      isConnected: isConnected ?? this.isConnected,
      bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
      isScanning: isScanning ?? this.isScanning,
      isPrinting: isPrinting ?? this.isPrinting,
      isConnecting: isConnecting ?? this.isConnecting,
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}

final bluetoothPrinterServiceProvider = Provider<BluetoothPrinterService>(
  (ref) => locator<BluetoothPrinterService>(),
);

class PrinterController extends Notifier<PrinterState> {
  BluetoothPrinterService get _printer => ref.read(bluetoothPrinterServiceProvider);
  PreferencesService get _prefs => locator<PreferencesService>();

  StreamSubscription<bool>? _connectionSubscription;

  @override
  PrinterState build() {
    ref.onDispose(() {
      _connectionSubscription?.cancel();
    });

    _connectionSubscription ??=
        _printer.connectionStatus.listen((connected) {
      state = state.copyWith(isConnected: connected, clearError: true);
    });

    return PrinterState(
      selectedDevice: _loadSavedDevice(),
      isConnected: _printer.isConnected,
    );
  }

  /// Loads saved printer preferences and attempts auto-connect when opened.
  Future<void> initialize() async {
    await _refreshBluetoothStatus();
    await refreshDevices(attemptAutoConnect: true);
  }

  Future<void> refreshDevices({bool attemptAutoConnect = false}) async {
    state = state.copyWith(isScanning: true, clearError: true);

    try {
      await _refreshBluetoothStatus();
      if (!state.bluetoothEnabled) {
        state = state.copyWith(
          isScanning: false,
          lastError: PrinterMessages.bluetoothOff,
        );
        return;
      }

      final granted = await _printer.requestPermissions();
      if (!granted) {
        state = state.copyWith(
          isScanning: false,
          lastError: PrinterMessages.permissionDenied,
        );
        return;
      }

      final devices = await _printer.getAvailableDevices();
      var selected = state.selectedDevice ?? _loadSavedDevice();
      final savedId = _prefs.getString(PrefKeys.printerDeviceId);

      if (savedId != null) {
        final savedMatch = _findSavedDevice(devices, savedId);
        if (savedMatch != null) {
          selected = savedMatch;
        } else if (selected?.address == savedId) {
          selected = null;
        }
      }

      if (selected == null && attemptAutoConnect) {
        selected = findLikelyThermalPrinter(devices);
      }

      state = state.copyWith(
        availableDevices: devices,
        selectedDevice: selected,
        isScanning: false,
        clearError: true,
      );

      if (attemptAutoConnect && selected != null) {
        await _connectToDevice(selected, persistSelection: false);
      }
    } on BluetoothPrinterException catch (error) {
      state = state.copyWith(
        isScanning: false,
        lastError: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        isScanning: false,
        lastError: PrinterMessages.scanFailed,
      );
    }
  }

  Future<void> selectDevice(BluetoothPrinterDevice device) async {
    state = state.copyWith(selectedDevice: device, clearError: true);
    await _persistSelection(device);
    await _connectToDevice(device, persistSelection: false);
  }

  Future<void> testPrint() async {
    if (state.isPrinting) return;

    state = state.copyWith(isPrinting: true, clearError: true);
    try {
      if (!state.isConnected) {
        final device = state.selectedDevice;
        if (device == null) {
          throw BluetoothPrinterException(PrinterMessages.noPrinterSelected);
        }
        await _connectToDevice(device);
      }

      final bytes = await buildTestReceiptBytes();
      await _printer.printBytes(bytes);
      state = state.copyWith(isPrinting: false, clearError: true);
    } on BluetoothPrinterException catch (error) {
      state = state.copyWith(
        isPrinting: false,
        lastError: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        isPrinting: false,
        lastError: PrinterMessages.printFailed,
      );
    }
  }

  Future<void> disconnect() async {
    await _printer.disconnect();
    state = state.copyWith(isConnected: false, clearError: true);
  }

  BluetoothPrinterDevice? _loadSavedDevice() {
    final id = _prefs.getString(PrefKeys.printerDeviceId);
    final name = _prefs.getString(PrefKeys.printerDeviceName);
    if (id == null || name == null) return null;
    return BluetoothPrinterDevice(address: id, name: name);
  }

  BluetoothPrinterDevice? _findSavedDevice(
    List<BluetoothPrinterDevice> devices,
    String savedId,
  ) {
    for (final device in devices) {
      if (device.address == savedId) return device;
    }
    return null;
  }

  Future<void> _persistSelection(BluetoothPrinterDevice device) async {
    await _prefs.setString(PrefKeys.printerDeviceId, device.address);
    await _prefs.setString(PrefKeys.printerDeviceName, device.name);
  }

  Future<void> _refreshBluetoothStatus() async {
    final enabled = await _printer.isBluetoothEnabled();
    state = state.copyWith(bluetoothEnabled: enabled);
  }

  Future<void> _connectToDevice(
    BluetoothPrinterDevice device, {
    bool persistSelection = true,
  }) async {
    state = state.copyWith(isConnecting: true, clearError: true);
    try {
      if (!state.bluetoothEnabled) {
        throw BluetoothPrinterException(PrinterMessages.bluetoothOff);
      }

      final granted = await _printer.requestPermissions();
      if (!granted) {
        throw BluetoothPrinterException(PrinterMessages.permissionDenied);
      }

      if (persistSelection) {
        await _persistSelection(device);
      }

      await _printer.connect(device.address);
      state = state.copyWith(
        selectedDevice: device,
        isConnected: true,
        isConnecting: false,
        clearError: true,
      );
    } on BluetoothPrinterException catch (error) {
      state = state.copyWith(
        isConnected: false,
        isConnecting: false,
        lastError: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        isConnected: false,
        isConnecting: false,
        lastError: PrinterMessages.connectionFailed,
      );
    }
  }
}

abstract final class PrinterMessages {
  static const bluetoothOff = 'Bluetooth is turned off.';
  static const permissionDenied = 'Bluetooth permission was denied.';
  static const noPairedDevices =
      'No paired printers found. Pair your printer in Android settings first.';
  static const connectionFailed = 'Could not connect to the printer.';
  static const printFailed = 'Print failed.';
  static const scanFailed = 'Could not load paired Bluetooth devices.';
  static const noPrinterSelected = 'Select a printer first.';
}

final printerProvider =
    NotifierProvider<PrinterController, PrinterState>(PrinterController.new);
