import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/storage/preferences_service.dart';
import '../auth/auth_controller.dart';
import '../printer/printer_controller.dart';
import '../user/models/user.dart';
import '../receipt/models/receipt_data.dart';
import '../receipt/models/receipt_line_item.dart';
import '../receipt/models/transaction_response.dart' as receipt;
import '../receipt/receipt_print_service.dart';
import '../store_settings/store_settings_controller.dart';
import '../cashier_balance/cashier_balance_controller.dart';
import '../transaction/data/transaction_repository.dart';
import '../transaction/models/transaction.dart';
import '../transaction/transaction_mapper.dart';
import 'models/order_line_item.dart';
import 'models/payment_method.dart';
import 'order_controller.dart';
import 'order_options_controller.dart';

const kOrderOptionInvalidMessage =
    'Selected order option is no longer available. Please select again.';

String insufficientPackagingStockMessage(String optionName) =>
    'Insufficient packaging stock for $optionName. Contact manager.';

class CheckoutState {
  const CheckoutState({
    this.submitting = false,
    this.error,
    this.lastReceiptBytes,
    this.selectedOrderOptionId,
  });

  final bool submitting;
  final String? error;
  final List<int>? lastReceiptBytes;
  final String? selectedOrderOptionId;

  CheckoutState copyWith({
    bool? submitting,
    String? error,
    List<int>? lastReceiptBytes,
    String? selectedOrderOptionId,
    bool clearError = false,
    bool clearReceiptBytes = false,
    bool clearSelectedOrderOption = false,
  }) {
    return CheckoutState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      lastReceiptBytes: clearReceiptBytes
          ? null
          : (lastReceiptBytes ?? this.lastReceiptBytes),
      selectedOrderOptionId: clearSelectedOrderOption
          ? null
          : (selectedOrderOptionId ?? this.selectedOrderOptionId),
    );
  }
}

class CheckoutResult {
  const CheckoutResult({
    required this.transactionId,
    required this.paymentMethod,
    required this.changeAmount,
    required this.printSucceeded,
    this.orderOptionName,
    this.printError,
  });

  final String transactionId;
  final PaymentMethod paymentMethod;
  final int changeAmount;
  final bool printSucceeded;
  final String? orderOptionName;
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
  ReceiptPrintService get _receiptPrintService =>
      locator<ReceiptPrintService>();

  @override
  CheckoutState build() => const CheckoutState();

  void selectOrderOption(String optionId) {
    state = state.copyWith(
      selectedOrderOptionId: optionId,
      clearError: true,
    );
  }

  void clearSelectedOrderOption() {
    state = state.copyWith(clearSelectedOrderOption: true);
  }

  String _userVisibleError(ApiException error) =>
      validationMessageFor(error) ?? error.message;

  Future<CheckoutResult?> proceed({
    required int discountAmount,
    required PaymentMethod paymentMethod,
    int? cashTendered,
    required bool printReceipt,
  }) async {
    final order = ref.read(orderProvider);
    if (order.lines.isEmpty) return null;

    final orderOptionId = state.selectedOrderOptionId;
    if (orderOptionId == null || orderOptionId.isEmpty) return null;

    final selectedOption =
        ref.read(orderOptionsProvider.notifier).optionById(orderOptionId);
    final selectedOptionName = selectedOption?.name ?? 'selected option';

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

    int? changeAmount;
    if (paymentMethod == PaymentMethod.cash) {
      final tendered = cashTendered ?? 0;
      if (!isPaymentSufficient(
        cashReceived: tendered,
        grandTotal: totalAmount,
      )) {
        return null;
      }
      changeAmount = calculatePaymentChange(
        cashReceived: tendered,
        grandTotal: totalAmount,
      );
    }

    final lines = List<OrderLineItem>.from(order.lines);

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final cashier = ref.read(authProvider).user;
      if (cashier == null) {
        throw StateError('Cashier must be authenticated to complete checkout');
      }

      final request = CreateTransactionRequest(
        method: paymentMethod.apiValue,
        items: buildTransactionItems(lines),
        subtotalAmount: subtotalAmount,
        discountAmount: discountAmount,
        amount: totalAmount,
        orderOptionId: orderOptionId,
        cashTendered: paymentMethod == PaymentMethod.cash ? cashTendered : null,
        changeAmount: paymentMethod == PaymentMethod.cash ? changeAmount : null,
      );

      final response =
          await _transactionRepository.createTransaction(request);

      if (paymentMethod == PaymentMethod.cash) {
        ref.read(cashierBalanceController.notifier).refresh();
      }

      ref.read(orderProvider.notifier).clear();
      state = state.copyWith(clearSelectedOrderOption: true);

      if (!printReceipt) {
        state = state.copyWith(
          submitting: false,
          clearReceiptBytes: true,
        );
        return CheckoutResult(
          transactionId: response.id,
          paymentMethod: paymentMethod,
          changeAmount: changeAmount ?? 0,
          printSucceeded: false,
          orderOptionName: response.orderOptionName ?? selectedOptionName,
        );
      }

      return await _printReceiptAfterSale(
        response: response,
        lines: lines,
        subtotalAmount: subtotalAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        cashTendered: cashTendered,
        changeAmount: changeAmount,
        cashier: cashier,
        orderOptionName: response.orderOptionName ?? selectedOptionName,
      );
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        await ref.read(orderOptionsProvider.notifier).refresh();
        state = state.copyWith(
          submitting: false,
          error: kOrderOptionInvalidMessage,
          clearSelectedOrderOption: true,
        );
        return null;
      }

      final message = error.statusCode == 422
          ? (validationMessageFor(error) ??
              insufficientPackagingStockMessage(selectedOptionName))
          : _userVisibleError(error);
      state = state.copyWith(submitting: false, error: message);
      return null;
    } catch (error) {
      state = state.copyWith(
        submitting: false,
        error: error is StateError ? error.message : 'Failed to complete sale',
      );
      return null;
    }
  }

  Future<CheckoutResult> _printReceiptAfterSale({
    required TransactionResponse response,
    required List<OrderLineItem> lines,
    required int subtotalAmount,
    required int discountAmount,
    required int totalAmount,
    required PaymentMethod paymentMethod,
    int? cashTendered,
    int? changeAmount,
    required User cashier,
    String? orderOptionName,
  }) async {
    try {
      final storeSettings =
          await ref.read(storeSettingsProvider.notifier).loadIfNeeded();

      final receiptTxn = _buildReceiptTransaction(
        response: response,
        lines: lines,
        subtotalAmount: subtotalAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        cashTendered: cashTendered,
        changeAmount: changeAmount,
        orderOptionName: orderOptionName,
      );

      final receiptData = ReceiptData.fromCheckout(
        txn: receiptTxn,
        store: storeSettings,
        cashier: cashier,
      );

      final printResult = await _receiptPrintService.printReceiptData(
        receiptData,
        deviceAddress: _preferredPrinterAddress(),
      );

      state = state.copyWith(
        submitting: false,
        lastReceiptBytes: printResult.receiptBytes,
      );

      return CheckoutResult(
        transactionId: response.id,
        paymentMethod: paymentMethod,
        changeAmount: changeAmount ?? 0,
        printSucceeded: printResult.succeeded,
        printError: printResult.error,
        orderOptionName: orderOptionName,
      );
    } catch (error) {
      state = state.copyWith(
        submitting: false,
        clearReceiptBytes: true,
      );
      return CheckoutResult(
        transactionId: response.id,
        paymentMethod: paymentMethod,
        changeAmount: changeAmount ?? 0,
        printSucceeded: false,
        printError: error is ApiException
            ? _userVisibleError(error)
            : 'Receipt could not be printed.',
        orderOptionName: orderOptionName,
      );
    }
  }

  Future<({bool succeeded, String? error})> retryPrint() async {
    final bytes = state.lastReceiptBytes;
    if (bytes == null || bytes.isEmpty) {
      return (succeeded: false, error: PrinterMessages.printFailed);
    }

    final printResult = await _receiptPrintService.printBytes(
      bytes,
      deviceAddress: _preferredPrinterAddress(),
    );
    return (succeeded: printResult.succeeded, error: printResult.error);
  }

  String? _preferredPrinterAddress() {
    final printerState = ref.read(printerProvider);
    if (printerState.isConnected && printerState.selectedDevice != null) {
      return printerState.selectedDevice!.address;
    }
    return locator<PreferencesService>().getString(PrefKeys.printerDeviceId);
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
    required PaymentMethod paymentMethod,
    int? cashTendered,
    int? changeAmount,
    String? orderOptionName,
  }) {
    return receipt.TransactionResponse(
      id: response.id,
      method: response.method,
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
      cashTendered:
          paymentMethod == PaymentMethod.cash ? cashTendered : null,
      changeAmount: paymentMethod == PaymentMethod.cash ? (changeAmount ?? 0) : 0,
      orderOptionName: orderOptionName,
    );
  }

}

final checkoutProvider =
    NotifierProvider<CheckoutController, CheckoutState>(
  CheckoutController.new,
);
