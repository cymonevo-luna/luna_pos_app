// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmartPurchaseSuggestInput _$SmartPurchaseSuggestInputFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseSuggestInput(
  foodSupplyId: json['food_supply_id'] as String,
  quantity: _quantityFromJson(json['quantity']),
);

Map<String, dynamic> _$SmartPurchaseSuggestInputToJson(
  _SmartPurchaseSuggestInput instance,
) => <String, dynamic>{
  'food_supply_id': instance.foodSupplyId,
  'quantity': _quantityToJson(instance.quantity),
};

_SmartPurchaseSupplierQuote _$SmartPurchaseSupplierQuoteFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseSupplierQuote(
  supplierId: json['supplier_id'] as String,
  supplierName: json['supplier_name'] as String,
  supplierPriceId: json['supplier_price_id'] as String,
  priceAmount: (json['price_amount'] as num).toInt(),
  priceQuantity: _decimalFromJson(json['price_quantity']),
  unitPrice: _decimalFromJson(json['unit_price']),
);

Map<String, dynamic> _$SmartPurchaseSupplierQuoteToJson(
  _SmartPurchaseSupplierQuote instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'supplier_name': instance.supplierName,
  'supplier_price_id': instance.supplierPriceId,
  'price_amount': instance.priceAmount,
  'price_quantity': instance.priceQuantity,
  'unit_price': instance.unitPrice,
};

_SmartPurchaseSuggestItem _$SmartPurchaseSuggestItemFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseSuggestItem(
  foodSupplyId: json['food_supply_id'] as String,
  foodSupplyTitle: json['food_supply_title'] as String,
  unit: json['unit'] as String,
  quantity: _quantityFromJson(json['quantity']),
  hasSupplierPrice: json['has_supplier_price'] as bool,
  selectedSupplierId: json['selected_supplier_id'] as String?,
  selectedSupplierName: json['selected_supplier_name'] as String?,
  supplierPriceId: json['supplier_price_id'] as String?,
  allSupplierQuotes:
      (json['all_supplier_quotes'] as List<dynamic>?)
          ?.map(
            (e) =>
                SmartPurchaseSupplierQuote.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SmartPurchaseSuggestItemToJson(
  _SmartPurchaseSuggestItem instance,
) => <String, dynamic>{
  'food_supply_id': instance.foodSupplyId,
  'food_supply_title': instance.foodSupplyTitle,
  'unit': instance.unit,
  'quantity': instance.quantity,
  'has_supplier_price': instance.hasSupplierPrice,
  'selected_supplier_id': instance.selectedSupplierId,
  'selected_supplier_name': instance.selectedSupplierName,
  'supplier_price_id': instance.supplierPriceId,
  'all_supplier_quotes': instance.allSupplierQuotes,
};

_SmartPurchaseSupplierGroup _$SmartPurchaseSupplierGroupFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseSupplierGroup(
  supplierId: json['supplier_id'] as String,
  supplierName: json['supplier_name'] as String,
  totalEstimatedAmount: _nullableIntFromJson(json['total_estimated_amount']),
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => SmartPurchaseGroupedItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SmartPurchaseSupplierGroupToJson(
  _SmartPurchaseSupplierGroup instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'supplier_name': instance.supplierName,
  'total_estimated_amount': instance.totalEstimatedAmount,
  'items': instance.items,
};

_SmartPurchaseGroupedItem _$SmartPurchaseGroupedItemFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseGroupedItem(
  foodSupplyId: json['food_supply_id'] as String,
  foodSupplyTitle: json['food_supply_title'] as String,
  unit: json['unit'] as String,
  quantity: _quantityFromJson(json['quantity']),
  unitPrice: _nullableIntFromJson(json['unit_price']),
  lineTotal: _nullableIntFromJson(json['line_total']),
  supplierPriceId: json['supplier_price_id'] as String?,
);

Map<String, dynamic> _$SmartPurchaseGroupedItemToJson(
  _SmartPurchaseGroupedItem instance,
) => <String, dynamic>{
  'food_supply_id': instance.foodSupplyId,
  'food_supply_title': instance.foodSupplyTitle,
  'unit': instance.unit,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
  'line_total': instance.lineTotal,
  'supplier_price_id': instance.supplierPriceId,
};

_SmartPurchaseSuggestResponse _$SmartPurchaseSuggestResponseFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseSuggestResponse(
  allItemsMatched: json['all_items_matched'] as bool,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => SmartPurchaseSuggestItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  groupedBySupplier:
      (json['grouped_by_supplier'] as List<dynamic>?)
          ?.map(
            (e) =>
                SmartPurchaseSupplierGroup.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SmartPurchaseSuggestResponseToJson(
  _SmartPurchaseSuggestResponse instance,
) => <String, dynamic>{
  'all_items_matched': instance.allItemsMatched,
  'items': instance.items,
  'grouped_by_supplier': instance.groupedBySupplier,
};

_SmartPurchaseBatchGroupInput _$SmartPurchaseBatchGroupInputFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseBatchGroupInput(
  supplierId: json['supplier_id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => SmartPurchaseSuggestInput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SmartPurchaseBatchGroupInputToJson(
  _SmartPurchaseBatchGroupInput instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'items': instance.items,
};

_SmartPurchaseBatchResponse _$SmartPurchaseBatchResponseFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseBatchResponse(
  purchaseRequests:
      (json['purchase_requests'] as List<dynamic>?)
          ?.map(
            (e) => SmartPurchaseBatchCreatedRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SmartPurchaseBatchResponseToJson(
  _SmartPurchaseBatchResponse instance,
) => <String, dynamic>{'purchase_requests': instance.purchaseRequests};

_SmartPurchaseBatchCreatedRequest _$SmartPurchaseBatchCreatedRequestFromJson(
  Map<String, dynamic> json,
) => _SmartPurchaseBatchCreatedRequest(
  id: json['id'] as String,
  supplierName: json['supplier_name'] as String,
);

Map<String, dynamic> _$SmartPurchaseBatchCreatedRequestToJson(
  _SmartPurchaseBatchCreatedRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'supplier_name': instance.supplierName,
};
