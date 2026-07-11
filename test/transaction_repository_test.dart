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
          'amount': 51000,
          'cash_tendered': 60000,
          'change_amount': 9000,
        },
      }),
      data: {
        'method': 'OFFLINE',
        'items': [
          {'menu_id': 'm1', 'quantity': 2},
          {'menu_id': 'm2', 'quantity': 1},
        ],
        'amount': 51000,
        'cash_tendered': 60000,
        'change_amount': 9000,
      },
    );

    final request = CreateTransactionRequest(
      method: 'OFFLINE',
      items: const [
        TransactionItemRequest(menuId: 'm1', quantity: 2),
        TransactionItemRequest(menuId: 'm2', quantity: 1),
      ],
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
