import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/smart_purchase_request.dart';
import 'package:luna_pos/features/purchase/smart_purchase_grouper.dart';

import '../helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator.registerSingleton<ApiClient>(mocked.client);
    locator.registerLazySingleton<PurchaseRequestRepository>(
      () => PurchaseRequestRepository(locator<ApiClient>()),
    );
  });

  test('smart request checklist: suggest then batch grouped payload', () async {
    const foodSupplyId = 'fs-1';
    const cheapSupplier = 'sup-cheap';
    const premiumSupplier = 'sup-premium';

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'all_items_matched': true,
          'items': [
            {
              'food_supply_id': foodSupplyId,
              'food_supply_title': 'Flour',
              'unit': 'gr',
              'quantity': '2',
              'has_supplier_price': true,
              'selected_supplier_id': cheapSupplier,
              'selected_supplier_name': 'Cheap Supplier',
              'supplier_price_id': 'price-cheap',
              'all_supplier_quotes': [
                {
                  'supplier_id': cheapSupplier,
                  'supplier_name': 'Cheap Supplier',
                  'supplier_price_id': 'price-cheap',
                  'price_amount': 100000,
                  'price_quantity': 1000,
                  'unit_price': 100,
                },
                {
                  'supplier_id': premiumSupplier,
                  'supplier_name': 'Premium Supplier',
                  'supplier_price_id': 'price-premium',
                  'price_amount': 150000,
                  'price_quantity': 1000,
                  'unit_price': 150,
                },
              ],
            },
          ],
          'grouped_by_supplier': [],
        },
      }),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '2'},
        ],
      },
    );

    final suggest = await locator<PurchaseRequestRepository>().suggest(
      items: const [
        SmartPurchaseSuggestInput(foodSupplyId: foodSupplyId, quantity: 2),
      ],
    );

    var reviewItems = reviewItemsFromSuggest(suggest);
    expect(reviewItems.first.selectedSupplierId, cheapSupplier);
    expect(reviewItems.first.lineTotal, 200);

    final overridden = reviewItems.first.withSupplierQuote(
      reviewItems.first.allSupplierQuotes.last,
    );
    reviewItems = [overridden];
    final groups = regroupSmartPurchaseItems(reviewItems);
    expect(groups.single.supplierId, premiumSupplier);
    expect(groups.single.groupTotal, 300);

    adapter.onPost(
      PurchaseRequestRepository.batchPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'purchase_requests': [
            {'id': 'pr-1', 'supplier_name': 'Premium Supplier'},
          ],
        },
      }),
      data: {
        'groups': [
          {
            'supplier_id': premiumSupplier,
            'items': [
              {'food_supply_id': foodSupplyId, 'quantity': '2'},
            ],
          },
        ],
      },
    );

    final batch = await locator<PurchaseRequestRepository>().batchCreate(
      groups: buildBatchGroups(groups),
    );

    expect(batch.purchaseRequests.single.id, 'pr-1');
  });
}
