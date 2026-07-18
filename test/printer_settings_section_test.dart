import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/printer/printer_controller.dart';
import 'package:luna_pos/features/printer/printer_settings_section.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

void main() {
  late MockBluetoothPrinterService mockPrinter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await locator.reset();
    mockPrinter = MockBluetoothPrinterService();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(FakeSecureStorage())
      ..registerSingleton<ApiClient>(ApiClient(baseUrl: 'https://api.test'))
      ..registerSingleton<BluetoothPrinterService>(mockPrinter);
  });

  tearDown(() {
    mockPrinter.dispose();
  });

  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bluetoothPrinterServiceProvider.overrideWithValue(mockPrinter),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: PrinterSettingsSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('scan button requests Bluetooth permissions before scanning',
      (WidgetTester tester) async {
    await pumpSection(tester);

    final requestsBeforeTap = mockPrinter.permissionRequestCount;
    expect(requestsBeforeTap, greaterThan(0),
        reason: 'initialize() should request permissions on first load');

    await tester.tap(find.text('Scan paired printers'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(mockPrinter.permissionRequestCount, greaterThan(requestsBeforeTap));
    expect(find.text('Bluetooth permission was denied.'), findsNothing);
  });

  testWidgets('scan shows permission denied when user rejects access',
      (WidgetTester tester) async {
    mockPrinter = MockBluetoothPrinterService(permissionGranted: false);
    locator.unregister<BluetoothPrinterService>();
    locator.registerSingleton<BluetoothPrinterService>(mockPrinter);

    await pumpSection(tester);

    await tester.tap(find.text('Scan paired printers'));
    await tester.pumpAndSettle();

    expect(mockPrinter.permissionRequestCount, greaterThan(0));
    expect(find.text('Bluetooth permission was denied.'), findsOneWidget);
  });
}
