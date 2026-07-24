import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_menu.freezed.dart';
part 'admin_menu.g.dart';

num _decimalFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid decimal value: $value');
}

dynamic _decimalToJson(num value) => value;

int _intFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid integer value: $value');
}

dynamic _intToJson(int value) => value;

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}

enum AdminMenuSortBy {
  @JsonValue('title')
  title,
  @JsonValue('stock')
  stock,
}

enum AdminMenuSortOrder {
  @JsonValue('asc')
  asc,
  @JsonValue('desc')
  desc,
}

@freezed
abstract class AdminMenu with _$AdminMenu {
  const factory AdminMenu({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson)
    required int availableStock,
    @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)
    required int sellPrice,
    @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)
    required int recipeYield,
    @JsonKey(
      name: 'margin_percent',
      fromJson: _decimalFromJson,
      toJson: _decimalToJson,
    )
    required num marginPercent,
    @JsonKey(
      name: 'vat_percent',
      fromJson: _decimalFromJson,
      toJson: _decimalToJson,
    )
    required num vatPercent,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
  }) = _AdminMenu;

  factory AdminMenu.fromJson(Map<String, dynamic> json) =>
      _$AdminMenuFromJson(json);
}

@freezed
abstract class AdminMenuRequest with _$AdminMenuRequest {
  const factory AdminMenuRequest({
    required String title,
    String? description,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)
    required int sellPrice,
    @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)
    required int recipeYield,
    @JsonKey(
      name: 'margin_percent',
      fromJson: _decimalFromJson,
      toJson: _decimalToJson,
    )
    required num marginPercent,
    @JsonKey(
      name: 'vat_percent',
      fromJson: _decimalFromJson,
      toJson: _decimalToJson,
    )
    required num vatPercent,
  }) = _AdminMenuRequest;

  factory AdminMenuRequest.fromJson(Map<String, dynamic> json) =>
      _$AdminMenuRequestFromJson(json);
}
