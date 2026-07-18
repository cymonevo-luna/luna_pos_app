import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/printer/printer_controller.dart';
import 'package:luna_pos/features/settings/settings_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/harness.dart';

/// POS-91: verify Settings → Printer scan triggers Android 12+ Bluetooth
/// permission flow and completes without a permission-denied error.
///
/// Run on a device with host-side permission orchestration:
///   scripts/run-printer-bluetooth-scan-test.sh
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('printer settings Bluetooth scan on Android', () {
    late IntegrationTestHarness harness;

    setUp(() async {
      harness = await setUpIntegrationHarness();
      if (!locator.isRegistered<BluetoothPrinterService>()) {
        locator.registerSingleton<BluetoothPrinterService>(
          PrintBluetoothThermalService(),
        );
      }
    });

    tearDown(() async {
      harness.container.dispose();
      await locator.reset();
    });

    testWidgets('scan requests permissions and completes on Android 12+',
        (tester) async {
      if (!Platform.isAndroid) {
        return;
      }

      harness
        ..stubLoginForRole(TestAccountRole.cashier)
        ..stubEmptyMenu();

      await harness.pumpApp(tester);
      await harness.loginViaUi(tester, TestAccountRole.cashier);
      await harness.expectAuthenticatedHome(tester);

      harness.readRouter().go(AppRoute.settings.path);
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
      expect(find.byType(SettingsPage), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Scan paired printers'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scan paired printers'));
      await tester.pump(const Duration(milliseconds: 500));

      // Host script grants Bluetooth permissions while the runtime prompt is
      // active. Poll until scanning finishes or times out.
      final deadline = DateTime.now().add(const Duration(seconds: 45));
      while (DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 500));
        final state = harness.container.read(printerProvider);
        if (!state.isScanning) break;
      }

      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );

      expect(find.text(PrinterMessages.permissionDenied), findsNothing);

      final printerState = harness.container.read(printerProvider);
      expect(printerState.isScanning, isFalse);
      expect(printerState.lastError, isNot(PrinterMessages.permissionDenied));
    });
  });
}
