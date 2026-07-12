import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/transaction/transaction_history_controller.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  Map<String, dynamic> listResponse({
    required int page,
    required List<Map<String, dynamic>> items,
    required int total,
  }) =>
      {
        'success': true,
        'data': items,
        'meta': {
          'page': page,
          'per_page': TransactionRepository.defaultPerPage,
          'total': total,
        },
      };

  Map<String, dynamic> sampleItem(String id, int amount) => {
        'id': id,
        'method': 'OFFLINE',
        'amount': amount,
        'cashier_username': 'Cashier Test',
        'transaction_date': '2026-07-12T10:00:00Z',
      };

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> waitForInitialLoad() async {
    container.read(transactionHistoryProvider.notifier);
    for (var i = 0; i < 50 && container.read(transactionHistoryProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('loads initial transaction page', () async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(
          page: 1,
          total: 1,
          items: [sampleItem('tx-1', 25000)],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(transactionHistoryProvider);
    expect(state.loading, isFalse);
    expect(state.error, isNull);
    expect(state.items, hasLength(1));
    expect(state.items.first.id, 'tx-1');
  });

  test('appends next page on loadMore', () async {
    final pageOneItems = List.generate(
      20,
      (index) => sampleItem('tx-$index', 10000 + index),
    );

    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(
          page: 1,
          total: 21,
          items: pageOneItems,
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final afterFirstPage = container.read(transactionHistoryProvider);
    expect(afterFirstPage.items, hasLength(20));
    expect(afterFirstPage.hasMore, isTrue);

    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(
          page: 2,
          total: 21,
          items: [sampleItem('tx-20', 50000)],
        ),
      ),
      queryParameters: {'page': '2', 'per_page': '20'},
    );

    await container.read(transactionHistoryProvider.notifier).loadMore();
    for (var i = 0; i < 100; i++) {
      final state = container.read(transactionHistoryProvider);
      if (state.items.length == 21 && !state.loadingMore) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(transactionHistoryProvider);
    expect(state.items, hasLength(21));
    expect(state.items.last.id, 'tx-20');
  });

  test('shows empty state when no transactions', () async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(
        200,
        listResponse(page: 1, total: 0, items: []),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(transactionHistoryProvider);
    expect(state.isEmpty, isTrue);
  });

  test('surfaces forbidden errors', () async {
    adapter.onGet(
      '/api/v1/pos/transactions',
      (server) => server.reply(403, {
        'success': false,
        'error': {'message': 'forbidden'},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(transactionHistoryProvider);
    expect(state.forbidden, isTrue);
    expect(state.items, isEmpty);
  });
}
