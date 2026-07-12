import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/models/user.dart';
import 'receipt_line_item.dart';
import 'store_settings.dart';
import 'transaction_response.dart';

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
    required List<ReceiptLineItem> items,
    required int subtotalAmount,
    @Default(0) int discountAmount,
    required int totalAmount,
    required int cashTendered,
    @Default(0) int changeAmount,
    required String thankYouNote,
  }) = _ReceiptData;

  const ReceiptData._();

  factory ReceiptData.fromCheckout({
    required TransactionResponse txn,
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
      items: txn.items,
      subtotalAmount: txn.subtotalAmount,
      discountAmount: txn.discountAmount,
      totalAmount: txn.totalAmount,
      cashTendered: txn.cashTendered,
      changeAmount: txn.changeAmount,
      thankYouNote: store.thankYouNote,
    );
  }
}
