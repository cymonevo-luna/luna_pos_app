import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';

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

  Map<String, dynamic> orderedCategoriesResponse() => {
    'success': true,
    'data': {
      'categories': [
        {
          'id': 'c2',
          'name': 'Desserts',
          'menus': [
            {
              'id': 'm-dessert',
              'title': 'Pudding',
              'description': 'warm hot dessert',
              'photo_url': '/static/default-food.png',
              'available_stock': 5,
              'sell_price': 15000,
            },
          ],
        },
        {
          'id': 'c3',
          'name': 'Appetizers',
          'menus': [
            {
              'id': 'm-appetizer',
              'title': 'Spring Rolls',
              'description': 'served hot',
              'photo_url': '/static/default-food.png',
              'available_stock': 10,
              'sell_price': 20000,
            },
          ],
        },
        {
          'id': 'c1',
          'name': 'Mains',
          'menus': [
            {
              'id': 'm-main',
              'title': 'Nasi Goreng',
              'description': 'wok-fried hot rice',
              'photo_url': '/static/default-food.png',
              'available_stock': 3,
              'sell_price': 35000,
            },
          ],
        },
      ],
    },
  };

  Map<String, dynamic> descriptionSearchResponse() => {
    'success': true,
    'data': {
      'categories': [
        {
          'id': 'c1',
          'name': 'Specials',
          'menus': [
            {
              'id': 'm-special',
              'title': 'Chef Choice',
              'description': 'contains galangal root',
              'photo_url': '/static/default-food.png',
              'available_stock': 2,
              'sell_price': 45000,
            },
            {
              'id': 'm-other',
              'title': 'Plain Rice',
              'description': 'steamed white rice',
              'photo_url': '/static/default-food.png',
              'available_stock': 10,
              'sell_price': 12000,
            },
          ],
        },
      ],
    },
  };

  Future<MenuState> loadMenu(Map<String, dynamic> response) async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, response),
    );

    container.read(menuProvider.notifier);
    for (var i = 0; i < 50 && container.read(menuProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    return container.read(menuProvider);
  }

  int totalMenuCount(POSMenusResponse? data) {
    if (data == null) return 0;
    return data.categories.fold<int>(
      0,
      (count, category) => count + category.menus.length,
    );
  }

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

  test('fetchPOSMenus preserves API category order', () async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, orderedCategoriesResponse()),
    );

    final response = await locator<MenuRepository>().fetchPOSMenus();

    expect(response.categories.map((category) => category.name).toList(), [
      'Desserts',
      'Appetizers',
      'Mains',
    ]);
  });

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

  test('menu controller loads menus successfully', () async {
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    container.read(menuProvider.notifier);
    for (var i = 0; i < 50 && container.read(menuProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final loaded = container.read(menuProvider);
    expect(loaded.loading, isFalse);
    expect(loaded.error, isNull);
    expect(loaded.data?.categories.first.menus.first.id, 'm1');
    expect(loaded.data?.categories.first.menus.first.title, 'Es Teh');
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
    for (var i = 0; i < 50 && container.read(menuProvider).loading; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    final state = container.read(menuProvider);
    expect(state.loading, isFalse);
    expect(state.error, isNotNull);
    expect(state.data, isNull);
  });

  test('empty search returns all items', () async {
    final loaded = await loadMenu(orderedCategoriesResponse());
    final controller = container.read(menuProvider.notifier);

    expect(loaded.search, '');
    expect(
      loaded.filteredData?.categories.map((category) => category.name).toList(),
      ['Desserts', 'Appetizers', 'Mains'],
    );
    expect(totalMenuCount(loaded.filteredData), 3);

    controller.setSearch('');
    final afterClear = container.read(menuProvider);

    expect(
      afterClear.filteredData?.categories
          .map((category) => category.name)
          .toList(),
      ['Desserts', 'Appetizers', 'Mains'],
    );
    expect(totalMenuCount(afterClear.filteredData), 3);
  });

  test('filter by title substring', () async {
    await loadMenu(orderedCategoriesResponse());
    container.read(menuProvider.notifier).setSearch('nasi');

    final state = container.read(menuProvider);
    final filtered = state.filteredData!;

    expect(filtered.categories, hasLength(1));
    expect(filtered.categories.first.name, 'Mains');
    expect(filtered.categories.first.menus, hasLength(1));
    expect(filtered.categories.first.menus.first.title, 'Nasi Goreng');
  });

  test('filter by description substring', () async {
    await loadMenu(descriptionSearchResponse());
    container.read(menuProvider.notifier).setSearch('galangal');

    final state = container.read(menuProvider);
    final filtered = state.filteredData!;

    expect(filtered.categories, hasLength(1));
    expect(filtered.categories.first.menus, hasLength(1));
    expect(filtered.categories.first.menus.first.id, 'm-special');
    expect(filtered.categories.first.menus.first.title, 'Chef Choice');
  });

  test('case-insensitive matching', () async {
    await loadMenu(orderedCategoriesResponse());
    container.read(menuProvider.notifier).setSearch('GORENG');

    final state = container.read(menuProvider);
    final filtered = state.filteredData!;

    expect(filtered.categories.first.menus.first.title, 'Nasi Goreng');
  });

  test('hide empty categories after filter', () async {
    await loadMenu(orderedCategoriesResponse());
    container.read(menuProvider.notifier).setSearch('nasi');

    final state = container.read(menuProvider);
    final filtered = state.filteredData!;

    expect(filtered.categories.map((category) => category.name).toList(), [
      'Mains',
    ]);
    expect(totalMenuCount(filtered), 1);
  });

  test('preserve API category order', () async {
    await loadMenu(orderedCategoriesResponse());
    container.read(menuProvider.notifier).setSearch('hot');

    final state = container.read(menuProvider);
    final filtered = state.filteredData!;

    expect(filtered.categories.map((category) => category.name).toList(), [
      'Desserts',
      'Appetizers',
      'Mains',
    ]);
    expect(totalMenuCount(filtered), 3);
  });

  test('whitespace-only query shows all', () async {
    await loadMenu(orderedCategoriesResponse());
    final controller = container.read(menuProvider.notifier);

    controller.setSearch('nasi');
    expect(container.read(menuProvider).filteredData?.categories, hasLength(1));

    controller.setSearch('   ');
    final state = container.read(menuProvider);

    expect(
      state.filteredData?.categories.map((category) => category.name).toList(),
      ['Desserts', 'Appetizers', 'Mains'],
    );
    expect(totalMenuCount(state.filteredData), 3);
    expect(state.hasNoSearchResults, isFalse);
  });

  test('hasNoSearchResults is true when search has no matches', () async {
    await loadMenu(orderedCategoriesResponse());
    container.read(menuProvider.notifier).setSearch('zzznomatch');

    final state = container.read(menuProvider);

    expect(state.hasNoSearchResults, isTrue);
    expect(state.filteredData?.categories, isEmpty);
  });

  test('filteredData is null while data is not loaded', () {
    final state = container.read(menuProvider);

    expect(state.data, isNull);
    expect(state.filteredData, isNull);
    expect(state.hasNoSearchResults, isFalse);
  });
}
