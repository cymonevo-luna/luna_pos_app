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

  test('fetchFoodSupply decodes manual_edit_history', () async {
    adapter.onGet(
      '${FoodSupplyRepository.listPath}/fs-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'fs-1',
          'title': 'Flour',
          'description': '',
          'stock_quantity': '1500',
          'unit': 'gr',
          'manual_edit_history': [
            {
              'delta_quantity': '500',
              'previous_quantity': '1000',
              'new_quantity': '1500',
              'changed_by_username': 'ops-user',
              'created_at': '2026-07-14T10:00:00Z',
            },
          ],
        },
      }),
    );

    final supply = await locator<FoodSupplyRepository>().fetchFoodSupply('fs-1');

    expect(supply.manualEditHistory, hasLength(1));
    expect(supply.manualEditHistory.first.deltaQuantity, 500);
    expect(supply.manualEditHistory.first.changedByUsername, 'ops-user');
  });

  test('fetchFoodSupply defaults missing manual_edit_history to empty list', () async {
    adapter.onGet(
      '${FoodSupplyRepository.listPath}/fs-2',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'fs-2',
          'title': 'Sugar',
          'description': '',
          'stock_quantity': 100,
          'unit': 'gr',
        },
      }),
    );

    final supply = await locator<FoodSupplyRepository>().fetchFoodSupply('fs-2');

    expect(supply.manualEditHistory, isEmpty);
  });
}
