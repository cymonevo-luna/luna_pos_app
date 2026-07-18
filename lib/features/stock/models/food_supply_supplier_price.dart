import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_supply_supplier_price.freezed.dart';
part 'food_supply_supplier_price.g.dart';

num _decimalFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid decimal: $value');
}

@freezed
abstract class FoodSupplySupplierPrice with _$FoodSupplySupplierPrice {
  const factory FoodSupplySupplierPrice({
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
    required String unit,
  }) = _FoodSupplySupplierPrice;

  factory FoodSupplySupplierPrice.fromJson(Map<String, dynamic> json) =>
      _$FoodSupplySupplierPriceFromJson(json);
}
