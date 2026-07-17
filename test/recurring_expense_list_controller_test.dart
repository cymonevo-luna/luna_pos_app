import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/recurring_expense/data/recurring_expense_repository.dart';
import 'package:luna_pos/features/recurring_expense/recurring_expense_list_controller.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<RecurringExpenseRepository>(
        () => RecurringExpenseRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> waitForInitialLoad() async {
    container.read(recurringExpenseListProvider.notifier);
    for (var i = 0;
        i < 50 && container.read(recurringExpenseListProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('loadInitial sets items from repository', () async {
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 're-1',
            'title': 'Rent',
            'description': '',
            'amount': 100000,
            'is_active': true,
            'recurring': {
              'interval': 'DAILY',
              'time': {'hour': 9, 'minute': 0, 'second': 0},
            },
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(recurringExpenseListProvider);
    expect(state.items, hasLength(1));
    expect(state.items.first.title, 'Rent');
    expect(state.total, 1);
    expect(state.loading, isFalse);
  });

  test('loadMore appends next page', () async {
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 're-1',
            'title': 'Rent',
            'description': '',
            'amount': 100000,
            'is_active': true,
            'recurring': {
              'interval': 'DAILY',
              'time': {'hour': 9, 'minute': 0, 'second': 0},
            },
          },
        ],
        'meta': {'page': 1, 'per_page': 1, 'total': 2},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 're-2',
            'title': 'Utilities',
            'description': '',
            'amount': 50000,
            'is_active': true,
            'recurring': {
              'interval': 'DAILY',
              'time': {'hour': 8, 'minute': 0, 'second': 0},
            },
          },
        ],
        'meta': {'page': 2, 'per_page': 1, 'total': 2},
      }),
      queryParameters: {'page': '2', 'per_page': '20'},
    );

    await waitForInitialLoad();
    await container.read(recurringExpenseListProvider.notifier).loadMore();
    for (var i = 0;
        i < 50 && container.read(recurringExpenseListProvider).loadingMore;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(recurringExpenseListProvider);
    expect(state.items, hasLength(2));
    expect(state.page, 2);
    expect(state.hasMore, isFalse);
  });

  test('deleteExpense removes item and decrements total', () async {
    adapter.onGet(
      RecurringExpenseRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 're-1',
            'title': 'Rent',
            'description': '',
            'amount': 100000,
            'is_active': true,
            'recurring': {
              'interval': 'DAILY',
              'time': {'hour': 9, 'minute': 0, 'second': 0},
            },
          },
          {
            'id': 're-2',
            'title': 'Utilities',
            'description': '',
            'amount': 50000,
            'is_active': true,
            'recurring': {
              'interval': 'DAILY',
              'time': {'hour': 8, 'minute': 0, 'second': 0},
            },
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 2},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onDelete(
      '${RecurringExpenseRepository.listPath}/re-1',
      (server) => server.reply(200, {'success': true}),
    );

    await waitForInitialLoad();
    final deleted = await container
        .read(recurringExpenseListProvider.notifier)
        .deleteExpense('re-1');

    expect(deleted, isTrue);
    final state = container.read(recurringExpenseListProvider);
    expect(state.items, hasLength(1));
    expect(state.items.first.id, 're-2');
    expect(state.total, 1);
  });
}
