import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/supplier_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<SupplierRepository>(
        () => SupplierRepository(locator<ApiClient>()),
      );
  });

  test('get loads supplier price quotes', () async {
    adapter.onGet(
      '${SupplierRepository.listPath}/sup-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'sup-1',
          'name': 'Toko Sembako Jaya',
          'price_quotes': [
            {
              'food_supply_id': 'fs-1',
              'food_supply_title': 'Flour',
              'unit': 'gr',
              'price_amount': 140000,
              'price_quantity': 1000,
              'unit_price': 140,
            },
            {
              'food_supply_id': 'fs-2',
              'food_supply_title': 'Sugar',
              'unit': 'gr',
              'price_amount': 90000,
              'price_quantity': 1000,
              'unit_price': 90,
            },
          ],
        },
      }),
    );

    final supplier = await locator<SupplierRepository>().get('sup-1');

    expect(supplier.name, 'Toko Sembako Jaya');
    expect(supplier.priceQuotes, hasLength(2));
    expect(supplier.priceQuotes.first.foodSupplyTitle, 'Flour');
    expect(supplier.priceQuotes.last.foodSupplyTitle, 'Sugar');
  });
}
