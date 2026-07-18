import 'package:freezed_annotation/freezed_annotation.dart';

part 'cashier_balance.freezed.dart';
part 'cashier_balance.g.dart';

int _amountFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid amount: $value');
}

dynamic _amountToJson(int value) => value;

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}

DateTime _dateTimeFromJson(Object? value) {
  if (value == null) {
    throw const FormatException('Missing datetime');
  }
  return DateTime.parse(value as String);
}

enum CashierBalanceAdjustmentType {
  @JsonValue('ADD')
  add,
  @JsonValue('DEDUCT')
  deduct,
}

enum CashierBalanceEntryType {
  @JsonValue('ADD')
  add,
  @JsonValue('DEDUCT')
  deduct,
  @JsonValue('TRANSACTION')
  transaction,
  @JsonValue('ADJUSTMENT')
  adjustment,
}

@freezed
abstract class CashierBalance with _$CashierBalance {
  const factory CashierBalance({
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int balance,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
  }) = _CashierBalance;

  factory CashierBalance.fromJson(Map<String, dynamic> json) =>
      _$CashierBalanceFromJson(json);
}

@freezed
abstract class CashierBalanceEntry with _$CashierBalanceEntry {
  const factory CashierBalanceEntry({
    required String id,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    required String purpose,
    @JsonKey(name: 'requested_by_user_id') String? requestedByUserId,
    @JsonKey(name: 'requested_by_username') String? requestedByUsername,
    String? source,
    @JsonKey(name: 'transaction_id') String? transactionId,
    CashierBalanceEntryType? type,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    required DateTime createdAt,
  }) = _CashierBalanceEntry;

  const CashierBalanceEntry._();

  bool get isCredit =>
      type == CashierBalanceEntryType.add ||
      type == CashierBalanceEntryType.transaction;

  int get signedAmount => isCredit ? amount.abs() : -amount.abs();

  factory CashierBalanceEntry.fromJson(Map<String, dynamic> json) =>
      _$CashierBalanceEntryFromJson(json);
}

@freezed
abstract class CashierBalanceAdjustmentRequest
    with _$CashierBalanceAdjustmentRequest {
  const factory CashierBalanceAdjustmentRequest({
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    required String purpose,
    required CashierBalanceAdjustmentType type,
  }) = _CashierBalanceAdjustmentRequest;

  factory CashierBalanceAdjustmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CashierBalanceAdjustmentRequestFromJson(json);
}

@freezed
abstract class CashierBalanceAdjustmentResponse
    with _$CashierBalanceAdjustmentResponse {
  const factory CashierBalanceAdjustmentResponse({
    required CashierBalance balance,
    required CashierBalanceEntry entry,
  }) = _CashierBalanceAdjustmentResponse;

  factory CashierBalanceAdjustmentResponse.fromJson(Map<String, dynamic> json) =>
      _$CashierBalanceAdjustmentResponseFromJson(json);
}
