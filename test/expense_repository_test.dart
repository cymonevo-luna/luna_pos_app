import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/expense/data/expense_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<ExpenseRepository>(
        () => ExpenseRepository(locator<ApiClient>()),
      );
  });

  test('fetchExpenses decodes paginated envelope', () async {
    adapter.onGet(
      ExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'exp-1',
            'title': 'Utilities',
            'description': 'Electric bill',
            'amount': '150000',
            'source_of_fund': 'PERSONAL_MONEY',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response = await locator<ExpenseRepository>().fetchExpenses();

    expect(response.items, hasLength(1));
    expect(response.items.first.title, 'Utilities');
    expect(response.items.first.amount, 150000);
    expect(response.items.first.createdAt, isNotNull);
  });

  test('patchExpenseRecordDate sends ISO8601 UTC body', () async {
    final recordDate = DateTime.utc(2026, 7, 15, 10);

    adapter.onPatch(
      '${ExpenseRepository.listPath}/exp-1/record-date',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'exp-1',
          'title': 'Utilities',
          'description': 'Electric bill',
          'amount': 150000,
          'source_of_fund': 'PERSONAL_MONEY',
          'created_at': recordDate.toIso8601String(),
          'updated_at': '2026-07-24T10:00:00Z',
        },
      }),
      data: {
        'record_date': recordDate.toIso8601String(),
      },
    );

    final updated = await locator<ExpenseRepository>()
        .patchExpenseRecordDate('exp-1', recordDate);

    expect(updated.id, 'exp-1');
    expect(updated.createdAt, recordDate);
  });
}
