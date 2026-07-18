import 'package:freezed_annotation/freezed_annotation.dart';

import '../../store_settings/models/store_settings.dart';
import '../../transaction/models/transaction.dart';
import '../../user/models/user.dart';
import 'receipt_line_item.dart';
import 'transaction_response.dart' as receipt;

part 'receipt_data.freezed.dart';

@freezed
abstract class ReceiptData with _$ReceiptData {
  const factory ReceiptData({
    required String brandName,
    required String branchName,
    required String branchAddress,
    required String branchPhone,
    required String cashierName,
    required String transactionId,
    required DateTime transactionDate,
    required String paymentMethod,
    required List<ReceiptLineItem> items,
    required int subtotalAmount,
    @Default(0) int discountAmount,
    required int totalAmount,
    int? cashTendered,
    @Default(0) int changeAmount,
    required String thankYouNote,
    String? orderOptionName,
  }) = _ReceiptData;

  const ReceiptData._();

  factory ReceiptData.fromCheckout({
    required receipt.TransactionResponse txn,
    required StoreSettings store,
    required User cashier,
  }) {
    return ReceiptData(
      brandName: store.brandName,
      branchName: store.branchName,
      branchAddress: store.branchAddress,
      branchPhone: store.branchPhone,
      cashierName: cashier.name,
      transactionId: txn.id,
      transactionDate: txn.createdAt,
      paymentMethod: txn.method,
      items: txn.items,
      subtotalAmount: txn.subtotalAmount,
      discountAmount: txn.discountAmount,
      totalAmount: txn.totalAmount,
      cashTendered: txn.cashTendered,
      changeAmount: txn.changeAmount,
      thankYouNote: store.thankYouNote,
      orderOptionName: txn.orderOptionName,
    );
  }

  factory ReceiptData.fromTransactionDetail({
    required TransactionDetail detail,
    required StoreSettings store,
  }) {
    final isCash = detail.method.toUpperCase() == 'CASH';

    return ReceiptData(
      brandName: store.brandName,
      branchName: store.branchName,
      branchAddress: store.branchAddress,
      branchPhone: store.branchPhone,
      cashierName: detail.cashierUsername ?? '',
      transactionId: detail.id,
      transactionDate:
          detail.occurredAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      paymentMethod: detail.method,
      items: detail.items
          .map(
            (item) => ReceiptLineItem(
              title: item.title,
              quantity: item.quantity,
              note: _trimmedNote(item.note),
              lineTotal: item.lineTotal,
            ),
          )
          .toList(),
      subtotalAmount: detail.subtotalAmount,
      discountAmount: detail.discountAmount,
      totalAmount: detail.amount,
      cashTendered: isCash ? detail.cashTendered : null,
      changeAmount: isCash ? detail.changeAmount : 0,
      thankYouNote: store.thankYouNote,
    );
  }
}

String? _trimmedNote(String? note) {
  final trimmed = note?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
