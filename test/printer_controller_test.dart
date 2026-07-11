import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_device.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/printer/printer_controller.dart';

import 'helpers/mock_bluetooth_printer_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBluetoothPrinterService mockPrinter;
  late ProviderContainer container;

  const savedPrinter = BluetoothPrinterDevice(
    address: 'AA:BB:CC:DD:EE:FF',
    name: 'RP80 Printer',
  );

  const otherPrinter = BluetoothPrinterDevice(
    address: '11:22:33:44:55:66',
    name: 'Headphones',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      PrefKeys.printerDeviceId: savedPrinter.address,
      PrefKeys.printerDeviceName: savedPrinter.name,
    });
    await locator.reset();
    locator.registerSingleton<PreferencesService>(
      await PreferencesService.create(),
    );

    mockPrinter = MockBluetoothPrinterService(
      devices: const [savedPrinter, otherPrinter],
    );

    container = ProviderContainer(
      overrides: [
        bluetoothPrinterServiceProvider.overrideWithValue(mockPrinter),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    mockPrinter.dispose();
  });

  test('refreshDevices requests Bluetooth permissions before scanning', () async {
    await container.read(printerProvider.notifier).refreshDevices();

    expect(mockPrinter.permissionRequestCount, greaterThan(0));
    expect(container.read(printerProvider).availableDevices, hasLength(2));
  });

  test('initialize auto-connects when saved printer is paired', () async {
    await container.read(printerProvider.notifier).initialize();

    final state = container.read(printerProvider);
    expect(state.selectedDevice, savedPrinter);
    expect(state.isConnected, isTrue);
    expect(mockPrinter.connectCallCount, 1);
    expect(mockPrinter.connectedAddress, savedPrinter.address);
  });

  test('selectDevice persists printer selection to preferences', () async {
    await container.read(printerProvider.notifier).refreshDevices();

    await container
        .read(printerProvider.notifier)
        .selectDevice(otherPrinter);

    final prefs = locator<PreferencesService>();
    expect(prefs.getString(PrefKeys.printerDeviceId), otherPrinter.address);
    expect(prefs.getString(PrefKeys.printerDeviceName), otherPrinter.name);
    expect(container.read(printerProvider).selectedDevice, otherPrinter);
  });

  test('testPrint sends non-empty bytes through the printer service', () async {
    await container.read(printerProvider.notifier).initialize();

    await container.read(printerProvider.notifier).testPrint();

    final state = container.read(printerProvider);
    expect(state.lastError, isNull, reason: state.lastError);
    expect(mockPrinter.lastPrintedBytes, isNotNull);
    expect(mockPrinter.lastPrintedBytes, isNotEmpty);
    expect(state.isPrinting, isFalse);
  });
}
