import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/printer/bluetooth_printer_service.dart';
import '../../core/storage/preferences_service.dart';
import '../auth/auth_controller.dart';
import '../receipt/models/receipt_data.dart';
import '../receipt/models/receipt_line_item.dart';
import '../receipt/models/transaction_response.dart' as receipt;
import '../receipt/receipt_builder.dart';
import '../store_settings/store_settings_controller.dart';
import '../transaction/data/transaction_repository.dart';
import '../transaction/models/transaction.dart';
import '../transaction/transaction_mapper.dart';
import 'models/order_line_item.dart';
import 'order_controller.dart';

class CheckoutState {
  const CheckoutState({
    this.submitting = false,
    this.error,
    this.lastReceiptBytes,
  });

  final bool submitting;
  final String? error;
  final List<int>? lastReceiptBytes;

  CheckoutState copyWith({
    bool? submitting,
    String? error,
    List<int>? lastReceiptBytes,
    bool clearError = false,
    bool clearReceiptBytes = false,
  }) {
    return CheckoutState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      lastReceiptBytes: clearReceiptBytes
          ? null
          : (lastReceiptBytes ?? this.lastReceiptBytes),
    );
  }
}

class CheckoutResult {
  const CheckoutResult({
    required this.transactionId,
    required this.changeAmount,
    required this.printSucceeded,
    this.printError,
  });

  final String transactionId;
  final int changeAmount;
  final bool printSucceeded;
  final String? printError;
}

bool isDiscountValid({
  required int discountAmount,
  required int subtotalAmount,
}) =>
    discountAmount >= 0 && discountAmount <= subtotalAmount;

int calculateCheckoutTotal({
  required int subtotalAmount,
  required int discountAmount,
}) =>
    subtotalAmount - discountAmount;

class CheckoutController extends Notifier<CheckoutState> {
  TransactionRepository get _transactionRepository =>
      locator<TransactionRepository>();
  BluetoothPrinterService get _printer => locator<BluetoothPrinterService>();
  PreferencesService get _prefs => locator<PreferencesService>();

  @override
  CheckoutState build() => const CheckoutState();

  Future<CheckoutResult?> confirmAndPrint({
    required int discountAmount,
    required int cashTendered,
  }) async {
    final order = ref.read(orderProvider);
    if (order.lines.isEmpty) return null;

    final subtotalAmount = order.grandTotal;
    if (!isDiscountValid(
      discountAmount: discountAmount,
      subtotalAmount: subtotalAmount,
    )) {
      return null;
    }

    final totalAmount = calculateCheckoutTotal(
      subtotalAmount: subtotalAmount,
      discountAmount: discountAmount,
    );

    if (!isPaymentSufficient(
      cashReceived: cashTendered,
      grandTotal: totalAmount,
    )) {
      return null;
    }

    final changeAmount = calculatePaymentChange(
      cashReceived: cashTendered,
      grandTotal: totalAmount,
    );

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final request = CreateTransactionRequest(
        method: 'OFFLINE',
        items: buildTransactionItems(order.lines),
        subtotalAmount: subtotalAmount,
        discountAmount: discountAmount,
        amount: totalAmount,
        cashTendered: cashTendered,
        changeAmount: changeAmount,
      );

      final response =
          await _transactionRepository.createOfflineTransaction(request);

      final storeSettings =
          await ref.read(storeSettingsProvider.notifier).loadIfNeeded();
      final cashier = ref.read(authProvider).user;
      if (cashier == null) {
        throw StateError('Cashier must be authenticated to complete checkout');
      }

      final receiptTxn = _buildReceiptTransaction(
        response: response,
        lines: order.lines,
        subtotalAmount: subtotalAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        cashTendered: cashTendered,
        changeAmount: changeAmount,
      );

      final receiptData = ReceiptData.fromCheckout(
        txn: receiptTxn,
        store: storeSettings,
        cashier: cashier,
      );

      final builder = await ReceiptBuilder.create();
      final receiptBytes = builder.build(receiptData);

      final printResult = await _printReceipt(receiptBytes);

      ref.read(orderProvider.notifier).clear();

      state = state.copyWith(
        submitting: false,
        lastReceiptBytes: receiptBytes,
      );

      return CheckoutResult(
        transactionId: response.id,
        changeAmount: changeAmount,
        printSucceeded: printResult.succeeded,
        printError: printResult.error,
      );
    } on ApiException catch (error) {
      state = state.copyWith(submitting: false, error: error.message);
      return null;
    } catch (error) {
      state = state.copyWith(
        submitting: false,
        error: error is StateError ? error.message : 'Failed to complete sale',
      );
      return null;
    }
  }

  Future<bool> retryPrint() async {
    final bytes = state.lastReceiptBytes;
    if (bytes == null || bytes.isEmpty) return false;

    final printResult = await _printReceipt(bytes);
    return printResult.succeeded;
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  receipt.TransactionResponse _buildReceiptTransaction({
    required TransactionResponse response,
    required List<OrderLineItem> lines,
    required int subtotalAmount,
    required int discountAmount,
    required int totalAmount,
    required int cashTendered,
    required int changeAmount,
  }) {
    return receipt.TransactionResponse(
      id: response.id,
      createdAt: DateTime.now(),
      items: lines
          .map(
            (line) => ReceiptLineItem(
              title: line.title,
              quantity: line.quantity,
              note: line.note.trim().isEmpty ? null : line.note.trim(),
              lineTotal: line.lineTotal,
            ),
          )
          .toList(),
      subtotalAmount: subtotalAmount,
      discountAmount: discountAmount,
      totalAmount: totalAmount,
      cashTendered: cashTendered,
      changeAmount: changeAmount,
    );
  }

  Future<({bool succeeded, String? error})> _printReceipt(
    List<int> bytes,
  ) async {
    try {
      final connected = await _ensurePrinterConnected();
      if (!connected) {
        return (
          succeeded: false,
          error: 'Printer is not connected.',
        );
      }

      await _printer.printBytes(bytes);
      return (succeeded: true, error: null);
    } on BluetoothPrinterException catch (error) {
      return (succeeded: false, error: error.message);
    } catch (_) {
      return (succeeded: false, error: 'Print failed.');
    }
  }

  Future<bool> _ensurePrinterConnected() async {
    if (_printer.isConnected) return true;

    final deviceId = _prefs.getString(PrefKeys.printerDeviceId);
    if (deviceId == null) return false;

    try {
      final granted = await _printer.requestPermissions();
      if (!granted) return false;

      await _printer.connect(deviceId);
      return _printer.isConnected;
    } catch (_) {
      return false;
    }
  }
}

final checkoutProvider =
    NotifierProvider<CheckoutController, CheckoutState>(
  CheckoutController.new,
);
