import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/order_option/data/order_option_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<OrderOptionRepository>(
        () => OrderOptionRepository(locator<ApiClient>()),
      );
  });

  test('fetchOrderOptions parses POS options list', () async {
    adapter.onGet(
      '/api/v1/pos/order-options',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'options': [
            {
              'id': '11111111-1111-1111-1111-111111111111',
              'name': 'Take Away',
              'priority': 10,
            },
          ],
        },
      }),
    );

    final options =
        await locator<OrderOptionRepository>().fetchOrderOptions();

    expect(options, hasLength(1));
    expect(options.first.id, '11111111-1111-1111-1111-111111111111');
    expect(options.first.name, 'Take Away');
    expect(options.first.priority, 10);
  });
}
