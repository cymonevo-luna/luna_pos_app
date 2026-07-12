import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos_menu.freezed.dart';
part 'pos_menu.g.dart';

@freezed
abstract class POSMenusResponse with _$POSMenusResponse {
  const factory POSMenusResponse({
    @JsonKey(defaultValue: <POSCategoryGroup>[])
    required List<POSCategoryGroup> categories,
  }) = _POSMenusResponse;

  factory POSMenusResponse.fromJson(Map<String, dynamic> json) =>
      _$POSMenusResponseFromJson(json);
}

@freezed
abstract class POSCategoryGroup with _$POSCategoryGroup {
  const factory POSCategoryGroup({
    required String id,
    required String name,
    @JsonKey(defaultValue: <POSMenuItem>[]) required List<POSMenuItem> menus,
  }) = _POSCategoryGroup;

  factory POSCategoryGroup.fromJson(Map<String, dynamic> json) =>
      _$POSCategoryGroupFromJson(json);
}

@freezed
abstract class POSMenuItem with _$POSMenuItem {
  const factory POSMenuItem({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'available_stock') required int availableStock,
    @JsonKey(name: 'sell_price') required int sellPrice,
  }) = _POSMenuItem;

  const POSMenuItem._();

  bool get isInStock => availableStock > 0;

  factory POSMenuItem.fromJson(Map<String, dynamic> json) =>
      _$POSMenuItemFromJson(json);
}
