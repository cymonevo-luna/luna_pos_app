import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/smart_purchase_request.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<FoodSupplyRepository>(
        () => FoodSupplyRepository(locator<ApiClient>()),
      );
  });

  test('suggest posts ingredient rows and parses response', () async {
    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'all_items_matched': true,
          'items': [
            {
              'food_supply_id': 'fs-1',
              'food_supply_title': 'Flour',
              'unit': 'gr',
              'quantity': '1000',
              'has_supplier_price': true,
              'selected_supplier_id': 'sup-cheap',
              'selected_supplier_name': 'Cheap Supplier',
              'supplier_price_id': 'price-1',
              'all_supplier_quotes': [
                {
                  'supplier_id': 'sup-cheap',
                  'supplier_name': 'Cheap Supplier',
                  'supplier_price_id': 'price-1',
                  'price_amount': 100000,
                  'price_quantity': 1000,
                  'unit_price': 100,
                },
                {
                  'supplier_id': 'sup-expensive',
                  'supplier_name': 'Premium Supplier',
                  'supplier_price_id': 'price-2',
                  'price_amount': 150000,
                  'price_quantity': 1000,
                  'unit_price': 150,
                },
              ],
            },
          ],
          'grouped_by_supplier': [
            {
              'supplier_id': 'sup-cheap',
              'supplier_name': 'Cheap Supplier',
              'total_estimated_amount': 100000,
              'items': [
                {
                  'food_supply_id': 'fs-1',
                  'food_supply_title': 'Flour',
                  'unit': 'gr',
                  'quantity': '1000',
                  'unit_price': 100,
                  'line_total': 100000,
                  'supplier_price_id': 'price-1',
                },
              ],
            },
          ],
        },
      }),
      data: {
        'items': [
          {'food_supply_id': 'fs-1', 'quantity': '1000'},
          {'food_supply_id': 'fs-2', 'quantity': '2'},
        ],
      },
    );

    final response = await locator<PurchaseRequestRepository>().suggest(
      items: const [
        SmartPurchaseSuggestInput(foodSupplyId: 'fs-1', quantity: 1000),
        SmartPurchaseSuggestInput(foodSupplyId: 'fs-2', quantity: 2),
      ],
    );

    expect(response.allItemsMatched, isTrue);
    expect(response.items, hasLength(1));
    expect(response.items.first.selectedSupplierId, 'sup-cheap');
    expect(response.items.first.allSupplierQuotes, hasLength(2));
    expect(response.groupedBySupplier, hasLength(1));
  });

  test('batchCreate posts grouped payload with optional notes', () async {
    adapter.onPost(
      PurchaseRequestRepository.batchPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'purchase_requests': [
            {
              'id': 'pr-1',
              'supplier_name': 'Cheap Supplier',
            },
          ],
        },
      }),
      data: {
        'groups': [
          {
            'supplier_id': 'sup-cheap',
            'items': [
              {'food_supply_id': 'fs-1', 'quantity': '1000'},
            ],
          },
        ],
        'notes': 'weekly restock',
      },
    );

    final response = await locator<PurchaseRequestRepository>().batchCreate(
      groups: const [
        SmartPurchaseBatchGroupInput(
          supplierId: 'sup-cheap',
          items: [
            SmartPurchaseBatchItemInput(foodSupplyId: 'fs-1', quantity: 1000),
          ],
        ),
      ],
      notes: 'weekly restock',
    );

    expect(response.purchaseRequests, hasLength(1));
    expect(response.purchaseRequests.first.id, 'pr-1');
  });

  test('batchCreate posts optional actual and catalog update fields', () async {
    adapter.onPost(
      PurchaseRequestRepository.batchPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'purchase_requests': [
            {
              'id': 'pr-1',
              'supplier_name': 'Cheap Supplier',
            },
          ],
        },
      }),
      data: {
        'groups': [
          {
            'supplier_id': 'sup-cheap',
            'items': [
              {
                'food_supply_id': 'fs-1',
                'quantity': '1000',
                'line_actual_amount': 95000,
                'supplier_price_update': {
                  'price_amount': 95000,
                  'price_quantity': '1000',
                },
              },
            ],
          },
        ],
      },
    );

    final response = await locator<PurchaseRequestRepository>().batchCreate(
      groups: const [
        SmartPurchaseBatchGroupInput(
          supplierId: 'sup-cheap',
          items: [
            SmartPurchaseBatchItemInput(
              foodSupplyId: 'fs-1',
              quantity: 1000,
              lineActualAmount: 95000,
              supplierPriceUpdate: SmartPurchaseSupplierPriceUpdate(
                priceAmount: 95000,
                priceQuantity: 1000,
              ),
            ),
          ],
        ),
      ],
    );

    expect(response.purchaseRequests, hasLength(1));
  });

  test('fetchSupplierPrices parses supplier price list', () async {
    adapter.onGet(
      '/api/admin/food-supplies/fs-1/supplier-prices',
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'supplier_id': 'sup-1',
            'supplier_name': 'Supplier A',
            'supplier_price_id': 'price-1',
            'price_amount': 120000,
            'price_quantity': 1000,
            'unit_price': 120,
            'unit': 'gr',
          },
        ],
      }),
    );

    final prices =
        await locator<FoodSupplyRepository>().fetchSupplierPrices('fs-1');

    expect(prices, hasLength(1));
    expect(prices.first.supplierName, 'Supplier A');
    expect(prices.first.unit, 'gr');
  });
}
