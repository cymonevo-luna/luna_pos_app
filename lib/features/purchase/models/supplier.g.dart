// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupplierSummary _$SupplierSummaryFromJson(Map<String, dynamic> json) =>
    _SupplierSummary(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$SupplierSummaryToJson(_SupplierSummary instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_PriceQuote _$PriceQuoteFromJson(Map<String, dynamic> json) => _PriceQuote(
  foodSupplyId: json['food_supply_id'] as String,
  foodSupplyTitle: json['food_supply_title'] as String,
  unit: json['unit'] as String,
  priceAmount: (json['price_amount'] as num).toInt(),
  priceQuantity: _decimalFromJson(json['price_quantity']),
  unitPrice: _nullableDecimalFromJson(json['unit_price']),
);

Map<String, dynamic> _$PriceQuoteToJson(_PriceQuote instance) =>
    <String, dynamic>{
      'food_supply_id': instance.foodSupplyId,
      'food_supply_title': instance.foodSupplyTitle,
      'unit': instance.unit,
      'price_amount': instance.priceAmount,
      'price_quantity': instance.priceQuantity,
      'unit_price': instance.unitPrice,
    };

_Supplier _$SupplierFromJson(Map<String, dynamic> json) => _Supplier(
  id: json['id'] as String,
  name: json['name'] as String,
  priceQuotes:
      (json['price_quotes'] as List<dynamic>?)
          ?.map((e) => PriceQuote.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SupplierToJson(_Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price_quotes': instance.priceQuotes,
};
