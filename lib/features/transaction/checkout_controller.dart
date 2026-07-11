import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../menu/menu_controller.dart';
import '../menu/models/cart_line.dart';
import 'checkout_calculations.dart';
import 'data/transaction_repository.dart';
import 'models/transaction.dart';

class CheckoutState {
  const CheckoutState({
    this.submitting = false,
    this.error,
    this.lastChangeAmount,
  });

  final bool submitting;
  final String? error;
  final int? lastChangeAmount;

  CheckoutState copyWith({
    bool? submitting,
    String? error,
    int? lastChangeAmount,
    bool clearError = false,
    bool clearLastChangeAmount = false,
  }) {
    return CheckoutState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      lastChangeAmount: clearLastChangeAmount
          ? null
          : (lastChangeAmount ?? this.lastChangeAmount),
    );
  }
}

class CheckoutController extends Notifier<CheckoutState> {
  TransactionRepository get _repository => locator<TransactionRepository>();

  @override
  CheckoutState build() => const CheckoutState();

  Future<bool> completeOfflineSale({
    required Map<String, CartLine> cart,
    required int cashTendered,
  }) async {
    if (cart.isEmpty) return false;

    final amount = cartSubtotal(cart);
    final changeAmount = computeChangeAmount(
      cashTendered: cashTendered,
      total: amount,
    );

    if (!isPaymentSufficient(cashTendered: cashTendered, total: amount)) {
      return false;
    }

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final request = CreateTransactionRequest(
        method: 'OFFLINE',
        items: cart.values
            .map(
              (line) => TransactionItemRequest(
                menuId: line.menuId,
                quantity: line.quantity,
              ),
            )
            .toList(),
        amount: amount,
        cashTendered: cashTendered,
        changeAmount: changeAmount,
      );

      await _repository.createOfflineTransaction(request);

      ref.read(menuProvider.notifier).clearCart();
      state = state.copyWith(
        submitting: false,
        lastChangeAmount: changeAmount,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        submitting: false,
        error: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        submitting: false,
        error: 'Failed to complete sale',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final checkoutProvider =
    NotifierProvider<CheckoutController, CheckoutState>(
  CheckoutController.new,
);
