import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_supply.freezed.dart';
part 'food_supply.g.dart';

num _stockQuantityFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid stock_quantity: $value');
}

dynamic _stockQuantityToJson(num value) => value;

@freezed
abstract class FoodSupplyManualEditHistory with _$FoodSupplyManualEditHistory {
  const factory FoodSupplyManualEditHistory({
    @JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)
    required num deltaQuantity,
    @JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)
    required num previousQuantity,
    @JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)
    required num newQuantity,
    @JsonKey(name: 'changed_by_username') required String changedByUsername,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FoodSupplyManualEditHistory;

  factory FoodSupplyManualEditHistory.fromJson(Map<String, dynamic> json) =>
      _$FoodSupplyManualEditHistoryFromJson(json);
}

@freezed
abstract class FoodSupply with _$FoodSupply {
  const factory FoodSupply({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)
    required num stockQuantity,
    required String unit,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[])
    @Default(<FoodSupplyManualEditHistory>[])
    List<FoodSupplyManualEditHistory> manualEditHistory,
  }) = _FoodSupply;

  factory FoodSupply.fromJson(Map<String, dynamic> json) =>
      _$FoodSupplyFromJson(json);
}

@freezed
abstract class FoodSupplyRequest with _$FoodSupplyRequest {
  const factory FoodSupplyRequest({
    required String title,
    String? description,
    @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)
    required num stockQuantity,
    required String unit,
  }) = _FoodSupplyRequest;

  factory FoodSupplyRequest.fromJson(Map<String, dynamic> json) =>
      _$FoodSupplyRequestFromJson(json);
}
