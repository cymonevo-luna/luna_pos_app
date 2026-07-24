import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/order/data/order_option_repository.dart';

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
        () => OrderOptionRepository(locator<ApiClient>(), testResourceCache()),
      );
  });

  test('fetchOrderOptions parses and repository returns options', () async {
    stubOrderOptions(adapter);

    final response =
        await locator<OrderOptionRepository>().fetchOrderOptions();

    expect(response.options, hasLength(3));
    expect(response.options.first.id, kTestOrderOptionTakeAwayId);
    expect(response.options.first.name, 'Take Away');
    expect(response.options.first.priority, 10);
    expect(response.options.first.additionalPrice, 0);
  });

  test('fetchOrderOptions deserializes additional_price', () async {
    adapter.onGet(
      '/api/v1/pos/order-options',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'options': [
            {
              'id': '1',
              'name': 'Box',
              'priority': 1,
              'additional_price': 3000,
            },
          ],
        },
      }),
    );

    final response =
        await locator<OrderOptionRepository>().fetchOrderOptions();

    expect(response.options, hasLength(1));
    expect(response.options.first.additionalPrice, 3000);
  });

  test('fetchOrderOptions handles empty list', () async {
    stubEmptyOrderOptions(adapter);

    final response =
        await locator<OrderOptionRepository>().fetchOrderOptions();

    expect(response.options, isEmpty);
  });
}
