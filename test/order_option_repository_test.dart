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

    expect(response.options, hasLength(2));
    expect(response.options.first.id, kTestOrderOptionTakeAwayId);
    expect(response.options.first.name, 'Take Away');
    expect(response.options.first.priority, 10);
  });

  test('fetchOrderOptions handles empty list', () async {
    stubEmptyOrderOptions(adapter);

    final response =
        await locator<OrderOptionRepository>().fetchOrderOptions();

    expect(response.options, isEmpty);
  });
}
