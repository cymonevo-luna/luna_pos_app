// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseRequestSummary _$PurchaseRequestSummaryFromJson(
  Map<String, dynamic> json,
) => _PurchaseRequestSummary(
  id: json['id'] as String,
  supplierName: json['supplier_name'] as String,
  status: $enumDecode(_$PurchaseRequestStatusEnumMap, json['status']),
  totalEstimatedAmount: (json['total_estimated_amount'] as num).toInt(),
  itemCount: (json['item_count'] as num).toInt(),
  createdByUsername: json['created_by_username'] as String?,
  createdAt: _nullableDateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$PurchaseRequestSummaryToJson(
  _PurchaseRequestSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'supplier_name': instance.supplierName,
  'status': _$PurchaseRequestStatusEnumMap[instance.status]!,
  'total_estimated_amount': instance.totalEstimatedAmount,
  'item_count': instance.itemCount,
  'created_by_username': instance.createdByUsername,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$PurchaseRequestStatusEnumMap = {
  PurchaseRequestStatus.pending: 'PENDING',
  PurchaseRequestStatus.requested: 'REQUESTED',
  PurchaseRequestStatus.paid: 'PAID',
  PurchaseRequestStatus.delivered: 'DELIVERED',
};
