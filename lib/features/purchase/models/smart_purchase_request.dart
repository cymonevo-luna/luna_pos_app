import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_purchase_request.freezed.dart';
part 'smart_purchase_request.g.dart';

num _quantityFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid quantity: $value');
}

num _decimalFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid decimal: $value');
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid int: $value');
}

@freezed
abstract class SmartPurchaseSuggestInput with _$SmartPurchaseSuggestInput {
  const factory SmartPurchaseSuggestInput({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)
    required num quantity,
  }) = _SmartPurchaseSuggestInput;

  factory SmartPurchaseSuggestInput.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseSuggestInputFromJson(json);
}

String _quantityToJson(num value) => value.toString();

@freezed
abstract class SmartPurchaseSupplierQuote with _$SmartPurchaseSupplierQuote {
  const factory SmartPurchaseSupplierQuote({
    @JsonKey(name: 'supplier_id') required String supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'supplier_price_id') required String supplierPriceId,
    @JsonKey(name: 'price_amount') required int priceAmount,
    @JsonKey(
      name: 'price_quantity',
      fromJson: _decimalFromJson,
    )
    required num priceQuantity,
    @JsonKey(name: 'unit_price', fromJson: _decimalFromJson) required num unitPrice,
  }) = _SmartPurchaseSupplierQuote;

  factory SmartPurchaseSupplierQuote.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseSupplierQuoteFromJson(json);
}

@freezed
abstract class SmartPurchaseSuggestItem with _$SmartPurchaseSuggestItem {
  const factory SmartPurchaseSuggestItem({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(name: 'food_supply_title') required String foodSupplyTitle,
    required String unit,
    @JsonKey(fromJson: _quantityFromJson) required num quantity,
    @JsonKey(name: 'has_supplier_price') required bool hasSupplierPrice,
    @JsonKey(name: 'selected_supplier_id') String? selectedSupplierId,
    @JsonKey(name: 'selected_supplier_name') String? selectedSupplierName,
    @JsonKey(name: 'supplier_price_id') String? supplierPriceId,
    @JsonKey(name: 'all_supplier_quotes')
    @Default([])
    List<SmartPurchaseSupplierQuote> allSupplierQuotes,
  }) = _SmartPurchaseSuggestItem;

  factory SmartPurchaseSuggestItem.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseSuggestItemFromJson(json);
}

@freezed
abstract class SmartPurchaseSupplierGroup with _$SmartPurchaseSupplierGroup {
  const factory SmartPurchaseSupplierGroup({
    @JsonKey(name: 'supplier_id') required String supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson)
    int? totalEstimatedAmount,
    @Default([]) List<SmartPurchaseGroupedItem> items,
  }) = _SmartPurchaseSupplierGroup;

  factory SmartPurchaseSupplierGroup.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseSupplierGroupFromJson(json);
}

@freezed
abstract class SmartPurchaseGroupedItem with _$SmartPurchaseGroupedItem {
  const factory SmartPurchaseGroupedItem({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(name: 'food_supply_title') required String foodSupplyTitle,
    required String unit,
    @JsonKey(fromJson: _quantityFromJson) required num quantity,
    @JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) int? unitPrice,
    @JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) int? lineTotal,
    @JsonKey(name: 'supplier_price_id') String? supplierPriceId,
  }) = _SmartPurchaseGroupedItem;

  factory SmartPurchaseGroupedItem.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseGroupedItemFromJson(json);
}

@freezed
abstract class SmartPurchaseSuggestResponse with _$SmartPurchaseSuggestResponse {
  const factory SmartPurchaseSuggestResponse({
    @JsonKey(name: 'all_items_matched') required bool allItemsMatched,
    @Default([]) List<SmartPurchaseSuggestItem> items,
    @JsonKey(name: 'grouped_by_supplier')
    @Default([])
    List<SmartPurchaseSupplierGroup> groupedBySupplier,
  }) = _SmartPurchaseSuggestResponse;

  factory SmartPurchaseSuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseSuggestResponseFromJson(json);
}

@freezed
abstract class SmartPurchaseBatchGroupInput with _$SmartPurchaseBatchGroupInput {
  const factory SmartPurchaseBatchGroupInput({
    @JsonKey(name: 'supplier_id') required String supplierId,
    required List<SmartPurchaseSuggestInput> items,
  }) = _SmartPurchaseBatchGroupInput;

  factory SmartPurchaseBatchGroupInput.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseBatchGroupInputFromJson(json);
}

@freezed
abstract class SmartPurchaseBatchResponse with _$SmartPurchaseBatchResponse {
  const factory SmartPurchaseBatchResponse({
    @JsonKey(name: 'purchase_requests')
    @Default([])
    List<SmartPurchaseBatchCreatedRequest> purchaseRequests,
  }) = _SmartPurchaseBatchResponse;

  factory SmartPurchaseBatchResponse.fromJson(Map<String, dynamic> json) =>
      _$SmartPurchaseBatchResponseFromJson(json);
}

@freezed
abstract class SmartPurchaseBatchCreatedRequest
    with _$SmartPurchaseBatchCreatedRequest {
  const factory SmartPurchaseBatchCreatedRequest({
    required String id,
    @JsonKey(name: 'supplier_name') required String supplierName,
  }) = _SmartPurchaseBatchCreatedRequest;

  factory SmartPurchaseBatchCreatedRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SmartPurchaseBatchCreatedRequestFromJson(json);
}
