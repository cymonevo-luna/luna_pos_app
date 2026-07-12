import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

num _decimalFromJson(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.parse(value);
  throw FormatException('Invalid decimal: $value');
}

@freezed
abstract class SupplierSummary with _$SupplierSummary {
  const factory SupplierSummary({
    required String id,
    required String name,
  }) = _SupplierSummary;

  factory SupplierSummary.fromJson(Map<String, dynamic> json) =>
      _$SupplierSummaryFromJson(json);
}

@freezed
abstract class PriceQuote with _$PriceQuote {
  const factory PriceQuote({
    @JsonKey(name: 'food_supply_id') required String foodSupplyId,
    @JsonKey(name: 'food_supply_title') required String foodSupplyTitle,
    required String unit,
    @JsonKey(name: 'price_amount') required int priceAmount,
    @JsonKey(
      name: 'price_quantity',
      fromJson: _decimalFromJson,
    )
    required num priceQuantity,
    @JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson)
    num? unitPrice,
  }) = _PriceQuote;

  factory PriceQuote.fromJson(Map<String, dynamic> json) =>
      _$PriceQuoteFromJson(json);
}

num? _nullableDecimalFromJson(dynamic value) {
  if (value == null) return null;
  return _decimalFromJson(value);
}

extension PriceQuoteX on PriceQuote {
  num get resolvedUnitPrice => unitPrice ?? priceAmount / priceQuantity;
}

@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    required String id,
    required String name,
    @JsonKey(name: 'price_quotes') @Default([]) List<PriceQuote> priceQuotes,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
