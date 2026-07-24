// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyMenuSummaryItem _$DailyMenuSummaryItemFromJson(
  Map<String, dynamic> json,
) => _DailyMenuSummaryItem(
  menuId: json['menu_id'] as String,
  menuTitle: json['menu_title'] as String,
  quantitySold: (json['quantity_sold'] as num).toInt(),
  revenue: _amountFromJson(json['revenue']),
);

Map<String, dynamic> _$DailyMenuSummaryItemToJson(
  _DailyMenuSummaryItem instance,
) => <String, dynamic>{
  'menu_id': instance.menuId,
  'menu_title': instance.menuTitle,
  'quantity_sold': instance.quantitySold,
  'revenue': _amountToJson(instance.revenue),
};

_DailyMenuSummaryResponse _$DailyMenuSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _DailyMenuSummaryResponse(
  dateFrom: json['date_from'] as String,
  dateTo: json['date_to'] as String,
  totalRevenue: _amountFromJson(json['total_revenue']),
  totalQuantity: (json['total_quantity'] as num).toInt(),
  menus: (json['menus'] as List<dynamic>)
      .map((e) => DailyMenuSummaryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DailyMenuSummaryResponseToJson(
  _DailyMenuSummaryResponse instance,
) => <String, dynamic>{
  'date_from': instance.dateFrom,
  'date_to': instance.dateTo,
  'total_revenue': _amountToJson(instance.totalRevenue),
  'total_quantity': instance.totalQuantity,
  'menus': instance.menus,
};
