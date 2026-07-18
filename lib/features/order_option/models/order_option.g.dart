// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderOption _$OrderOptionFromJson(Map<String, dynamic> json) => _OrderOption(
  id: json['id'] as String,
  name: json['name'] as String,
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$OrderOptionToJson(_OrderOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priority': instance.priority,
    };

_OrderOptionsResponse _$OrderOptionsResponseFromJson(
  Map<String, dynamic> json,
) => _OrderOptionsResponse(
  options: (json['options'] as List<dynamic>)
      .map((e) => OrderOption.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderOptionsResponseToJson(
  _OrderOptionsResponse instance,
) => <String, dynamic>{'options': instance.options};
