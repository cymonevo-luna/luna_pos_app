import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../order/models/order_line_item.dart';
import '../order/order_controller.dart';
import 'data/transaction_repository.dart';
import 'models/transaction.dart';

class PaymentState {
  const PaymentState({
    this.submitting = false,
    this.error,
  });

  final bool submitting;
  final String? error;

  PaymentState copyWith({
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return PaymentState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

List<TransactionItemRequest> buildTransactionItems(List<OrderLineItem> lines) {
  return lines
      .map(
        (line) => TransactionItemRequest(
          menuId: line.menuId,
          title: line.title,
          quantity: line.quantity,
          unitPrice: line.sellPrice,
          lineTotal: line.lineTotal,
          note: line.note.trim().isEmpty ? null : line.note.trim(),
        ),
      )
      .toList();
}

class PaymentController extends Notifier<PaymentState> {
  TransactionRepository get _repository => locator<TransactionRepository>();

  @override
  PaymentState build() => const PaymentState();

  Future<int?> completeOfflineSale({required int cashReceived}) async {
    final order = ref.read(orderProvider);
    if (order.lines.isEmpty) return null;

    final amount = order.grandTotal;
    if (!isPaymentSufficient(cashReceived: cashReceived, grandTotal: amount)) {
      return null;
    }

    final changeAmount = calculatePaymentChange(
      cashReceived: cashReceived,
      grandTotal: amount,
    );

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final request = CreateTransactionRequest(
        method: 'OFFLINE',
        items: buildTransactionItems(order.lines),
        subtotalAmount: amount,
        amount: amount,
        cashTendered: cashReceived,
        changeAmount: changeAmount,
      );

      await _repository.createOfflineTransaction(request);
      ref.read(orderProvider.notifier).clear();
      state = state.copyWith(submitting: false);
      return changeAmount;
    } on ApiException catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        submitting: false,
        error: 'Failed to complete sale',
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final paymentProvider = NotifierProvider<PaymentController, PaymentState>(
  PaymentController.new,
);
