// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_POSMenusResponse _$POSMenusResponseFromJson(Map<String, dynamic> json) =>
    _POSMenusResponse(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => POSCategoryGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$POSMenusResponseToJson(_POSMenusResponse instance) =>
    <String, dynamic>{'categories': instance.categories};

_POSCategoryGroup _$POSCategoryGroupFromJson(Map<String, dynamic> json) =>
    _POSCategoryGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      menus:
          (json['menus'] as List<dynamic>?)
              ?.map((e) => POSMenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$POSCategoryGroupToJson(_POSCategoryGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'menus': instance.menus,
    };

_POSMenuItem _$POSMenuItemFromJson(Map<String, dynamic> json) => _POSMenuItem(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  photoUrl: json['photo_url'] as String?,
  availableStock: (json['available_stock'] as num).toInt(),
  sellPrice: (json['sell_price'] as num).toInt(),
);

Map<String, dynamic> _$POSMenuItemToJson(_POSMenuItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'photo_url': instance.photoUrl,
      'available_stock': instance.availableStock,
      'sell_price': instance.sellPrice,
    };
