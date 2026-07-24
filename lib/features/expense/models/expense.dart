import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

enum ExpenseSourceOfFund {
  @JsonValue('CASHIER')
  cashier,
  @JsonValue('PERSONAL_MONEY')
  personalMoney,
}

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

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String title,
    String? description,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    @JsonKey(name: 'source_of_fund')
    @Default(ExpenseSourceOfFund.personalMoney)
    ExpenseSourceOfFund sourceOfFund,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'recurring_expense_id') String? recurringExpenseId,
    @JsonKey(name: 'created_by_user_id') String? createdByUserId,
    @JsonKey(name: 'created_by_username') String? createdByUsername,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}

@freezed
abstract class ExpenseRequest with _$ExpenseRequest {
  const factory ExpenseRequest({
    required String title,
    String? description,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    @JsonKey(name: 'source_of_fund')
  required ExpenseSourceOfFund sourceOfFund,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  }) = _ExpenseRequest;

  factory ExpenseRequest.fromJson(Map<String, dynamic> json) =>
      _$ExpenseRequestFromJson(json);
}
