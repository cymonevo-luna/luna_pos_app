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
import 'package:luna_pos/features/settings/settings_page.dart';
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

  testWidgets('settings page shows printer section with scan and placeholder',
      (WidgetTester tester) async {
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
          home: SettingsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Scan paired printers'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Scan paired printers'), findsOneWidget);
    expect(
      find.text(
        'No paired printers found. Pair a printer in Android Bluetooth settings, then scan again.',
      ),
      findsOneWidget,
    );
  });
}
