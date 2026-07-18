import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';

import 'helpers/auth_harness.dart';
import 'helpers/order_option_test_data.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      );
  });

  test('createTransaction posts cash payload with cash fields', () async {
    adapter.onPost(
      '/api/v1/pos/transactions',
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'tx-1',
          'method': 'CASH',
          'subtotal_amount': 51000,
          'amount': 51000,
          'cash_tendered': 60000,
          'change_amount': 9000,
        },
      }),
      data: {
        ...kTestOrderOptionIdBodyField,
        'method': 'CASH',
        'items': [
          {
            'menu_id': 'm1',
            'title': 'Es Teh',
            'quantity': 2,
            'unit_price': 8000,
            'line_total': 16000,
          },
          {
            'menu_id': 'm2',
            'title': 'Nasi Goreng',
            'quantity': 1,
            'unit_price': 35000,
            'line_total': 35000,
          },
        ],
        'subtotal_amount': 51000,
        'discount_amount': 0,
        'amount': 51000,
        'cash_tendered': 60000,
        'change_amount': 9000,
      },
    );

    final request = CreateTransactionRequest(
      orderOptionId: kTestOrderOptionId,
      method: 'CASH',
      items: const [
        TransactionItemRequest(
          menuId: 'm1',
          title: 'Es Teh',
          quantity: 2,
          unitPrice: 8000,
          lineTotal: 16000,
        ),
        TransactionItemRequest(
          menuId: 'm2',
          title: 'Nasi Goreng',
          quantity: 1,
          unitPrice: 35000,
          lineTotal: 35000,
        ),
      ],
      subtotalAmount: 51000,
      amount: 51000,
      cashTendered: 60000,
      changeAmount: 9000,
    );

    final response =
        await locator<TransactionRepository>().createTransaction(
      request,
    );

    expect(response.id, 'tx-1');
    expect(response.method, 'CASH');
    expect(response.amount, 51000);
    expect(response.cashTendered, 60000);
    expect(response.changeAmount, 9000);
  });

  test('createTransaction omits cash fields for qris', () async {
    adapter.onPost(
      '/api/v1/pos/transactions',
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'tx-qris-1',
          'method': 'QRIS',
          'subtotal_amount': 35000,
          'amount': 35000,
        },
      }),
      data: {
        ...kTestOrderOptionIdBodyField,
        'method': 'QRIS',
        'items': [
          {
            'menu_id': 'm2',
            'title': 'Nasi Goreng',
            'quantity': 1,
            'unit_price': 35000,
            'line_total': 35000,
          },
        ],
        'subtotal_amount': 35000,
        'discount_amount': 0,
        'amount': 35000,
      },
    );

    final request = CreateTransactionRequest(
      orderOptionId: kTestOrderOptionId,
      method: 'QRIS',
      items: const [
        TransactionItemRequest(
          menuId: 'm2',
          title: 'Nasi Goreng',
          quantity: 1,
          unitPrice: 35000,
          lineTotal: 35000,
        ),
      ],
      subtotalAmount: 35000,
      amount: 35000,
    );

    final response =
        await locator<TransactionRepository>().createTransaction(request);

    expect(response.id, 'tx-qris-1');
    expect(response.method, 'QRIS');
    expect(response.cashTendered, isNull);
    expect(response.changeAmount, isNull);
  });

  test('fetchTransactions parses paginated list', () async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'tx-1',
            'method': 'CASH',
            'amount': 25000,
            'cashier_username': 'Cashier Test',
            'transaction_date': '2026-07-12T10:00:00Z',
          },
          {
            'id': 'tx-2',
            'method': 'QRIS',
            'amount': 35000,
            'cashier_username': 'Cashier Test',
            'transaction_date': '2026-07-11T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 2},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response = await locator<TransactionRepository>().fetchTransactions();

    expect(response.items, hasLength(2));
    expect(response.page, 1);
    expect(response.total, 2);
    expect(response.hasMore, isFalse);
    expect(response.items.first.id, 'tx-1');
    expect(response.items.first.cashierUsername, 'Cashier Test');
  });

  test('fetchTransactions forwards date filters', () async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {
        'page': '1',
        'per_page': '20',
        'date_from': '2026-07-01',
        'date_to': '2026-07-12',
      },
    );

    final response = await locator<TransactionRepository>().fetchTransactions(
      dateFrom: DateTime(2026, 7, 1),
      dateTo: DateTime(2026, 7, 12),
    );

    expect(response.items, isEmpty);
    expect(response.total, 0);
  });

  test('fetchTransactionDetail parses line items and totals', () async {
    adapter.onGet(
      '/api/v1/pos/transactions/tx-1',
      (server) => server.reply(200, {
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
      }),
    );

    final detail =
        await locator<TransactionRepository>().fetchTransactionDetail('tx-1');

    expect(detail.id, 'tx-1');
    expect(detail.items, hasLength(1));
    expect(detail.items.first.title, 'Nasi Goreng');
    expect(detail.subtotalAmount, 35000);
    expect(detail.cashTendered, 50000);
    expect(detail.changeAmount, 15000);
    expect(detail.cashierUsername, 'Cashier Test');
  });
}
