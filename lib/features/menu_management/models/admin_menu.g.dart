// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminMenu _$AdminMenuFromJson(Map<String, dynamic> json) => _AdminMenu(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  categoryId: json['category_id'] as String,
  categoryName: json['category_name'] as String,
  photoUrl: json['photo_url'] as String?,
  availableStock: _intFromJson(json['available_stock']),
  sellPrice: _intFromJson(json['sell_price']),
  recipeYield: _intFromJson(json['recipe_yield']),
  marginPercent: _decimalFromJson(json['margin_percent']),
  vatPercent: _decimalFromJson(json['vat_percent']),
  createdAt: _nullableDateTimeFromJson(json['created_at']),
  updatedAt: _nullableDateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$AdminMenuToJson(_AdminMenu instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'photo_url': instance.photoUrl,
      'available_stock': _intToJson(instance.availableStock),
      'sell_price': _intToJson(instance.sellPrice),
      'recipe_yield': _intToJson(instance.recipeYield),
      'margin_percent': _decimalToJson(instance.marginPercent),
      'vat_percent': _decimalToJson(instance.vatPercent),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_AdminMenuRequest _$AdminMenuRequestFromJson(Map<String, dynamic> json) =>
    _AdminMenuRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: json['category_id'] as String,
      photoUrl: json['photo_url'] as String?,
      sellPrice: _intFromJson(json['sell_price']),
      recipeYield: _intFromJson(json['recipe_yield']),
      marginPercent: _decimalFromJson(json['margin_percent']),
      vatPercent: _decimalFromJson(json['vat_percent']),
    );

Map<String, dynamic> _$AdminMenuRequestToJson(_AdminMenuRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category_id': instance.categoryId,
      'photo_url': instance.photoUrl,
      'sell_price': _intToJson(instance.sellPrice),
      'recipe_yield': _intToJson(instance.recipeYield),
      'margin_percent': _decimalToJson(instance.marginPercent),
      'vat_percent': _decimalToJson(instance.vatPercent),
    };
