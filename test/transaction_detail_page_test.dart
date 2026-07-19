import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/transaction_detail_controller.dart';
import 'package:luna_pos/features/transaction/transaction_detail_page.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;
  late MockBluetoothPrinterService printer;

  Map<String, dynamic> storeSettingsPayload() => {
        'success': true,
        'data': {
          'brand_name': 'Luna Cafe',
          'branch_name': 'Cabang Sudirman',
          'address': 'Jl. Sudirman No. 10',
          'phone': '021-1234567',
          'thank_you_note': 'Terima kasih!',
        },
      };

  Map<String, dynamic> cashTransactionDetailPayload() => {
        'success': true,
        'data': {
          'id': 'tx-1',
          'method': 'CASH',
          'items': [
            {
              'menu_id': 'm1',
              'title': 'Nasi Goreng',
              'quantity': 1,
              'unit_price': 35000,
              'line_total': 35000,
            },
          ],
          'subtotal_amount': 35000,
          'discount_amount': 0,
          'amount': 35000,
          'cash_tendered': 50000,
          'change_amount': 15000,
          'cashier_username': 'Cashier Test',
          'transaction_date': '2026-07-12T10:00:00Z',
        },
      };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    secure = FakeSecureStorage();
    printer = MockBluetoothPrinterService();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer)
      ..registerLazySingleton<ReceiptPrintService>(ReceiptPrintService.new);

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.cashier,
    );
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
    );
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(200, storeSettingsPayload()),
    );
  });

  tearDown(() {
    printer.dispose();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  }

  testWidgets('transaction detail shows line items and totals', (tester) async {
    adapter
      ..onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [
            {
              'id': 'tx-1',
              'method': 'CASH',
              'amount': 35000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
          'meta': {'page': 1, 'per_page': 20, 'total': 1},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      )
      ..onGet(
        '/api/v1/pos/transactions/tx-1',
        (server) => server.reply(200, cashTransactionDetailPayload()),
      );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rp 35.000'));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.textContaining('Cashier Test'), findsWidgets);
    expect(find.text('Rp 50.000'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
  });

  testWidgets('transaction detail hides cash fields for qris', (tester) async {
    adapter
      ..onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [
            {
              'id': 'tx-qris-1',
              'method': 'QRIS',
              'amount': 35000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
          'meta': {'page': 1, 'per_page': 20, 'total': 1},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      )
      ..onGet(
        '/api/v1/pos/transactions/tx-qris-1',
        (server) => server.reply(200, {
          'success': true,
          'data': {
            'id': 'tx-qris-1',
            'method': 'QRIS',
            'items': [
              {
                'menu_id': 'm1',
                'title': 'Nasi Goreng',
                'quantity': 1,
                'unit_price': 35000,
                'line_total': 35000,
              },
            ],
            'subtotal_amount': 35000,
            'discount_amount': 0,
            'amount': 35000,
            'cashier_username': 'Cashier Test',
            'transaction_date': '2026-07-12T10:00:00Z',
          },
        }),
      );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rp 35.000'));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.textContaining('QRIS'), findsWidgets);
    expect(find.text('Cash received'), findsNothing);
    expect(find.text('Change'), findsNothing);
  });

  Future<void> openCashTransactionDetail(WidgetTester tester) async {
    adapter
      ..onGet(
        '/api/v1/pos/transactions',
        (server) => server.reply(200, {
          'success': true,
          'data': [
            {
              'id': 'tx-1',
              'method': 'CASH',
              'amount': 35000,
              'cashier_username': 'Cashier Test',
              'transaction_date': '2026-07-12T10:00:00Z',
            },
          ],
          'meta': {'page': 1, 'per_page': 20, 'total': 1},
        }),
        queryParameters: {'page': '1', 'per_page': '20'},
      )
      ..onGet(
        '/api/v1/pos/transactions/tx-1',
        (server) => server.reply(200, cashTransactionDetailPayload()),
      );

    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rp 35.000'));
    await tester.pumpAndSettle();
  }

  testWidgets('transaction detail shows print receipt action when loaded',
      (tester) async {
    await openCashTransactionDetail(tester);

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.byKey(const Key('print_receipt_button')), findsOneWidget);
    expect(find.byIcon(Icons.print_outlined), findsOneWidget);
  });

  testWidgets('print receipt sends bytes and shows success snackbar',
      (tester) async {
    await printer.connect('00:11:22:33:44:55');
    await openCashTransactionDetail(tester);

    await tester.tap(find.byKey(const Key('print_receipt_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    expect(printer.lastPrintedBytes, isNotNull);
    expect(printer.lastPrintedBytes, isNotEmpty);
    expect(find.text('Receipt printed'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });

  testWidgets('print receipt failure keeps detail and surfaces print error',
      (tester) async {
    adapter.reset();
    seedAuthenticatedTestAccount(secure, adapter, TestAccountRole.cashier);
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
    );
    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(500, {
        'success': false,
        'error': {'message': 'settings unavailable'},
      }),
    );
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'tx-1',
            'method': 'CASH',
            'amount': 35000,
            'cashier_username': 'Cashier Test',
            'transaction_date': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onGet(
      '/api/v1/pos/transactions/tx-1',
      (server) => server.reply(200, cashTransactionDetailPayload()),
    );

    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rp 35.000'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('print_receipt_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 1));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(TransactionDetailPage)),
    );
    final state = container.read(transactionDetailProvider('tx-1'));

    expect(state.printError, isNotNull);
    expect(state.isPrinting, isFalse);
    expect(printer.lastPrintedBytes, isNull);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });
}
