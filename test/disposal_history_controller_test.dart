import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';
import 'package:luna_pos/features/menu_disposal/disposal_history_controller.dart';

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
          'per_page': MenuDisposalRepository.defaultPerPage,
          'total': total,
        },
      };

  Map<String, dynamic> sampleItem(String id) => {
        'id': id,
        'menu_title': 'Nasi Goreng',
        'quantity': 2,
        'loss_amount': 15000,
        'disposed_at': '2026-07-24T10:00:00Z',
        'disposed_by_username': 'Cashier Test',
        'note': 'Expired',
      };

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerSingleton<ResourceCache>(testResourceCache())
      ..registerLazySingleton<MenuDisposalRepository>(
        () => MenuDisposalRepository(
          locator<ApiClient>(),
          locator<ResourceCache>(),
        ),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> waitForInitialLoad() async {
    await container.read(disposalHistoryProvider.notifier).loadIfNeeded();
    for (var i = 0;
        i < 50 && container.read(disposalHistoryProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('loads initial disposal history page', () async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(
          page: 1,
          total: 1,
          items: [sampleItem('disposal-1')],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(disposalHistoryProvider);
    expect(state.loading, isFalse);
    expect(state.error, isNull);
    expect(state.items, hasLength(1));
    expect(state.items.first.id, 'disposal-1');
    expect(state.items.first.disposedByUsername, 'Cashier Test');
  });

  test('appends next page on loadMore', () async {
    final pageOneItems = List.generate(
      20,
      (index) => sampleItem('disposal-$index'),
    );

    adapter.onGet(
      MenuDisposalRepository.listPath,
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

    final afterFirstPage = container.read(disposalHistoryProvider);
    expect(afterFirstPage.items, hasLength(20));
    expect(afterFirstPage.hasMore, isTrue);

    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(
          page: 2,
          total: 21,
          items: [sampleItem('disposal-20')],
        ),
      ),
      queryParameters: {'page': '2', 'per_page': '20'},
    );

    await container.read(disposalHistoryProvider.notifier).loadMore();
    for (var i = 0; i < 100; i++) {
      final state = container.read(disposalHistoryProvider);
      if (state.items.length == 21 && !state.loadingMore) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(disposalHistoryProvider);
    expect(state.items, hasLength(21));
    expect(state.items.last.id, 'disposal-20');
  });

  test('shows empty state when no disposals', () async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(page: 1, total: 0, items: []),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(disposalHistoryProvider);
    expect(state.isEmpty, isTrue);
  });

  test('refresh reloads first page', () async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(
          page: 1,
          total: 1,
          items: [sampleItem('disposal-1')],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(
        200,
        listResponse(
          page: 1,
          total: 2,
          items: [
            sampleItem('disposal-new'),
            sampleItem('disposal-1'),
          ],
        ),
      ),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await container.read(disposalHistoryProvider.notifier).refresh();
    for (var i = 0;
        i < 50 && container.read(disposalHistoryProvider).refreshing;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(disposalHistoryProvider);
    expect(state.items.first.id, 'disposal-new');
    expect(state.items, hasLength(2));
  });

  test('surfaces forbidden errors', () async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(403, {
        'success': false,
        'error': {'message': 'forbidden'},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(disposalHistoryProvider);
    expect(state.forbidden, isTrue);
    expect(state.items, isEmpty);
  });
}
