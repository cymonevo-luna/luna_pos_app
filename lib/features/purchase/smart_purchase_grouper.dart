import '../stock/models/food_supply_supplier_price.dart';
import 'models/smart_purchase_request.dart';
import 'purchase_request_estimator.dart';

class SmartPurchaseReviewItem {
  SmartPurchaseReviewItem({
    required this.foodSupplyId,
    required this.foodSupplyTitle,
    required this.unit,
    required this.quantity,
    required this.allSupplierQuotes,
    this.selectedSupplierId,
    this.selectedSupplierName,
    this.supplierPriceId,
    this.priceAmount,
    this.priceQuantity,
    this.unitPrice,
    this.hasSupplierPrice = true,
  });

  final String foodSupplyId;
  final String foodSupplyTitle;
  final String unit;
  final num quantity;
  final List<SmartPurchaseSupplierQuote> allSupplierQuotes;
  final bool hasSupplierPrice;
  final String? selectedSupplierId;
  final String? selectedSupplierName;
  final String? supplierPriceId;
  final int? priceAmount;
  final num? priceQuantity;
  final num? unitPrice;

  bool get isMatched =>
      selectedSupplierId != null &&
      selectedSupplierId!.isNotEmpty &&
      supplierPriceId != null &&
      supplierPriceId!.isNotEmpty;

  int get lineTotal {
    if (priceAmount != null && priceQuantity != null) {
      return estimateLineTotal(
        quantity: quantity,
        priceAmount: priceAmount!,
        priceQuantity: priceQuantity!,
      );
    }
    if (unitPrice != null) {
      return roundHalfUp(quantity * unitPrice!);
    }
    return 0;
  }

  SmartPurchaseReviewItem copyWith({
    String? selectedSupplierId,
    String? selectedSupplierName,
    String? supplierPriceId,
    int? priceAmount,
    num? priceQuantity,
    num? unitPrice,
    bool? hasSupplierPrice,
    List<SmartPurchaseSupplierQuote>? allSupplierQuotes,
  }) {
    return SmartPurchaseReviewItem(
      foodSupplyId: foodSupplyId,
      foodSupplyTitle: foodSupplyTitle,
      unit: unit,
      quantity: quantity,
      allSupplierQuotes: allSupplierQuotes ?? this.allSupplierQuotes,
      hasSupplierPrice: hasSupplierPrice ?? this.hasSupplierPrice,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      selectedSupplierName: selectedSupplierName ?? this.selectedSupplierName,
      supplierPriceId: supplierPriceId ?? this.supplierPriceId,
      priceAmount: priceAmount ?? this.priceAmount,
      priceQuantity: priceQuantity ?? this.priceQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  factory SmartPurchaseReviewItem.fromSuggestItem(SmartPurchaseSuggestItem item) {
  final selectedQuote = _quoteForSupplier(
    item.allSupplierQuotes,
    item.selectedSupplierId,
  );

    return SmartPurchaseReviewItem(
      foodSupplyId: item.foodSupplyId,
      foodSupplyTitle: item.foodSupplyTitle,
      unit: item.unit,
      quantity: item.quantity,
      allSupplierQuotes: item.allSupplierQuotes,
      hasSupplierPrice: item.hasSupplierPrice,
      selectedSupplierId: item.selectedSupplierId,
      selectedSupplierName: item.selectedSupplierName,
      supplierPriceId: item.supplierPriceId ?? selectedQuote?.supplierPriceId,
      priceAmount: selectedQuote?.priceAmount,
      priceQuantity: selectedQuote?.priceQuantity,
      unitPrice: selectedQuote?.unitPrice,
    );
  }

  SmartPurchaseReviewItem withSupplierQuote(SmartPurchaseSupplierQuote quote) {
    return copyWith(
      selectedSupplierId: quote.supplierId,
      selectedSupplierName: quote.supplierName,
      supplierPriceId: quote.supplierPriceId,
      priceAmount: quote.priceAmount,
      priceQuantity: quote.priceQuantity,
      unitPrice: quote.unitPrice,
      hasSupplierPrice: true,
    );
  }

  SmartPurchaseReviewItem withManualSupplierPrice(
    FoodSupplySupplierPrice price,
  ) {
    final quote = SmartPurchaseSupplierQuote(
      supplierId: price.supplierId,
      supplierName: price.supplierName,
      supplierPriceId: price.supplierPriceId,
      priceAmount: price.priceAmount,
      priceQuantity: price.priceQuantity,
      unitPrice: price.unitPrice,
    );

    final mergedQuotes = <SmartPurchaseSupplierQuote>[
      for (final existing in allSupplierQuotes)
        if (existing.supplierId != quote.supplierId) existing,
      quote,
    ];

    return withSupplierQuote(quote).copyWith(allSupplierQuotes: mergedQuotes);
  }
}

class SmartPurchaseSupplierGroupView {
  SmartPurchaseSupplierGroupView({
    required this.supplierId,
    required this.supplierName,
    required this.items,
  });

  final String supplierId;
  final String supplierName;
  final List<SmartPurchaseReviewItem> items;

  int get groupTotal =>
      items.fold(0, (sum, item) => sum + item.lineTotal);
}

SmartPurchaseSupplierQuote? _quoteForSupplier(
  List<SmartPurchaseSupplierQuote> quotes,
  String? supplierId,
) {
  if (supplierId == null) return null;
  for (final quote in quotes) {
    if (quote.supplierId == supplierId) return quote;
  }
  return null;
}

List<SmartPurchaseReviewItem> reviewItemsFromSuggest(
  SmartPurchaseSuggestResponse response,
) =>
    response.items.map(SmartPurchaseReviewItem.fromSuggestItem).toList();

List<SmartPurchaseSupplierGroupView> regroupSmartPurchaseItems(
  List<SmartPurchaseReviewItem> items,
) {
  final groups = <String, SmartPurchaseSupplierGroupView>{};

  for (final item in items) {
    final supplierId = item.selectedSupplierId;
    if (supplierId == null || supplierId.isEmpty) continue;

    final existing = groups[supplierId];
    if (existing == null) {
      groups[supplierId] = SmartPurchaseSupplierGroupView(
        supplierId: supplierId,
        supplierName: item.selectedSupplierName ?? '',
        items: [item],
      );
      continue;
    }

    groups[supplierId] = SmartPurchaseSupplierGroupView(
      supplierId: supplierId,
      supplierName: existing.supplierName,
      items: [...existing.items, item],
    );
  }

  final sorted = groups.values.toList()
    ..sort((a, b) => a.supplierName.compareTo(b.supplierName));

  for (final group in sorted) {
    group.items.sort((a, b) => a.foodSupplyTitle.compareTo(b.foodSupplyTitle));
  }

  return sorted;
}

List<SmartPurchaseBatchGroupInput> buildBatchGroups(
  List<SmartPurchaseSupplierGroupView> groups,
) =>
    groups
        .map(
          (group) => SmartPurchaseBatchGroupInput(
            supplierId: group.supplierId,
            items: group.items
                .map(
                  (item) => SmartPurchaseSuggestInput(
                    foodSupplyId: item.foodSupplyId,
                    quantity: item.quantity,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

bool allSmartPurchaseItemsMatched(List<SmartPurchaseReviewItem> items) =>
    items.every((item) => item.isMatched);
