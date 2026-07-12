import 'package:freezed_annotation/freezed_annotation.dart';

part 'production_request.freezed.dart';
part 'production_request.g.dart';

/// Backend production-request status values.
abstract final class ProductionRequestStatus {
  static const readyToPick = 'READY_TO_PICK';
  static const done = 'DONE';
}

num _quantityFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid quantity: $value');
}

dynamic _quantityToJson(num value) => value;

@freezed
abstract class ProductionRequestSummary with _$ProductionRequestSummary {
  const factory ProductionRequestSummary({
    required String id,
    required String status,
    @JsonKey(name: 'item_count') required int itemCount,
    @Default([]) List<ProductionRequestItem> items,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
  }) = _ProductionRequestSummary;

  factory ProductionRequestSummary.fromJson(Map<String, dynamic> json) =>
      _$ProductionRequestSummaryFromJson(json);
}

@freezed
abstract class ProductionRequestItem with _$ProductionRequestItem {
  const factory ProductionRequestItem({
    @JsonKey(name: 'menu_title') required String menuTitle,
    @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)
    required num quantity,
    @JsonKey(name: 'is_finished') @Default(false) bool isFinished,
    String? note,
  }) = _ProductionRequestItem;

  factory ProductionRequestItem.fromJson(Map<String, dynamic> json) =>
      _$ProductionRequestItemFromJson(json);
}

@freezed
abstract class ProductionRequestDetail with _$ProductionRequestDetail {
  const factory ProductionRequestDetail({
    required String id,
    required String status,
    required List<ProductionRequestItem> items,
    String? notes,
    @JsonKey(name: 'item_count') int? itemCount,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
  }) = _ProductionRequestDetail;

  factory ProductionRequestDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductionRequestDetailFromJson(json);
}

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}
