import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_controller.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';
import 'package:luna_pos/features/menu_disposal/dispose_food_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';

import 'helpers/auth_harness.dart';

void main() {
  test('submit invalidates menu cache after successful disposal', () async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    final adapter = mocked.adapter;

    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerSingleton<ResourceCache>(testResourceCache())
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), locator<ResourceCache>()),
      )
      ..registerLazySingleton<MenuDisposalRepository>(
        () => MenuDisposalRepository(
          locator<ApiClient>(),
          locator<ResourceCache>(),
        ),
      );

    adapter.onPost(
      MenuDisposalRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'disposal-1',
          'menu_title': 'Nasi Goreng',
          'quantity': 2,
          'loss_amount': 70000,
          'disposed_at': '2026-07-24T10:00:00Z',
        },
      }),
      data: {
        'menu_id': 'menu-1',
        'quantity': 2,
      },
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(disposeFoodProvider.notifier).selectMenu(
          const POSMenuItem(
            id: 'menu-1',
            title: 'Nasi Goreng',
            availableStock: 5,
            sellPrice: 35000,
          ),
        );

    await container.read(disposeFoodProvider.notifier).submit();

    final menuState = container.read(menuProvider);
    expect(menuState.data, isNull);
    expect(locator<MenuRepository>(), isNotNull);
  });
}
