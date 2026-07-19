import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  test('menu repository reuses cached response within TTL', () async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    final cache = ResourceCache();
    var calls = 0;

    mocked.adapter.onGet(
      MenuRepository.menusPath,
      (server) {
        calls++;
        return server.reply(200, {
          'success': true,
          'data': {'categories': []},
        });
      },
    );

    final repository = MenuRepository(mocked.client, cache);

    await repository.fetchPOSMenus();
    await repository.fetchPOSMenus();

    expect(calls, 1);
  });

  test('menu repository forceRefresh bypasses cache', () async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    final cache = ResourceCache();
    var calls = 0;

    void stubMenus() {
      mocked.adapter.onGet(
        MenuRepository.menusPath,
        (server) {
          calls++;
          return server.reply(200, {
            'success': true,
            'data': {'categories': []},
          });
        },
      );
    }

    stubMenus();
    stubMenus();

    final repository = MenuRepository(mocked.client, cache);

    await repository.fetchPOSMenus();
    await repository.fetchPOSMenus(forceRefresh: true);

    expect(calls, 2);
  });
}
