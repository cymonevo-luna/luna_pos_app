import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_line.freezed.dart';

@freezed
abstract class CartLine with _$CartLine {
  const factory CartLine({
    required String menuId,
    required String title,
    required int sellPrice,
    required int quantity,
  }) = _CartLine;

  const CartLine._();

  int get lineTotal => sellPrice * quantity;
}
