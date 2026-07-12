import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<FoodSupplyRepository>(
        () => FoodSupplyRepository(locator<ApiClient>()),
      );
  });

  test('fetchFoodSupplies decodes paginated envelope', () async {
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'fs-1',
            'title': 'Flour',
            'description': 'All-purpose',
            'stock_quantity': '2500',
            'unit': 'gr',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
          {
            'id': 'fs-2',
            'title': 'Milk',
            'description': '',
            'stock_quantity': 500,
            'unit': 'ml',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 2},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response =
        await locator<FoodSupplyRepository>().fetchFoodSupplies();

    expect(response.items, hasLength(2));
    expect(response.page, 1);
    expect(response.total, 2);
    expect(response.hasMore, isFalse);
    expect(response.items.first.title, 'Flour');
    expect(response.items.first.stockQuantity, 2500);
    expect(response.items.last.stockQuantity, 500);
  });

  test('fetchFoodSupplies forwards search query', () async {
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

    final response = await locator<FoodSupplyRepository>().fetchFoodSupplies(
      search: 'Flour',
    );

    expect(response.items, hasLength(1));
    expect(response.items.first.title, 'Flour');
  });
}
