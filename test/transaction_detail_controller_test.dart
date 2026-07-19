import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';
import 'package:luna_pos/features/transaction/transaction_detail_controller.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

class _FakeTransactionRepository extends TransactionRepository {
  _FakeTransactionRepository(super.api, super.cache, this._detail);

  final TransactionDetail _detail;

  @override
  Future<TransactionDetail> fetchTransactionDetail(String id) async => _detail;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late DioAdapter adapter;
  late MockBluetoothPrinterService printer;

  final detail = TransactionDetail(
    id: 'tx-1',
    method: 'CASH',
    items: [
      TransactionItemRequest(
        menuId: 'm1',
        title: 'Nasi Goreng',
        quantity: 1,
        unitPrice: 35000,
        lineTotal: 35000,
      ),
    ],
    subtotalAmount: 35000,
    amount: 35000,
    cashTendered: 50000,
    changeAmount: 15000,
    cashierUsername: 'Cashier Test',
    transactionDate: DateTime.utc(2026, 7, 12, 10),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    printer = MockBluetoothPrinterService();

    registerAuthTestServices(client: mocked.client, secure: FakeSecureStorage());
    registerTestResourceCache();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<TransactionRepository>(
        _FakeTransactionRepository(mocked.client, testResourceCache(), detail),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>(), testResourceCache()),
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

    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
    printer.dispose();
  });

  Future<void> waitForDetail() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(transactionDetailProvider('tx-1')).detail, isNotNull);
  }

  test('printReceipt prints receipt on success', () async {
    container.read(transactionDetailProvider('tx-1'));
    await waitForDetail();
    await printer.connect('00:11:22:33:44:55');

    await container
        .read(transactionDetailProvider('tx-1').notifier)
        .printReceipt();

    final state = container.read(transactionDetailProvider('tx-1'));
    expect(state.isPrinting, isFalse);
    expect(state.printError, isNull);
    expect(printer.lastPrintedBytes, isNotNull);
    expect(printer.lastPrintedBytes, isNotEmpty);
  });

  test('printReceipt surfaces store settings failure', () async {
    adapter.reset();
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(500, {
        'success': false,
        'error': {'message': 'settings unavailable'},
      }),
    );

    container.read(transactionDetailProvider('tx-1'));
    await waitForDetail();

    await container
        .read(transactionDetailProvider('tx-1').notifier)
        .printReceipt();

    final state = container.read(transactionDetailProvider('tx-1'));
    expect(state.isPrinting, isFalse);
    expect(state.printError, isNotNull);
    expect(printer.lastPrintedBytes, isNull);
  });

  test('printReceipt surfaces printer failure', () async {
    await printer.connect('00:11:22:33:44:55');
    printer.dispose();
    final failingPrinter = MockBluetoothPrinterService(printSucceeds: false);
    locator.unregister<BluetoothPrinterService>();
    locator.registerSingleton<BluetoothPrinterService>(failingPrinter);
    await failingPrinter.connect('00:11:22:33:44:55');
    locator.unregister<ReceiptPrintService>();
    locator.registerSingleton<ReceiptPrintService>(ReceiptPrintService());

    container.read(transactionDetailProvider('tx-1'));
    await waitForDetail();

    await container
        .read(transactionDetailProvider('tx-1').notifier)
        .printReceipt();

    final state = container.read(transactionDetailProvider('tx-1'));
    expect(state.isPrinting, isFalse);
    expect(state.printError, isNotNull);
    expect(failingPrinter.lastPrintedBytes, isNull);
    failingPrinter.dispose();
  });

  test('printReceipt is guarded while printing', () async {
    container.read(transactionDetailProvider('tx-1'));
    await waitForDetail();
    await printer.connect('00:11:22:33:44:55');

    final notifier =
        container.read(transactionDetailProvider('tx-1').notifier);
    final first = notifier.printReceipt();
    final second = notifier.printReceipt();
    await Future.wait([first, second]);

    expect(printer.lastPrintedBytes, isNotNull);
  });
}
