import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_menu_summary.freezed.dart';
part 'daily_menu_summary.g.dart';

int _amountFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid amount: $value');
}

dynamic _amountToJson(int value) => value;

@freezed
abstract class DailyMenuSummaryItem with _$DailyMenuSummaryItem {
  const factory DailyMenuSummaryItem({
    @JsonKey(name: 'menu_id') required String menuId,
    @JsonKey(name: 'menu_title') required String menuTitle,
    @JsonKey(name: 'quantity_sold') required int quantitySold,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int revenue,
  }) = _DailyMenuSummaryItem;

  factory DailyMenuSummaryItem.fromJson(Map<String, dynamic> json) =>
      _$DailyMenuSummaryItemFromJson(json);
}

@freezed
abstract class DailyMenuSummaryResponse with _$DailyMenuSummaryResponse {
  const factory DailyMenuSummaryResponse({
    @JsonKey(name: 'date_from') required String dateFrom,
    @JsonKey(name: 'date_to') required String dateTo,
    @JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson)
    required int totalRevenue,
    @JsonKey(name: 'total_quantity') required int totalQuantity,
    required List<DailyMenuSummaryItem> menus,
  }) = _DailyMenuSummaryResponse;

  factory DailyMenuSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyMenuSummaryResponseFromJson(json);
}
