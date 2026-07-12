// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTransactionRequest _$CreateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTransactionRequest(
  method: json['method'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => TransactionItemRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotalAmount: (json['subtotal_amount'] as num).toInt(),
  discountAmount: (json['discount_amount'] as num?)?.toInt() ?? 0,
  amount: (json['amount'] as num).toInt(),
  cashTendered: (json['cash_tendered'] as num).toInt(),
  changeAmount: (json['change_amount'] as num).toInt(),
);

Map<String, dynamic> _$CreateTransactionRequestToJson(
  _CreateTransactionRequest instance,
) => <String, dynamic>{
  'method': instance.method,
  'items': instance.items,
  'subtotal_amount': instance.subtotalAmount,
  'discount_amount': instance.discountAmount,
  'amount': instance.amount,
  'cash_tendered': instance.cashTendered,
  'change_amount': instance.changeAmount,
};

_TransactionItemRequest _$TransactionItemRequestFromJson(
  Map<String, dynamic> json,
) => _TransactionItemRequest(
  menuId: json['menu_id'] as String,
  title: json['title'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unit_price'] as num).toInt(),
  lineTotal: (json['line_total'] as num).toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$TransactionItemRequestToJson(
  _TransactionItemRequest instance,
) => <String, dynamic>{
  'menu_id': instance.menuId,
  'title': instance.title,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
  'line_total': instance.lineTotal,
  'note': instance.note,
};

_TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    _TransactionResponse(
      id: json['id'] as String,
      method: json['method'] as String,
      amount: (json['amount'] as num).toInt(),
      subtotalAmount: (json['subtotal_amount'] as num?)?.toInt(),
      discountAmount: (json['discount_amount'] as num?)?.toInt(),
      cashTendered: (json['cash_tendered'] as num?)?.toInt(),
      changeAmount: (json['change_amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionResponseToJson(
  _TransactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'method': instance.method,
  'amount': instance.amount,
  'subtotal_amount': instance.subtotalAmount,
  'discount_amount': instance.discountAmount,
  'cash_tendered': instance.cashTendered,
  'change_amount': instance.changeAmount,
};
