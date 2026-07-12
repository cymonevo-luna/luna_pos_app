import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/checkout_controller.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/user/models/user.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

class _FakeAuthController extends AuthController {
  @override
  AuthState build() => const AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: 'u1',
          name: 'Alex',
          email: 'a@b.com',
          merchantId: 'merchant-1',
          roles: ['cashier'],
        ),
      );
}

/// Exercises the full checkout path through real repositories and a mocked HTTP
/// backend (store settings GET + transaction POST 201), substituting for the
/// manual E2E smoke when luna_pos_service is unavailable in CI.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late DioAdapter adapter;
  late MockBluetoothPrinterService printer;

  Future<void> setUpHarness() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    printer = MockBluetoothPrinterService();

    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(FakeSecureStorage())
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer);

    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
  }

  void registerStoreSettingsMock() {
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'brand_name': 'Luna Cafe',
          'branch_name': 'Cabang Sudirman',
          'branch_address': 'Jl. Sudirman No. 10',
          'branch_phone': '021-1234567',
          'thank_you_note': 'Terima kasih!',
        },
      }),
    );
  }

  void seedTwoLineCart() {
    final notifier = container.read(orderProvider.notifier);
    notifier.addLine(
      const POSMenuItem(
        id: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        availableStock: 10,
      ),
      quantity: 1,
      note: 'less ice',
    );
    notifier.addLine(
      const POSMenuItem(
        id: 'm2',
        title: 'Nasi Goreng',
        sellPrice: 35000,
        availableStock: 10,
      ),
      quantity: 2,
    );
  }

  group('successful checkout API flow', () {
    setUp(() async {
      await setUpHarness();
      registerStoreSettingsMock();
      adapter.onPost(
        '/api/v1/pos/transactions',
        (server) => server.reply(201, {
          'success': true,
          'data': {
            'id': 'tx-e2e-1',
            'method': 'OFFLINE',
            'subtotal_amount': 78000,
            'discount_amount': 5000,
            'amount': 73000,
            'cash_tendered': 100000,
            'change_amount': 27000,
          },
        }),
        data: {
          'method': 'OFFLINE',
          'items': [
            {
              'menu_id': 'm1',
              'title': 'Es Teh',
              'quantity': 1,
              'unit_price': 8000,
              'line_total': 8000,
              'note': 'less ice',
            },
            {
              'menu_id': 'm2',
              'title': 'Nasi Goreng',
              'quantity': 2,
              'unit_price': 35000,
              'line_total': 70000,
            },
          ],
          'subtotal_amount': 78000,
          'discount_amount': 5000,
          'amount': 73000,
          'cash_tendered': 100000,
          'change_amount': 27000,
        },
      );
    });

    tearDown(() {
      container.dispose();
      printer.dispose();
    });

    test('add item, checkout, confirm persists transaction via POST 201', () async {
      seedTwoLineCart();
      await printer.connect('00:11:22:33:44:55');

      final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
            discountAmount: 5000,
            cashTendered: 100000,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-e2e-1');
      expect(result.changeAmount, 27000);
      expect(result.printSucceeded, isTrue);
      expect(container.read(orderProvider).lines, isEmpty);
      expect(printer.lastPrintedBytes, isNotEmpty);
    });
  });

  group('failed transaction POST', () {
    setUp(() async {
      await setUpHarness();
      registerStoreSettingsMock();
      adapter.onPost(
        '/api/v1/pos/transactions',
        (server) => server.reply(500, {
          'success': false,
          'error': {'message': 'server error'},
        }),
        data: {
          'method': 'OFFLINE',
          'items': [
            {
              'menu_id': 'm1',
              'title': 'Es Teh',
              'quantity': 1,
              'unit_price': 8000,
              'line_total': 8000,
              'note': 'less ice',
            },
            {
              'menu_id': 'm2',
              'title': 'Nasi Goreng',
              'quantity': 2,
              'unit_price': 35000,
              'line_total': 70000,
            },
          ],
          'subtotal_amount': 78000,
          'discount_amount': 0,
          'amount': 78000,
          'cash_tendered': 80000,
          'change_amount': 2000,
        },
      );
    });

    tearDown(() {
      container.dispose();
      printer.dispose();
    });

    test('checkout does not print when transaction POST fails', () async {
      seedTwoLineCart();
      await printer.connect('00:11:22:33:44:55');

      final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
            discountAmount: 0,
            cashTendered: 80000,
          );

      expect(result, isNull);
      expect(container.read(orderProvider).lines, isNotEmpty);
      expect(printer.lastPrintedBytes, isNull);
      expect(container.read(checkoutProvider).error, 'Server error.');
    });
  });
}
