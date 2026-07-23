import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/purchase/models/smart_purchase_request.dart';
import 'package:luna_pos/features/purchase/smart_purchase_grouper.dart';
import 'package:luna_pos/features/stock/models/food_supply_supplier_price.dart';

void main() {
  SmartPurchaseReviewItem reviewItem({
    required String foodSupplyId,
    required String title,
    required List<SmartPurchaseSupplierQuote> quotes,
    String? selectedSupplierId,
  }) {
    final selected = quotes.firstWhere(
      (quote) => quote.supplierId == selectedSupplierId,
      orElse: () => quotes.first,
    );

    return SmartPurchaseReviewItem(
      foodSupplyId: foodSupplyId,
      foodSupplyTitle: title,
      unit: 'gr',
      quantity: 1000,
      allSupplierQuotes: quotes,
      selectedSupplierId: selectedSupplierId ?? selected.supplierId,
      selectedSupplierName: selected.supplierName,
      supplierPriceId: selected.supplierPriceId,
      priceAmount: selected.priceAmount,
      priceQuantity: selected.priceQuantity,
      unitPrice: selected.unitPrice,
      hasSupplierPrice: true,
    );
  }

  const cheapQuote = SmartPurchaseSupplierQuote(
    supplierId: 'sup-cheap',
    supplierName: 'Cheap Supplier',
    supplierPriceId: 'price-cheap',
    priceAmount: 100000,
    priceQuantity: 1000,
    unitPrice: 100,
  );

  const premiumQuote = SmartPurchaseSupplierQuote(
    supplierId: 'sup-premium',
    supplierName: 'Premium Supplier',
    supplierPriceId: 'price-premium',
    priceAmount: 150000,
    priceQuantity: 1000,
    unitPrice: 150,
  );

  test('regroupSmartPurchaseItems groups by selected supplier', () {
    final items = [
      reviewItem(
        foodSupplyId: 'fs-1',
        title: 'Flour',
        quotes: const [cheapQuote, premiumQuote],
        selectedSupplierId: 'sup-cheap',
      ),
      reviewItem(
        foodSupplyId: 'fs-2',
        title: 'Sugar',
        quotes: const [cheapQuote, premiumQuote],
        selectedSupplierId: 'sup-premium',
      ),
    ];

    final groups = regroupSmartPurchaseItems(items);

    expect(groups, hasLength(2));
    expect(groups[0].supplierId, 'sup-cheap');
    expect(groups[0].items, hasLength(1));
    expect(groups[0].groupTotal, 100000);
    expect(groups[1].supplierId, 'sup-premium');
    expect(groups[1].groupTotal, 150000);
  });

  test('supplier override moves item to new group and updates total', () {
    final item = reviewItem(
      foodSupplyId: 'fs-1',
      title: 'Flour',
      quotes: const [cheapQuote, premiumQuote],
      selectedSupplierId: 'sup-cheap',
    );

    final updated = item.withSupplierQuote(premiumQuote);
    final groups = regroupSmartPurchaseItems([updated]);

    expect(groups, hasLength(1));
    expect(groups.first.supplierId, 'sup-premium');
    expect(groups.first.groupTotal, 150000);
  });

  test('manual supplier price marks item matched for confirm', () {
    final item = SmartPurchaseReviewItem(
      foodSupplyId: 'fs-1',
      foodSupplyTitle: 'Salt',
      unit: 'gr',
      quantity: 500,
      allSupplierQuotes: const [],
      hasSupplierPrice: false,
    );

    expect(item.isMatched, isFalse);

    final updated = item.withManualSupplierPrice(
      const FoodSupplySupplierPrice(
        supplierId: 'sup-manual',
        supplierName: 'Manual Supplier',
        supplierPriceId: 'price-manual',
        priceAmount: 50000,
        priceQuantity: 500,
        unitPrice: 100,
        unit: 'gr',
      ),
    );

    expect(updated.isMatched, isTrue);
    expect(allSmartPurchaseItemsMatched([updated]), isTrue);
  });

  test('buildBatchGroups maps review groups to API payload', () {
    final groups = regroupSmartPurchaseItems([
      reviewItem(
        foodSupplyId: 'fs-1',
        title: 'Flour',
        quotes: const [cheapQuote],
        selectedSupplierId: 'sup-cheap',
      ),
    ]);

    final payload = buildBatchGroups(groups);

    expect(payload, hasLength(1));
    expect(payload.first.supplierId, 'sup-cheap');
    expect(payload.first.items.first.foodSupplyId, 'fs-1');
    expect(payload.first.items.first.quantity, 1000);
    expect(payload.first.items.first.lineActualAmount, isNull);
    expect(payload.first.items.first.supplierPriceUpdate, isNull);
  });

  test('buildBatchGroups includes optional actual and catalog update fields', () {
    final item = reviewItem(
      foodSupplyId: 'fs-1',
      title: 'Flour',
      quotes: const [cheapQuote],
      selectedSupplierId: 'sup-cheap',
    ).copyWith(
      lineActualAmount: 95000,
      catalogUpdateEnabled: true,
      catalogUpdatePriceAmount: 95000,
      catalogUpdatePriceQuantity: 1000,
    );
    final groups = regroupSmartPurchaseItems([item]);

    final payload = buildBatchGroups(groups);

    expect(payload.first.items.first.lineActualAmount, 95000);
    expect(payload.first.items.first.supplierPriceUpdate?.priceAmount, 95000);
    expect(payload.first.items.first.supplierPriceUpdate?.priceQuantity, 1000);
  });

  test('lineTotal uses actual amount when present', () {
    final item = reviewItem(
      foodSupplyId: 'fs-1',
      title: 'Flour',
      quotes: const [cheapQuote],
      selectedSupplierId: 'sup-cheap',
    ).copyWith(lineActualAmount: 88000);

    expect(item.estimatedLineTotal, 100000);
    expect(item.lineTotal, 88000);
  });

  test('supplier override resets catalog update defaults', () {
    final item = reviewItem(
      foodSupplyId: 'fs-1',
      title: 'Flour',
      quotes: const [cheapQuote, premiumQuote],
      selectedSupplierId: 'sup-cheap',
    ).copyWith(
      catalogUpdateEnabled: true,
      catalogUpdatePriceAmount: 90000,
      catalogUpdatePriceQuantity: 1000,
    );

    final updated = item.withSupplierQuote(premiumQuote);

    expect(updated.catalogUpdateEnabled, isFalse);
    expect(updated.catalogUpdatePriceAmount, premiumQuote.priceAmount);
    expect(updated.catalogUpdatePriceQuantity, premiumQuote.priceQuantity);
  });
}
