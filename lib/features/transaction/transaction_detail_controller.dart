import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/transaction_repository.dart';
import 'models/transaction.dart';

class TransactionDetailState {
  const TransactionDetailState({
    this.loading = false,
    this.error,
    this.forbidden = false,
    this.detail,
  });

  final bool loading;
  final String? error;
  final bool forbidden;
  final TransactionDetail? detail;

  TransactionDetailState copyWith({
    bool? loading,
    String? error,
    bool? forbidden,
    TransactionDetail? detail,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return TransactionDetailState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      detail: detail ?? this.detail,
    );
  }
}

class TransactionDetailController extends Notifier<TransactionDetailState> {
  TransactionDetailController(this._transactionId);

  final String _transactionId;

  TransactionRepository get _repository => locator<TransactionRepository>();

  @override
  TransactionDetailState build() {
    Future.microtask(load);
    return const TransactionDetailState(loading: true);
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true, clearForbidden: true);

    try {
      final detail = await _repository.fetchTransactionDetail(_transactionId);
      state = state.copyWith(loading: false, detail: detail);
    } on ApiException catch (e) {
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          forbidden: true,
          error: e.message,
        );
        return;
      }
      state = state.copyWith(loading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load transaction',
      );
    }
  }

  Future<void> retry() => load();
}

final transactionDetailProvider = NotifierProvider.family<
    TransactionDetailController, TransactionDetailState, String>(
  TransactionDetailController.new,
);
