// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_supply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSupply _$FoodSupplyFromJson(Map<String, dynamic> json) => _FoodSupply(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  stockQuantity: _stockQuantityFromJson(json['stock_quantity']),
  unit: json['unit'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$FoodSupplyToJson(_FoodSupply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'stock_quantity': _stockQuantityToJson(instance.stockQuantity),
      'unit': instance.unit,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_FoodSupplyRequest _$FoodSupplyRequestFromJson(Map<String, dynamic> json) =>
    _FoodSupplyRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      stockQuantity: _stockQuantityFromJson(json['stock_quantity']),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$FoodSupplyRequestToJson(_FoodSupplyRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'stock_quantity': _stockQuantityToJson(instance.stockQuantity),
      'unit': instance.unit,
    };
