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

@freezed
abstract class PurchaseRequestItem with _$PurchaseRequestItem {
  const factory PurchaseRequestItem({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(name: 'food_supply_title') String? foodSupplyTitle,
    @JsonKey(fromJson: _quantityFromJson) required num quantity,
    String? unit,
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
    required PurchaseRequestStatus status,
    @JsonKey(name: 'total_estimated_amount') int? totalEstimatedAmount,
    @Default([]) List<PurchaseRequestItem> items,
    String? notes,
    @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? createdAt,
  }) = _PurchaseRequestDetail;

  factory PurchaseRequestDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestDetailFromJson(json);
}
