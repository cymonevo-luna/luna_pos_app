import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';

import 'helpers/auth_harness.dart';

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

  test('createOfflineTransaction posts expected payload', () async {
    adapter.onPost(
      '/api/v1/pos/transactions',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'tx-1',
          'method': 'OFFLINE',
          'subtotal_amount': 51000,
          'amount': 51000,
          'cash_tendered': 60000,
          'change_amount': 9000,
        },
      }),
      data: {
        'method': 'OFFLINE',
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
      method: 'OFFLINE',
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
        await locator<TransactionRepository>().createOfflineTransaction(
      request,
    );

    expect(response.id, 'tx-1');
    expect(response.method, 'OFFLINE');
    expect(response.amount, 51000);
    expect(response.cashTendered, 60000);
    expect(response.changeAmount, 9000);
  });
}
