import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/checkout_controller.dart';
import 'package:luna_pos/features/order/models/payment_method.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';
import 'package:luna_pos/features/order_option/data/order_option_repository.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';
import 'helpers/order_option_test_data.dart';

class _FakeAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
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

    final secure = FakeSecureStorage();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<OrderOptionRepository>(
        () => OrderOptionRepository(locator<ApiClient>()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer)
      ..registerLazySingleton<ReceiptPrintService>(ReceiptPrintService.new);

    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
  }

  void registerOrderOptionsMock() {
    adapter.onGet(
      '/api/v1/pos/order-options',
      (server) => server.reply(200, kTestOrderOptionsResponse),
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
          'address': 'Jl. Sudirman No. 10',
          'phone': '021-1234567',
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
      registerOrderOptionsMock();
      registerStoreSettingsMock();
      adapter.onPost(
        '/api/v1/pos/transactions',
        (server) => server.reply(201, {
          'success': true,
          'data': {
            'id': 'tx-e2e-1',
            'method': 'CASH',
            'subtotal_amount': 78000,
            'discount_amount': 5000,
            'amount': 73000,
            'cash_tendered': 100000,
            'change_amount': 27000,
          },
        }),
        data: {
          ...kTestOrderOptionIdBodyField,
          'method': 'CASH',
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

    test('add item, checkout, proceed with print persists transaction via POST 201',
        () async {
      seedTwoLineCart();
      await printer.connect('00:11:22:33:44:55');

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 5000,
            paymentMethod: PaymentMethod.cash,
            cashTendered: 100000,
            printReceipt: true,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-e2e-1');
      expect(result.changeAmount, 27000);
      expect(result.printSucceeded, isTrue);
      expect(container.read(orderProvider).lines, isEmpty);
      expect(printer.lastPrintedBytes, isNotEmpty);
    });

    test(
        'retryPrint recovers after transient print failure while sale completes',
        () async {
      printer.dispose();
      printer = MockBluetoothPrinterService(remainingPrintFailures: 1);
      locator.unregister<BluetoothPrinterService>();
      locator.registerSingleton<BluetoothPrinterService>(printer);

      final prefs = locator<PreferencesService>();
      await prefs.setString(PrefKeys.printerDeviceId, '00:11:22:33:44:55');
      await printer.connect('00:11:22:33:44:55');

      seedTwoLineCart();

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 5000,
            paymentMethod: PaymentMethod.cash,
            cashTendered: 100000,
            printReceipt: true,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-e2e-1');
      expect(result.printSucceeded, isFalse);
      expect(result.printError, isNotNull);
      expect(container.read(orderProvider).lines, isEmpty);
      expect(container.read(checkoutProvider).lastReceiptBytes, isNotNull);

      final retryResult =
          await container.read(checkoutProvider.notifier).retryPrint();

      expect(retryResult.succeeded, isTrue);
      expect(retryResult.error, isNull);
      expect(printer.lastPrintedBytes, isNotEmpty);
    });

    test('proceed without print skips printer and clears cart', () async {
      seedTwoLineCart();

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 5000,
            paymentMethod: PaymentMethod.cash,
            cashTendered: 100000,
            printReceipt: false,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-e2e-1');
      expect(result.changeAmount, 27000);
      expect(result.printSucceeded, isFalse);
      expect(result.printError, isNull);
      expect(container.read(orderProvider).lines, isEmpty);
      expect(printer.lastPrintedBytes, isNull);
    });

    test('transaction appears in POS history after proceed', () async {
      seedTwoLineCart();

      adapter.onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [
            {
              'id': 'tx-e2e-1',
              'method': 'OFFLINE',
              'amount': 73000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
          'meta': {'page': 1, 'per_page': 20, 'total': 1},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      );

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 5000,
            paymentMethod: PaymentMethod.cash,
            cashTendered: 100000,
            printReceipt: false,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-e2e-1');

      final history =
          await locator<TransactionRepository>().fetchTransactions();

      expect(history.items, hasLength(1));
      expect(history.items.first.id, 'tx-e2e-1');
      expect(history.items.first.amount, 73000);
    });
  });

  group('successful qris checkout API flow', () {
    setUp(() async {
      await setUpHarness();
      registerOrderOptionsMock();
      registerStoreSettingsMock();
      adapter.onPost(
        '/api/v1/pos/transactions',
        (server) => server.reply(201, {
          'success': true,
          'data': {
            'id': 'tx-qris-1',
            'method': 'QRIS',
            'subtotal_amount': 78000,
            'discount_amount': 0,
            'amount': 78000,
          },
        }),
        data: {
          ...kTestOrderOptionIdBodyField,
          'method': 'QRIS',
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
        },
      );
    });

    tearDown(() {
      container.dispose();
      printer.dispose();
    });

    test('qris checkout persists transaction without cash fields', () async {
      seedTwoLineCart();
      await printer.connect('00:11:22:33:44:55');

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 0,
            paymentMethod: PaymentMethod.qris,
            printReceipt: false,
          );

      expect(result, isNotNull);
      expect(result!.transactionId, 'tx-qris-1');
      expect(result.paymentMethod, PaymentMethod.qris);
      expect(result.changeAmount, 0);
      expect(container.read(orderProvider).lines, isEmpty);
    });
  });

  group('failed transaction POST', () {
    setUp(() async {
      await setUpHarness();
      registerOrderOptionsMock();
      registerStoreSettingsMock();
      adapter.onPost(
        '/api/v1/pos/transactions',
        (server) => server.reply(500, {
          'success': false,
          'error': {'message': 'server error'},
        }),
        data: {
          ...kTestOrderOptionIdBodyField,
          'method': 'CASH',
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

      final result = await container.read(checkoutProvider.notifier).proceed(
            orderOptionId: kTestOrderOptionId,
            discountAmount: 0,
            paymentMethod: PaymentMethod.cash,
            cashTendered: 80000,
            printReceipt: true,
          );

      expect(result, isNull);
      expect(container.read(orderProvider).lines, isNotEmpty);
      expect(printer.lastPrintedBytes, isNull);
      expect(container.read(checkoutProvider).error, 'server error');
    });
  });
}
