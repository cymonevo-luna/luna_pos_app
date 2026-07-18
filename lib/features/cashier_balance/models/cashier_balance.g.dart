// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CashierBalance _$CashierBalanceFromJson(Map<String, dynamic> json) =>
    _CashierBalance(
      balance: _amountFromJson(json['balance']),
      updatedAt: _nullableDateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$CashierBalanceToJson(_CashierBalance instance) =>
    <String, dynamic>{
      'balance': _amountToJson(instance.balance),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_CashierBalanceEntry _$CashierBalanceEntryFromJson(Map<String, dynamic> json) =>
    _CashierBalanceEntry(
      id: json['id'] as String,
      amount: _amountFromJson(json['amount']),
      purpose: json['purpose'] as String,
      requestedByUserId: json['requested_by_user_id'] as String?,
      requestedByUsername: json['requested_by_username'] as String?,
      source: json['source'] as String?,
      transactionId: json['transaction_id'] as String?,
      type: $enumDecodeNullable(_$CashierBalanceEntryTypeEnumMap, json['type']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$CashierBalanceEntryToJson(
  _CashierBalanceEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': _amountToJson(instance.amount),
  'purpose': instance.purpose,
  'requested_by_user_id': instance.requestedByUserId,
  'requested_by_username': instance.requestedByUsername,
  'source': instance.source,
  'transaction_id': instance.transactionId,
  'type': _$CashierBalanceEntryTypeEnumMap[instance.type],
  'created_at': instance.createdAt.toIso8601String(),
};

const _$CashierBalanceEntryTypeEnumMap = {
  CashierBalanceEntryType.add: 'ADD',
  CashierBalanceEntryType.deduct: 'DEDUCT',
  CashierBalanceEntryType.transaction: 'TRANSACTION',
  CashierBalanceEntryType.adjustment: 'ADJUSTMENT',
};

_CashierBalanceAdjustmentRequest _$CashierBalanceAdjustmentRequestFromJson(
  Map<String, dynamic> json,
) => _CashierBalanceAdjustmentRequest(
  amount: _amountFromJson(json['amount']),
  purpose: json['purpose'] as String,
  type: $enumDecode(_$CashierBalanceAdjustmentTypeEnumMap, json['type']),
);

Map<String, dynamic> _$CashierBalanceAdjustmentRequestToJson(
  _CashierBalanceAdjustmentRequest instance,
) => <String, dynamic>{
  'amount': _amountToJson(instance.amount),
  'purpose': instance.purpose,
  'type': _$CashierBalanceAdjustmentTypeEnumMap[instance.type]!,
};

const _$CashierBalanceAdjustmentTypeEnumMap = {
  CashierBalanceAdjustmentType.add: 'ADD',
  CashierBalanceAdjustmentType.deduct: 'DEDUCT',
};

_CashierBalanceAdjustmentResponse _$CashierBalanceAdjustmentResponseFromJson(
  Map<String, dynamic> json,
) => _CashierBalanceAdjustmentResponse(
  balance: CashierBalance.fromJson(json['balance'] as Map<String, dynamic>),
  entry: CashierBalanceEntry.fromJson(json['entry'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashierBalanceAdjustmentResponseToJson(
  _CashierBalanceAdjustmentResponse instance,
) => <String, dynamic>{'balance': instance.balance, 'entry': instance.entry};
