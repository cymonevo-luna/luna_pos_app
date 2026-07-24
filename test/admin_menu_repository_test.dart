import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/menu_management/data/admin_menu_repository.dart';
import 'package:luna_pos/features/menu_management/models/admin_menu.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<AdminMenuRepository>(
        () => AdminMenuRepository(locator<ApiClient>()),
      );
  });

  test('fetchMenus decodes paginated envelope', () async {
    adapter.onGet(
      AdminMenuRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'menu-1',
            'title': 'Nasi Goreng',
            'description': 'Spicy fried rice',
            'category_id': 'cat-1',
            'category_name': 'Rice',
            'photo_url': '/uploads/nasi-goreng.jpg',
            'available_stock': 12,
            'sell_price': 25000,
            'recipe_yield': 1,
            'margin_percent': '35.5',
            'vat_percent': '11',
            'created_at': '2026-07-12T10:00:00Z',
            'updated_at': '2026-07-12T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response = await locator<AdminMenuRepository>().fetchMenus();

    expect(response.items, hasLength(1));
    expect(response.page, 1);
    expect(response.total, 1);
    expect(response.items.first.title, 'Nasi Goreng');
    expect(response.items.first.sellPrice, 25000);
    expect(response.items.first.marginPercent, 35.5);
    expect(response.items.first.vatPercent, 11);
  });

  test('fetchMenus forwards search and sort query params', () async {
    adapter.onGet(
      AdminMenuRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {
        'page': '1',
        'per_page': '20',
        'search': 'Nasi',
        'sort_by': 'stock',
        'sort_order': 'desc',
      },
    );

    final response = await locator<AdminMenuRepository>().fetchMenus(
      search: 'Nasi',
      sortBy: AdminMenuSortBy.stock,
      sortOrder: AdminMenuSortOrder.desc,
    );

    expect(response.items, isEmpty);
    expect(response.total, 0);
  });

  test('fetchMenu decodes single menu', () async {
    adapter.onGet(
      '${AdminMenuRepository.listPath}/menu-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'menu-1',
          'title': 'Nasi Goreng',
          'description': 'Spicy fried rice',
          'category_id': 'cat-1',
          'category_name': 'Rice',
          'photo_url': '/uploads/nasi-goreng.jpg',
          'available_stock': 12,
          'sell_price': 25000,
          'recipe_yield': 1,
          'margin_percent': 35.5,
          'vat_percent': 11,
        },
      }),
    );

    final menu = await locator<AdminMenuRepository>().fetchMenu('menu-1');

    expect(menu.id, 'menu-1');
    expect(menu.categoryName, 'Rice');
    expect(menu.availableStock, 12);
  });

  test('create posts menu request body', () async {
    adapter.onPost(
      AdminMenuRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'menu-new',
          'title': 'Es Teh',
          'description': 'Iced tea',
          'category_id': 'cat-2',
          'category_name': 'Drinks',
          'available_stock': 0,
          'sell_price': 8000,
          'recipe_yield': 1,
          'margin_percent': 40,
          'vat_percent': 11,
        },
      }),
      data: {
        'title': 'Es Teh',
        'description': 'Iced tea',
        'category_id': 'cat-2',
        'photo_url': '/uploads/es-teh.jpg',
        'available_stock': 0,
        'sell_price': 8000,
      },
    );

    final created = await locator<AdminMenuRepository>().create(
      const AdminMenuRequest(
        title: 'Es Teh',
        description: 'Iced tea',
        categoryId: 'cat-2',
        photoUrl: '/uploads/es-teh.jpg',
        availableStock: 0,
        sellPrice: 8000,
      ),
    );

    expect(created.id, 'menu-new');
    expect(created.title, 'Es Teh');
    expect(created.sellPrice, 8000);
  });

  test('update puts menu request body', () async {
    adapter.onPut(
      '${AdminMenuRepository.listPath}/menu-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'menu-1',
          'title': 'Nasi Goreng Special',
          'description': 'Extra spicy',
          'category_id': 'cat-1',
          'category_name': 'Rice',
          'available_stock': 10,
          'sell_price': 30000,
          'recipe_yield': 1,
          'margin_percent': 38,
          'vat_percent': 11,
        },
      }),
      data: {
        'title': 'Nasi Goreng Special',
        'description': 'Extra spicy',
        'category_id': 'cat-1',
        'available_stock': 10,
        'sell_price': 30000,
        'recipe_yield': 1,
        'margin_percent': 38,
        'vat_percent': 11,
      },
    );

    final updated = await locator<AdminMenuRepository>().update(
      'menu-1',
      const AdminMenuRequest(
        title: 'Nasi Goreng Special',
        description: 'Extra spicy',
        categoryId: 'cat-1',
        availableStock: 10,
        sellPrice: 30000,
        recipeYield: 1,
        marginPercent: 38,
        vatPercent: 11,
      ),
    );

    expect(updated.title, 'Nasi Goreng Special');
    expect(updated.sellPrice, 30000);
  });

  test('delete calls menu delete path', () async {
    adapter.onDelete(
      '${AdminMenuRepository.listPath}/menu-1',
      (server) => server.reply(204, null),
    );

    await locator<AdminMenuRepository>().delete('menu-1');
  });
}
