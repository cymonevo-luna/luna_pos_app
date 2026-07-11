import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_line_item.freezed.dart';

@freezed
abstract class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    required String id,
    required String menuId,
    required String title,
    required int sellPrice,
    required int quantity,
    @Default('') String note,
  }) = _OrderLineItem;

  const OrderLineItem._();

  int get lineTotal => sellPrice * quantity;
}
