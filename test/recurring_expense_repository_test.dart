import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/recurring_expense/data/recurring_expense_repository.dart';
import 'package:luna_pos/features/recurring_expense/models/recurring_expense.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<RecurringExpenseRepository>(
        () => RecurringExpenseRepository(locator<ApiClient>()),
      );
  });

  test('fetchRecurringExpenses decodes paginated envelope', () async {
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 're-1',
            'title': 'Rent',
            'description': 'Monthly rent',
            'amount': '2500000',
            'is_active': true,
            'recurring': {
              'interval': 'DATE',
              'value': 1,
              'time': {'hour': 9, 'minute': 0, 'second': 0},
            },
            'next_run_at': '2026-08-01T09:00:00Z',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response =
        await locator<RecurringExpenseRepository>().fetchRecurringExpenses();

    expect(response.items, hasLength(1));
    expect(response.page, 1);
    expect(response.total, 1);
    expect(response.items.first.title, 'Rent');
    expect(response.items.first.amount, 2500000);
    expect(response.items.first.recurring.interval, RecurringInterval.date);
    expect(response.items.first.recurring.value, 1);
    expect(response.items.first.nextRunAt, isNotNull);
  });

  test('create serializes DAY interval payload', () async {
    adapter.onPost(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 're-new',
          'title': 'Utilities',
          'description': '',
          'amount': 100000,
          'is_active': true,
          'recurring': {
            'interval': 'DAY',
            'value': 2,
            'time': {'hour': 8, 'minute': 30, 'second': 0},
          },
        },
      }),
      data: {
        'title': 'Utilities',
        'description': '',
        'amount': 100000,
        'recurring': {
          'interval': 'DAY',
          'value': 2,
          'time': {'hour': 8, 'minute': 30, 'second': 0},
        },
      },
    );

    final created = await locator<RecurringExpenseRepository>().create(
      const RecurringExpenseRequest(
        title: 'Utilities',
        description: '',
        amount: 100000,
        recurring: RecurringSchedule(
          interval: RecurringInterval.day,
          value: 2,
          time: RecurringScheduleTime(hour: 8, minute: 30, second: 0),
        ),
      ),
    );

    expect(created.id, 're-new');
    expect(created.recurring.interval, RecurringInterval.day);
    expect(created.recurring.value, 2);
  });
}
