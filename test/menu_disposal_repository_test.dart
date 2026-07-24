import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

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
  });

  test('createMenuDisposal posts payload and decodes response', () async {
    adapter.onPost(
      MenuDisposalRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'disposal-1',
          'menu_title': 'Nasi Goreng',
          'quantity': 2,
          'loss_amount': 15000,
          'disposed_at': '2026-07-24T10:00:00Z',
        },
      }),
      data: {
        'menu_id': 'menu-1',
        'quantity': 2,
        'note': 'Expired',
      },
    );

    final repository = locator<MenuDisposalRepository>();
    final response = await repository.createMenuDisposal(
      menuId: 'menu-1',
      quantity: 2,
      note: 'Expired',
    );

    expect(response.id, 'disposal-1');
    expect(response.menuTitle, 'Nasi Goreng');
    expect(response.quantity, 2);
    expect(response.lossAmount, 15000);
  });

  test('createMenuDisposal omits empty note', () async {
    adapter.onPost(
      MenuDisposalRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'disposal-2',
          'menu_title': 'Es Teh',
          'quantity': 1,
          'loss_amount': 3000,
          'disposed_at': '2026-07-24T10:00:00Z',
        },
      }),
      data: {
        'menu_id': 'menu-2',
        'quantity': 1,
      },
    );

    final repository = locator<MenuDisposalRepository>();
    final response = await repository.createMenuDisposal(
      menuId: 'menu-2',
      quantity: 1,
      note: '   ',
    );

    expect(response.menuTitle, 'Es Teh');
  });

  test('listMenuDisposals decodes paginated response', () async {
    adapter.onGet(
      MenuDisposalRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'disposal-1',
            'menu_title': 'Nasi Goreng',
            'quantity': 2,
            'loss_amount': 15000,
            'disposed_at': '2026-07-24T10:00:00Z',
          },
        ],
        'meta': {
          'page': 1,
          'per_page': 20,
          'total': 1,
        },
      }),
      queryParameters: {
        'page': 1,
        'per_page': 20,
      },
    );

    final repository = locator<MenuDisposalRepository>();
    final response = await repository.listMenuDisposals();

    expect(response.items, hasLength(1));
    expect(response.items.first.menuTitle, 'Nasi Goreng');
    expect(response.total, 1);
  });

  test('getMenuDisposal fetches single disposal', () async {
    adapter.onGet(
      '${MenuDisposalRepository.listPath}/disposal-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'disposal-1',
          'menu_title': 'Nasi Goreng',
          'quantity': 2,
          'loss_amount': 15000,
          'disposed_at': '2026-07-24T10:00:00Z',
          'disposed_by_username': 'Cashier Test',
          'note': 'Expired',
        },
      }),
    );

    final repository = locator<MenuDisposalRepository>();
    final response = await repository.getMenuDisposal('disposal-1');

    expect(response.id, 'disposal-1');
    expect(response.disposedByUsername, 'Cashier Test');
    expect(response.note, 'Expired');
  });
}
