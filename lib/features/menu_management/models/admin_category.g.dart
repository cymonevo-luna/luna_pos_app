// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminCategory _$AdminCategoryFromJson(Map<String, dynamic> json) =>
    _AdminCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      priority: (json['priority'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AdminCategoryToJson(_AdminCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priority': instance.priority,
    };
