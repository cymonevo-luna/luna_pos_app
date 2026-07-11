import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_controller.dart';

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
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Map<String, dynamic> sampleMenusResponse() => {
        'success': true,
        'data': {
          'categories': [
            {
              'id': 'c1',
              'name': 'Drinks',
              'menus': [
                {
                  'id': 'm1',
                  'title': 'Es Teh',
                  'description': 'Sweet iced tea',
                  'photo_url': '/static/default-food.png',
                  'available_stock': 5,
                  'sell_price': 8000,
                },
                {
                  'id': 'm2',
                  'title': 'Sold Out Item',
                  'description': '',
                  'photo_url': '',
                  'available_stock': 0,
                  'sell_price': 12000,
                },
              ],
            },
          ],
        },
      };

  test('fetchPOSMenus parses categories and menu items', () async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    final response = await locator<MenuRepository>().fetchPOSMenus();

    expect(response.categories, hasLength(1));
    expect(response.categories.first.name, 'Drinks');
    expect(response.categories.first.menus, hasLength(2));
    expect(response.categories.first.menus.first.title, 'Es Teh');
    expect(response.categories.first.menus.first.sellPrice, 8000);
  });

  test('menu controller loads menus and adds in-stock items to cart', () async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    container.read(menuProvider.notifier);
    for (var i = 0;
        i < 50 && container.read(menuProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final loaded = container.read(menuProvider);
    expect(loaded.loading, isFalse);
    expect(loaded.error, isNull);
    expect(loaded.data?.categories.first.menus.first.id, 'm1');

    final inStock = loaded.data!.categories.first.menus.first;
    final outOfStock = loaded.data!.categories.first.menus.last;

    container.read(menuProvider.notifier).addToCart(inStock);
    expect(container.read(menuProvider).cart['m1']?.quantity, 1);
    expect(container.read(menuProvider).cartItemCount, 1);

    container.read(menuProvider.notifier).addToCart(inStock);
    expect(container.read(menuProvider).cart['m1']?.quantity, 2);

    container.read(menuProvider.notifier).addToCart(outOfStock);
    expect(container.read(menuProvider).cart.containsKey('m2'), isFalse);
  });

  test('menu controller surfaces API errors', () async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(500, {
        'success': false,
        'error': {'message': 'server error'},
      }),
    );

    container.read(menuProvider.notifier);
    for (var i = 0;
        i < 50 && container.read(menuProvider).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(menuProvider);
    expect(state.loading, isFalse);
    expect(state.error, isNotNull);
    expect(state.data, isNull);
  });
}
