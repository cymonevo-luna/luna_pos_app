// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_supply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodSupplyManualEditHistory _$FoodSupplyManualEditHistoryFromJson(
  Map<String, dynamic> json,
) => _FoodSupplyManualEditHistory(
  deltaQuantity: _stockQuantityFromJson(json['delta_quantity']),
  previousQuantity: _stockQuantityFromJson(json['previous_quantity']),
  newQuantity: _stockQuantityFromJson(json['new_quantity']),
  changedByUsername: json['changed_by_username'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$FoodSupplyManualEditHistoryToJson(
  _FoodSupplyManualEditHistory instance,
) => <String, dynamic>{
  'delta_quantity': _stockQuantityToJson(instance.deltaQuantity),
  'previous_quantity': _stockQuantityToJson(instance.previousQuantity),
  'new_quantity': _stockQuantityToJson(instance.newQuantity),
  'changed_by_username': instance.changedByUsername,
  'created_at': instance.createdAt.toIso8601String(),
};

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
  manualEditHistory:
      (json['manual_edit_history'] as List<dynamic>?)
          ?.map(
            (e) =>
                FoodSupplyManualEditHistory.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
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
      'manual_edit_history': instance.manualEditHistory,
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
