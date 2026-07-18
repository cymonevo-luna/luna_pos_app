import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/api_exception.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/cashier_balance/cashier_balance_controller.dart';
import 'package:luna_pos/features/cashier_balance/data/cashier_balance_repository.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/checkout_controller.dart';
import 'package:luna_pos/features/order/data/order_option_repository.dart';
import 'package:luna_pos/features/order/models/payment_method.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/order/order_options_controller.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

class _RecordingTransactionRepository extends TransactionRepository {
  _RecordingTransactionRepository(super.api);

  @override
  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  ) async {
    return TransactionResponse(
      id: 'tx-cash-1',
      method: request.method,
      amount: request.amount,
      subtotalAmount: request.subtotalAmount,
      discountAmount: request.discountAmount,
      orderOptionId: request.orderOptionId,
      orderOptionName: 'Take Away',
      cashTendered: request.cashTendered,
      changeAmount: request.changeAmount,
    );
  }
}

class _ThrowingTransactionRepository extends TransactionRepository {
  _ThrowingTransactionRepository(
    super.api, {
    required this.exception,
  });

  final ApiException exception;

  @override
  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  ) async {
    throw exception;
  }
}

class _CashierAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: const ['cashier'],
          features: TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late DioAdapter adapter;
  late MockBluetoothPrinterService printer;

  setUp(() async {
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
      ..registerLazySingleton<OrderOptionRepository>(
        () => OrderOptionRepository(locator<ApiClient>()),
      )
      ..registerSingleton<TransactionRepository>(
        _RecordingTransactionRepository(mocked.client),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<CashierBalanceRepository>(
        () => CashierBalanceRepository(locator<ApiClient>()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer)
      ..registerLazySingleton<ReceiptPrintService>(ReceiptPrintService.new);

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
    stubOrderOptions(adapter);

    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_CashierAuthController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    printer.dispose();
  });

  void seedCart() {
    final notifier = container.read(orderProvider.notifier);
    notifier.addLine(
      const POSMenuItem(
        id: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        availableStock: 10,
      ),
      quantity: 1,
    );
  }

  Future<void> prepareOrderOptionSelection() async {
    await container.read(orderOptionsProvider.notifier).loadIfNeeded();
    container
        .read(checkoutProvider.notifier)
        .selectOrderOption(kTestOrderOptionTakeAwayId);
  }

  Future<void> waitForBalanceRefresh() async {
    for (var i = 0; i < 100; i++) {
      final state = container.read(cashierBalanceController);
      if (!state.refreshing && state.balance != null) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('cash checkout refreshes cashier balance from server', () async {
    var balanceFetchCount = 0;
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.replyCallback(200, (_) {
            balanceFetchCount++;
            return {
              'success': true,
              'data': {
                'balance': 173000,
                'updated_at': '2026-07-18T10:00:00Z',
              },
            };
          }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    seedCart();
    await prepareOrderOptionSelection();

    container.read(cashierBalanceController.notifier);
    await waitForBalanceRefresh();
    final balanceFetchesBeforeCheckout = balanceFetchCount;

    final result = await container.read(checkoutProvider.notifier).proceed(
          discountAmount: 0,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 10000,
          printReceipt: false,
        );

    expect(result, isNotNull);
    await waitForBalanceRefresh();

    expect(balanceFetchCount, balanceFetchesBeforeCheckout + 1);
    expect(container.read(cashierBalanceController).balance?.balance, 173000);
  });

  test('qris checkout does not refresh cashier balance', () async {
    var balanceFetchCount = 0;
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.replyCallback(200, (_) {
            balanceFetchCount++;
            return {
              'success': true,
              'data': {
                'balance': 100000,
                'updated_at': '2026-07-18T10:00:00Z',
              },
            };
          }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    seedCart();
    await prepareOrderOptionSelection();

    final result = await container.read(checkoutProvider.notifier).proceed(
          discountAmount: 0,
          paymentMethod: PaymentMethod.qris,
          printReceipt: false,
        );

    expect(result, isNotNull);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(balanceFetchCount, 0);
  });

  test('failed checkout does not refresh cashier balance', () async {
    var balanceFetchCount = 0;
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.replyCallback(200, (_) {
            balanceFetchCount++;
            return {
              'success': true,
              'data': {
                'balance': 100000,
                'updated_at': '2026-07-18T10:00:00Z',
              },
            };
          }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    seedCart();
    await prepareOrderOptionSelection();

    locator.unregister<TransactionRepository>();
    locator.registerSingleton<TransactionRepository>(
      _ThrowingTransactionRepository(
        locator<ApiClient>(),
        exception: const ApiException(
          type: ApiErrorType.unknown,
          message: 'Transaction failed.',
          statusCode: 422,
          data: {
            'error': {
              'message': 'Insufficient packaging stock for Take Away.',
            },
          },
        ),
      ),
    );

    final result = await container.read(checkoutProvider.notifier).proceed(
          discountAmount: 0,
          paymentMethod: PaymentMethod.cash,
          cashTendered: 10000,
          printReceipt: false,
        );

    expect(result, isNull);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(balanceFetchCount, 0);
  });
}
