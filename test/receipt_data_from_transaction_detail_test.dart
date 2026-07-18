import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/receipt/models/receipt_data.dart';
import 'package:luna_pos/features/receipt/receipt_builder.dart';
import 'package:luna_pos/features/store_settings/models/store_settings.dart';
import 'package:luna_pos/features/transaction/models/transaction.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ReceiptBuilder builder;

  const storeSettings = StoreSettings(
    brandName: 'Luna Cafe',
    branchName: 'Cabang Sudirman',
    branchAddress: 'Jl. Sudirman No. 10, Jakarta',
    branchPhone: '021-1234567',
    thankYouNote: 'Terima kasih!',
  );

  setUp(() async {
    builder = await ReceiptBuilder.create();
  });

  TransactionDetail cashDetail({
    int discountAmount = 5000,
    int cashTendered = 50000,
    int changeAmount = 15000,
  }) {
    return TransactionDetail(
      id: 'tx-cash-1',
      method: 'CASH',
      items: const [
        TransactionItemRequest(
          menuId: 'm1',
          title: 'Es Teh Manis',
          quantity: 2,
          unitPrice: 8000,
          lineTotal: 16000,
          note: 'less ice',
        ),
        TransactionItemRequest(
          menuId: 'm2',
          title: 'Nasi Goreng',
          quantity: 1,
          unitPrice: 35000,
          lineTotal: 35000,
        ),
      ],
      subtotalAmount: 51000,
      discountAmount: discountAmount,
      amount: 51000 - discountAmount,
      cashTendered: cashTendered,
      changeAmount: changeAmount,
      cashierUsername: 'Cashier Test',
      transactionDate: DateTime.utc(2026, 7, 12, 10),
    );
  }

  TransactionDetail qrisDetail() {
    return TransactionDetail(
      id: 'tx-qris-1',
      method: 'QRIS',
      items: const [
        TransactionItemRequest(
          menuId: 'm1',
          title: 'Kopi Susu',
          quantity: 1,
          unitPrice: 18000,
          lineTotal: 18000,
        ),
      ],
      subtotalAmount: 18000,
      amount: 18000,
      cashierUsername: 'Cashier Test',
      transactionDate: DateTime.utc(2026, 7, 12, 10),
    );
  }

  test('fromTransactionDetail uses historical date and cashier', () {
    final data = ReceiptData.fromTransactionDetail(
      detail: cashDetail(discountAmount: 0, cashTendered: 50000, changeAmount: 0),
      store: storeSettings,
    );

    expect(data.transactionDate, DateTime.utc(2026, 7, 12, 10));
    expect(data.cashierName, 'Cashier Test');
    expect(data.transactionId, 'tx-cash-1');

    final text = decodeReceiptText(builder.build(data));

    expect(text, contains('Cashier Test'));
    expect(text, contains('12/07/2026 10:00'));
  });

  test('fromTransactionDetail maps CASH with discount and notes', () {
    final data = ReceiptData.fromTransactionDetail(
      detail: cashDetail(),
      store: storeSettings,
    );

    expect(data.discountAmount, 5000);
    expect(data.cashTendered, 50000);
    expect(data.changeAmount, 15000);
    expect(data.items, hasLength(2));
    expect(data.items.first.note, 'less ice');

    final text = decodeReceiptText(builder.build(data));

    expect(text, contains('Luna Cafe'));
    expect(text, contains('Es Teh Manis'));
    expect(text, contains('Note: less ice'));
    expect(text, contains('Discount'));
    expect(text, contains('Rp 5.000'));
    expect(text, contains('Bayar'));
    expect(text, contains('Rp 50.000'));
    expect(text, contains('Kembalian'));
    expect(text, contains('Rp 15.000'));
  });

  test('fromTransactionDetail omits cash lines for QRIS', () {
    final data = ReceiptData.fromTransactionDetail(
      detail: qrisDetail(),
      store: storeSettings,
    );

    expect(data.cashTendered, isNull);
    expect(data.changeAmount, 0);

    final text = decodeReceiptText(builder.build(data));

    expect(text, contains('QRIS'));
    expect(text, isNot(contains('Bayar')));
    expect(text, isNot(contains('Kembalian')));
  });
}
