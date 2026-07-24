import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_request.freezed.dart';
part 'purchase_request.g.dart';

enum PurchaseRequestStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('REQUESTED')
  requested,
  @JsonValue('PAID')
  paid,
  @JsonValue('DELIVERED')
  delivered,
}

@freezed
abstract class PurchaseRequestSummary with _$PurchaseRequestSummary {
  const factory PurchaseRequestSummary({
    required String id,
    @JsonKey(name: 'supplier_name') required String supplierName,
    required PurchaseRequestStatus status,
    @JsonKey(name: 'total_estimated_amount') required int totalEstimatedAmount,
    @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)
    int? totalActualAmount,
    @JsonKey(name: 'item_count') required int itemCount,
    @JsonKey(name: 'created_by_username') String? createdByUsername,
    @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? createdAt,
  }) = _PurchaseRequestSummary;

  factory PurchaseRequestSummary.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestSummaryFromJson(json);
}

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}

num _quantityFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid quantity: $value');
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid int: $value');
}

num? _nullableNumFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid num: $value');
}

@freezed
abstract class PurchaseStatusHistoryEntry with _$PurchaseStatusHistoryEntry {
  const factory PurchaseStatusHistoryEntry({
    required PurchaseRequestStatus status,
    @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? createdAt,
  }) = _PurchaseStatusHistoryEntry;

  factory PurchaseStatusHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$PurchaseStatusHistoryEntryFromJson(json);
}

extension PurchaseRequestDetailStatusHistory on PurchaseRequestDetail {
  bool get showsPaidDate =>
      status == PurchaseRequestStatus.paid ||
      status == PurchaseRequestStatus.delivered;

  DateTime? get paidDateFromHistory {
    for (final entry in statusHistory) {
      if (entry.status == PurchaseRequestStatus.paid) {
        return entry.createdAt;
      }
    }
    return null;
  }
}

@freezed
abstract class PurchaseRequestItem with _$PurchaseRequestItem {
  const factory PurchaseRequestItem({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(name: 'food_supply_title') String? foodSupplyTitle,
    @JsonKey(fromJson: _quantityFromJson) required num quantity,
    String? unit,
    @JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) num? unitPrice,
    @JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson)
    int? lineEstimatedAmount,
    @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)
    int? lineActualAmount,
  }) = _PurchaseRequestItem;

  factory PurchaseRequestItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestItemFromJson(json);
}

@freezed
abstract class PurchaseRequestDetail with _$PurchaseRequestDetail {
  const factory PurchaseRequestDetail({
    required String id,
    @JsonKey(name: 'supplier_id') required String supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'supplier_contact_info') String? supplierContactInfo,
    required PurchaseRequestStatus status,
    @JsonKey(name: 'total_estimated_amount') int? totalEstimatedAmount,
    @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)
    int? totalActualAmount,
    @Default([]) List<PurchaseRequestItem> items,
    String? notes,
    @JsonKey(name: 'paid_proof_url') String? paidProofUrl,
    @JsonKey(name: 'delivered_proof_url') String? deliveredProofUrl,
    @JsonKey(name: 'created_by_username') String? createdByUsername,
    @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? createdAt,
    @JsonKey(name: 'status_history', defaultValue: [])
    @Default([])
    List<PurchaseStatusHistoryEntry> statusHistory,
  }) = _PurchaseRequestDetail;

  factory PurchaseRequestDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestDetailFromJson(json);
}
