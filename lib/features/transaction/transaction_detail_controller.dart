import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../receipt/models/receipt_data.dart';
import '../receipt/receipt_print_service.dart';
import '../store_settings/store_settings_controller.dart';
import 'data/transaction_repository.dart';
import 'models/transaction.dart';

class TransactionDetailState {
  const TransactionDetailState({
    this.loading = false,
    this.error,
    this.forbidden = false,
    this.detail,
    this.isPrinting = false,
    this.printError,
  });

  final bool loading;
  final String? error;
  final bool forbidden;
  final TransactionDetail? detail;
  final bool isPrinting;
  final String? printError;

  TransactionDetailState copyWith({
    bool? loading,
    String? error,
    bool? forbidden,
    TransactionDetail? detail,
    bool? isPrinting,
    String? printError,
    bool clearError = false,
    bool clearForbidden = false,
    bool clearPrintError = false,
  }) {
    return TransactionDetailState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      detail: detail ?? this.detail,
      isPrinting: isPrinting ?? this.isPrinting,
      printError: clearPrintError ? null : (printError ?? this.printError),
    );
  }
}

class TransactionDetailController extends Notifier<TransactionDetailState> {
  TransactionDetailController(this._transactionId);

  final String _transactionId;

  TransactionRepository get _repository => locator<TransactionRepository>();
  ReceiptPrintService get _receiptPrintService =>
      locator<ReceiptPrintService>();

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

  Future<void> printReceipt() async {
    final detail = state.detail;
    if (detail == null || state.isPrinting) return;

    state = state.copyWith(isPrinting: true, clearPrintError: true);

    try {
      final storeSettings =
          await ref.read(storeSettingsProvider.notifier).loadIfNeeded();
      final receiptData = ReceiptData.fromTransactionDetail(
        detail: detail,
        store: storeSettings,
      );
      final printResult =
          await _receiptPrintService.printReceiptData(receiptData);

      if (printResult.succeeded) {
        state = state.copyWith(isPrinting: false, clearPrintError: true);
        return;
      }

      state = state.copyWith(
        isPrinting: false,
        printError: printResult.error ?? 'Receipt could not be printed.',
      );
    } on ApiException catch (error) {
      state = state.copyWith(isPrinting: false, printError: error.message);
    } catch (_) {
      state = state.copyWith(
        isPrinting: false,
        printError: 'Receipt could not be printed.',
      );
    }
  }
}

final transactionDetailProvider = NotifierProvider.family<
    TransactionDetailController, TransactionDetailState, String>(
  TransactionDetailController.new,
);
