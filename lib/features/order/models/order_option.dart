import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_option.freezed.dart';
part 'order_option.g.dart';

@freezed
abstract class OrderOption with _$OrderOption {
  const factory OrderOption({
    required String id,
    required String name,
    required int priority,
  }) = _OrderOption;

  factory OrderOption.fromJson(Map<String, dynamic> json) =>
      _$OrderOptionFromJson(json);
}

@freezed
abstract class OrderOptionsResponse with _$OrderOptionsResponse {
  const factory OrderOptionsResponse({
    required List<OrderOption> options,
  }) = _OrderOptionsResponse;

  factory OrderOptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderOptionsResponseFromJson(json);
}
