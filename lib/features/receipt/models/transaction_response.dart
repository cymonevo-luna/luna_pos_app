import 'package:freezed_annotation/freezed_annotation.dart';

import 'receipt_line_item.dart';

part 'transaction_response.freezed.dart';

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required String id,
    required DateTime createdAt,
    required List<ReceiptLineItem> items,
    required int subtotalAmount,
    @Default(0) int discountAmount,
    required int totalAmount,
    required int cashTendered,
    @Default(0) int changeAmount,
  }) = _TransactionResponse;
}
