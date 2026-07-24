// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  amount: _amountFromJson(json['amount']),
  sourceOfFund:
      $enumDecodeNullable(
        _$ExpenseSourceOfFundEnumMap,
        json['source_of_fund'],
      ) ??
      ExpenseSourceOfFund.personalMoney,
  receiptUrl: json['receipt_url'] as String?,
  recurringExpenseId: json['recurring_expense_id'] as String?,
  createdByUserId: json['created_by_user_id'] as String?,
  createdByUsername: json['created_by_username'] as String?,
  createdAt: _nullableDateTimeFromJson(json['created_at']),
  updatedAt: _nullableDateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'amount': _amountToJson(instance.amount),
  'source_of_fund': _$ExpenseSourceOfFundEnumMap[instance.sourceOfFund]!,
  'receipt_url': instance.receiptUrl,
  'recurring_expense_id': instance.recurringExpenseId,
  'created_by_user_id': instance.createdByUserId,
  'created_by_username': instance.createdByUsername,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$ExpenseSourceOfFundEnumMap = {
  ExpenseSourceOfFund.cashier: 'CASHIER',
  ExpenseSourceOfFund.personalMoney: 'PERSONAL_MONEY',
};

_ExpenseRequest _$ExpenseRequestFromJson(Map<String, dynamic> json) =>
    _ExpenseRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: _amountFromJson(json['amount']),
      sourceOfFund: $enumDecode(
        _$ExpenseSourceOfFundEnumMap,
        json['source_of_fund'],
      ),
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$ExpenseRequestToJson(_ExpenseRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'amount': _amountToJson(instance.amount),
      'source_of_fund': _$ExpenseSourceOfFundEnumMap[instance.sourceOfFund]!,
      'receipt_url': instance.receiptUrl,
    };
