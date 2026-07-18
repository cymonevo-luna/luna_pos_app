// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_supply_supplier_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSupplySupplierPrice _$FoodSupplySupplierPriceFromJson(
  Map<String, dynamic> json,
) => _FoodSupplySupplierPrice(
  supplierId: json['supplier_id'] as String,
  supplierName: json['supplier_name'] as String,
  supplierPriceId: json['supplier_price_id'] as String,
  priceAmount: (json['price_amount'] as num).toInt(),
  priceQuantity: _decimalFromJson(json['price_quantity']),
  unitPrice: _decimalFromJson(json['unit_price']),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$FoodSupplySupplierPriceToJson(
  _FoodSupplySupplierPrice instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'supplier_name': instance.supplierName,
  'supplier_price_id': instance.supplierPriceId,
  'price_amount': instance.priceAmount,
  'price_quantity': instance.priceQuantity,
  'unit_price': instance.unitPrice,
  'unit': instance.unit,
};
