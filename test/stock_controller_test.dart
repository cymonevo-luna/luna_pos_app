import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';
import 'package:luna_pos/features/stock/stock_controller.dart';

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
      ..registerLazySingleton<FoodSupplyRepository>(
        () => FoodSupplyRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('search triggers query param after debounce', () async {
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'fs-1',
            'title': 'Flour',
            'description': '',
            'stock_quantity': 1000,
            'unit': 'gr',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {
        'page': '1',
        'per_page': '20',
        'search': 'Flour',
      },
    );

    container.read(stockProvider.notifier);
    for (var i = 0; i < 50 && container.read(stockProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    container.read(stockProvider.notifier).setSearch('Flour');
    await Future<void>.delayed(const Duration(milliseconds: 350));

    for (var i = 0; i < 50 && container.read(stockProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(stockProvider);
    expect(state.search, 'Flour');
    expect(state.items, hasLength(1));
    expect(state.items.first.title, 'Flour');
  });
}
