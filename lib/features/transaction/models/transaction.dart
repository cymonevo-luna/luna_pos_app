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
