import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
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
      ..registerSingleton<ResourceCache>(ResourceCache())
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), locator<ResourceCache>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('loadIfNeeded skips repeat fetch within cache TTL', () async {
    var calls = 0;
    adapter.onGet(
      MenuRepository.menusPath,
      (server) {
        calls++;
        return server.reply(200, {
          'success': true,
          'data': {'categories': []},
        });
      },
    );

    final notifier = container.read(menuProvider.notifier);
    await notifier.loadIfNeeded();
    await notifier.loadIfNeeded();

    expect(calls, 1);
  });

  test('refresh bypasses controller and repository cache', () async {
    var calls = 0;
    adapter.onGet(
      MenuRepository.menusPath,
      (server) {
        calls++;
        return server.reply(200, {
          'success': true,
          'data': {'categories': []},
        });
      },
    );
    adapter.onGet(
      MenuRepository.menusPath,
      (server) {
        calls++;
        return server.reply(200, {
          'success': true,
          'data': {'categories': []},
        });
      },
    );

    final notifier = container.read(menuProvider.notifier);
    await notifier.loadIfNeeded();
    await notifier.refresh();

    expect(calls, 2);
  });
}
