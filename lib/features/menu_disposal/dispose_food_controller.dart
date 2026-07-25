import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../menu/menu_controller.dart';
import '../menu/models/pos_menu.dart';
import 'data/menu_disposal_repository.dart';
import 'models/menu_disposal.dart';

class DisposeFoodState {
  const DisposeFoodState({
    this.selectedMenu,
    this.quantity = 1,
    this.note = '',
    this.submitting = false,
    this.error,
    this.quantityError,
    this.lastDisposal,
  });

  final POSMenuItem? selectedMenu;
  final int quantity;
  final String note;
  final bool submitting;
  final String? error;
  final String? quantityError;
  final MenuDisposal? lastDisposal;

  bool get canSubmit =>
      selectedMenu != null &&
      quantity > 0 &&
      quantityError == null &&
      !submitting;

  DisposeFoodState copyWith({
    POSMenuItem? selectedMenu,
    int? quantity,
    String? note,
    bool? submitting,
    String? error,
    String? quantityError,
    MenuDisposal? lastDisposal,
    bool clearSelectedMenu = false,
    bool clearError = false,
    bool clearQuantityError = false,
    bool clearLastDisposal = false,
  }) {
    return DisposeFoodState(
      selectedMenu:
          clearSelectedMenu ? null : (selectedMenu ?? this.selectedMenu),
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      quantityError:
          clearQuantityError ? null : (quantityError ?? this.quantityError),
      lastDisposal:
          clearLastDisposal ? null : (lastDisposal ?? this.lastDisposal),
    );
  }
}

class DisposeFoodController extends Notifier<DisposeFoodState> {
  MenuDisposalRepository get _repository => locator<MenuDisposalRepository>();

  @override
  DisposeFoodState build() => const DisposeFoodState();

  void selectMenu(POSMenuItem menu) {
    state = DisposeFoodState(
      selectedMenu: menu,
      quantity: 1,
      note: '',
    );
  }

  void clearSelection() {
    state = const DisposeFoodState();
  }

  void setQuantity(int quantity) {
    final menu = state.selectedMenu;
    String? quantityError;
    if (quantity <= 0) {
      quantityError = 'Quantity must be greater than zero';
    } else if (menu != null && quantity > menu.availableStock) {
      quantityError = 'Quantity exceeds available stock (${menu.availableStock})';
    }

    state = state.copyWith(
      quantity: quantity,
      quantityError: quantityError,
      clearQuantityError: quantityError == null,
      clearError: true,
    );
  }

  void setNote(String note) {
    state = state.copyWith(note: note, clearError: true);
  }

  Future<MenuDisposal?> submit() async {
    final menu = state.selectedMenu;
    if (menu == null) return null;

    setQuantity(state.quantity);
    if (state.quantityError != null || state.quantity <= 0) {
      return null;
    }

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final note = state.note.trim();
      final response = await _repository.createMenuDisposal(
        menuId: menu.id,
        quantity: state.quantity,
        note: note.isEmpty ? null : note,
      );

      ref.read(menuProvider.notifier).invalidateAfterMutation();
      await ref.read(menuProvider.notifier).loadIfNeeded();

      if (!ref.mounted) return response;

      state = const DisposeFoodState();
      return response;
    } on ApiException catch (e) {
      if (!ref.mounted) rethrow;

      final fieldMessage = validationMessageFor(e);
      final isQuantityError = e.statusCode == 422 &&
          (fieldMessage?.toLowerCase().contains('stock') == true ||
              fieldMessage?.toLowerCase().contains('quantity') == true);

      state = state.copyWith(
        submitting: false,
        error: fieldMessage ?? e.message,
        quantityError: isQuantityError ? fieldMessage : state.quantityError,
      );
      return null;
    } catch (_) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(
        submitting: false,
        error: 'Failed to dispose food',
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final disposeFoodProvider =
    NotifierProvider<DisposeFoodController, DisposeFoodState>(
  DisposeFoodController.new,
);
