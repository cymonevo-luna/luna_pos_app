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

_PurchaseRequestItem _$PurchaseRequestItemFromJson(Map<String, dynamic> json) =>
    _PurchaseRequestItem(
      foodSupplyId: json['food_supply_id'] as String,
      foodSupplyTitle: json['food_supply_title'] as String?,
      quantity: _quantityFromJson(json['quantity']),
      unit: json['unit'] as String?,
      unitPrice: _nullableIntFromJson(json['unit_price']),
      lineTotal: _nullableIntFromJson(json['line_total']),
    );

Map<String, dynamic> _$PurchaseRequestItemToJson(
  _PurchaseRequestItem instance,
) => <String, dynamic>{
  'food_supply_id': instance.foodSupplyId,
  'food_supply_title': instance.foodSupplyTitle,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'unit_price': instance.unitPrice,
  'line_total': instance.lineTotal,
};

_PurchaseRequestDetail _$PurchaseRequestDetailFromJson(
  Map<String, dynamic> json,
) => _PurchaseRequestDetail(
  id: json['id'] as String,
  supplierId: json['supplier_id'] as String,
  supplierName: json['supplier_name'] as String,
  supplierContactInfo: json['supplier_contact_info'] as String?,
  status: $enumDecode(_$PurchaseRequestStatusEnumMap, json['status']),
  totalEstimatedAmount: (json['total_estimated_amount'] as num?)?.toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PurchaseRequestItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes: json['notes'] as String?,
  paidProofUrl: json['paid_proof_url'] as String?,
  deliveredProofUrl: json['delivered_proof_url'] as String?,
  createdByUsername: json['created_by_username'] as String?,
  createdAt: _nullableDateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$PurchaseRequestDetailToJson(
  _PurchaseRequestDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'supplier_id': instance.supplierId,
  'supplier_name': instance.supplierName,
  'supplier_contact_info': instance.supplierContactInfo,
  'status': _$PurchaseRequestStatusEnumMap[instance.status]!,
  'total_estimated_amount': instance.totalEstimatedAmount,
  'items': instance.items,
  'notes': instance.notes,
  'paid_proof_url': instance.paidProofUrl,
  'delivered_proof_url': instance.deliveredProofUrl,
  'created_by_username': instance.createdByUsername,
  'created_at': instance.createdAt?.toIso8601String(),
};
