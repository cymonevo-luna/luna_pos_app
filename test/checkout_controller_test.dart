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
import 'package:luna_pos/features/order/models/payment_method.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';
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

class _RecordingTransactionRepository extends TransactionRepository {
  _RecordingTransactionRepository(super.api);

  CreateTransactionRequest? lastRequest;

  @override
  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  ) async {
    lastRequest = request;
    return TransactionResponse(
      id: 'tx-1',
      method: request.method,
      amount: request.amount,
      subtotalAmount: request.subtotalAmount,
      discountAmount: request.discountAmount,
      cashTendered: request.cashTendered,
      changeAmount: request.changeAmount,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late DioAdapter adapter;
  late MockBluetoothPrinterService printer;
  late _RecordingTransactionRepository transactionRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    printer = MockBluetoothPrinterService();
    transactionRepository = _RecordingTransactionRepository(mocked.client);

    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(FakeSecureStorage())
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerSingleton<TransactionRepository>(transactionRepository)
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer);

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

    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    printer.dispose();
  });

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

  test('confirmAndPrint submits correct cash transaction payload', () async {
    seedTwoLineCart();

    final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: 5000,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 100000,
        );

    expect(result, isNotNull);
    final request = transactionRepository.lastRequest!;
    expect(request.method, 'CASH');
    expect(request.subtotalAmount, 78000);
    expect(request.discountAmount, 5000);
    expect(request.amount, 73000);
    expect(request.cashTendered, 100000);
    expect(request.changeAmount, 27000);
    expect(request.items, hasLength(2));
    expect(request.items[0].note, 'less ice');
    expect(request.items[0].lineTotal, 8000);
    expect(request.items[1].lineTotal, 70000);
  });

  test('confirmAndPrint submits correct qris transaction payload', () async {
    seedTwoLineCart();

    final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: 0,
          paymentMethod: PaymentMethod.qris,
        );

    expect(result, isNotNull);
    final request = transactionRepository.lastRequest!;
    expect(request.method, 'QRIS');
    expect(request.cashTendered, isNull);
    expect(request.changeAmount, isNull);
  });

  test('confirmAndPrint calls printBytes and clears cart on success', () async {
    seedTwoLineCart();
    await printer.connect('00:11:22:33:44:55');

    await container.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: 0,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 80000,
        );

    expect(printer.lastPrintedBytes, isNotNull);
    expect(printer.lastPrintedBytes, isNotEmpty);
    expect(container.read(orderProvider).lines, isEmpty);
  });

  test('confirmAndPrint completes sale when printer unavailable', () async {
    seedTwoLineCart();

    final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: 0,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 80000,
        );

    expect(result, isNotNull);
    expect(result!.printSucceeded, isFalse);
    expect(result.printError, isNotNull);
    expect(printer.lastPrintedBytes, isNull);
    expect(container.read(orderProvider).lines, isEmpty);
    expect(
      container.read(checkoutProvider).lastReceiptBytes,
      isNotNull,
    );
  });

  test('confirmAndPrint does not POST when store settings fail', () async {
    seedTwoLineCart();
    adapter.reset();
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(500, {
        'success': false,
        'error': {'message': 'settings unavailable'},
      }),
    );

    final result = await container.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: 0,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 80000,
        );

    expect(result, isNull);
    expect(transactionRepository.lastRequest, isNull);
    expect(container.read(orderProvider).lines, isNotEmpty);
    expect(container.read(checkoutProvider).error, 'Server error.');
  });
}
