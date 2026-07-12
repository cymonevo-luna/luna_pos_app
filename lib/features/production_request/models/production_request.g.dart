// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductionRequestSummary _$ProductionRequestSummaryFromJson(
  Map<String, dynamic> json,
) => _ProductionRequestSummary(
  id: json['id'] as String,
  status: json['status'] as String,
  itemCount: (json['item_count'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => ProductionRequestItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  createdAt: _nullableDateTimeFromJson(json['created_at']),
  updatedAt: _nullableDateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$ProductionRequestSummaryToJson(
  _ProductionRequestSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'item_count': instance.itemCount,
  'items': instance.items,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_ProductionRequestItem _$ProductionRequestItemFromJson(
  Map<String, dynamic> json,
) => _ProductionRequestItem(
  menuTitle: json['menu_title'] as String,
  quantity: _quantityFromJson(json['quantity']),
  isFinished: json['is_finished'] as bool? ?? false,
  note: json['note'] as String?,
);

Map<String, dynamic> _$ProductionRequestItemToJson(
  _ProductionRequestItem instance,
) => <String, dynamic>{
  'menu_title': instance.menuTitle,
  'quantity': _quantityToJson(instance.quantity),
  'is_finished': instance.isFinished,
  'note': instance.note,
};

_ProductionRequestDetail _$ProductionRequestDetailFromJson(
  Map<String, dynamic> json,
) => _ProductionRequestDetail(
  id: json['id'] as String,
  status: json['status'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => ProductionRequestItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String?,
  itemCount: (json['item_count'] as num?)?.toInt(),
  createdAt: _nullableDateTimeFromJson(json['created_at']),
  updatedAt: _nullableDateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$ProductionRequestDetailToJson(
  _ProductionRequestDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'items': instance.items,
  'notes': instance.notes,
  'item_count': instance.itemCount,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
