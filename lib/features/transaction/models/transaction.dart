import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class CreateTransactionRequest with _$CreateTransactionRequest {
  const factory CreateTransactionRequest({
    required String method,
    required List<TransactionItemRequest> items,
    @JsonKey(name: 'subtotal_amount') required int subtotalAmount,
    @JsonKey(name: 'discount_amount') @Default(0) int discountAmount,
    required int amount,
    @JsonKey(name: 'cash_tendered') required int cashTendered,
    @JsonKey(name: 'change_amount') required int changeAmount,
  }) = _CreateTransactionRequest;

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);
}

@freezed
abstract class TransactionItemRequest with _$TransactionItemRequest {
  const factory TransactionItemRequest({
    @JsonKey(name: 'menu_id') required String menuId,
    required String title,
    required int quantity,
    @JsonKey(name: 'unit_price') required int unitPrice,
    @JsonKey(name: 'line_total') required int lineTotal,
    String? note,
  }) = _TransactionItemRequest;

  factory TransactionItemRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemRequestFromJson(json);
}

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required String id,
    required String method,
    required int amount,
    @JsonKey(name: 'subtotal_amount') int? subtotalAmount,
    @JsonKey(name: 'discount_amount') int? discountAmount,
    @JsonKey(name: 'cash_tendered') int? cashTendered,
    @JsonKey(name: 'change_amount') int? changeAmount,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}

@freezed
abstract class TransactionListItem with _$TransactionListItem {
  const factory TransactionListItem({
    required String id,
    required String method,
    required int amount,
    @JsonKey(name: 'cashier_username') String? cashierUsername,
    @JsonKey(
      name: 'transaction_date',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? transactionDate,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
  }) = _TransactionListItem;

  factory TransactionListItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionListItemFromJson(json);
}

extension TransactionListItemX on TransactionListItem {
  DateTime? get occurredAt => transactionDate ?? createdAt;
}

@freezed
abstract class TransactionDetail with _$TransactionDetail {
  const factory TransactionDetail({
    required String id,
    required String method,
    required List<TransactionItemRequest> items,
    @JsonKey(name: 'subtotal_amount') required int subtotalAmount,
    @JsonKey(name: 'discount_amount') @Default(0) int discountAmount,
    required int amount,
    @JsonKey(name: 'cash_tendered') int? cashTendered,
    @JsonKey(name: 'change_amount') @Default(0) int changeAmount,
    @JsonKey(name: 'cashier_username') String? cashierUsername,
    @JsonKey(
      name: 'transaction_date',
      fromJson: _nullableDateTimeFromJson,
    )
    DateTime? transactionDate,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
  }) = _TransactionDetail;

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailFromJson(json);
}

extension TransactionDetailX on TransactionDetail {
  DateTime? get occurredAt => transactionDate ?? createdAt;
}

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}
