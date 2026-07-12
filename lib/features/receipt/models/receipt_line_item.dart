import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_line_item.freezed.dart';

@freezed
abstract class ReceiptLineItem with _$ReceiptLineItem {
  const factory ReceiptLineItem({
    required String title,
    required int quantity,
    String? note,
    required int lineTotal,
  }) = _ReceiptLineItem;
}
