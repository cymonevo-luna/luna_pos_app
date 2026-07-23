import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../menu/models/pos_menu.dart';
import 'models/order_line_item.dart';

class OrderState {
  const OrderState({
    this.lines = const [],
    this.stockByMenuId = const {},
    this.errorMessage,
  });

  final List<OrderLineItem> lines;
  final Map<String, int> stockByMenuId;
  final String? errorMessage;

  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);

  int get grandTotal => lines.fold(0, (sum, line) => sum + line.lineTotal);

  OrderState copyWith({
    List<OrderLineItem>? lines,
    Map<String, int>? stockByMenuId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderState(
      lines: lines ?? this.lines,
      stockByMenuId: stockByMenuId ?? this.stockByMenuId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Cart line identity is menuId + trimmed note. List-mode inline qty uses the
  /// empty-note line only; lines with other notes are managed from the cart page.
  String? findLineIdForMenu(String menuId, {String note = ''}) {
    final trimmedNote = note.trim();
    final index = lines.indexWhere(
      (line) => line.menuId == menuId && line.note == trimmedNote,
    );
    if (index < 0) return null;
    return lines[index].id;
  }

  int quantityForMenu(String menuId, {String note = ''}) {
    final lineId = findLineIdForMenu(menuId, note: note);
    if (lineId == null) return 0;
    return lines.firstWhere((line) => line.id == lineId).quantity;
  }
}

class OrderController extends Notifier<OrderState> {
  static const _uuid = Uuid();

  @override
  OrderState build() => const OrderState();

  void addLine(
    POSMenuItem item, {
    required int quantity,
    String note = '',
  }) {
    if (quantity < 1) return;

    final trimmedNote = note.trim();
    final stockByMenuId = {...state.stockByMenuId, item.id: item.availableStock};
    final existingIndex = state.lines.indexWhere(
      (line) => line.menuId == item.id && line.note == trimmedNote,
    );

    if (existingIndex >= 0) {
      final existing = state.lines[existingIndex];
      final newQuantity = existing.quantity + quantity;
      if (!_canSetMenuQuantity(item.id, newQuantity, excludeLineId: existing.id)) {
        state = state.copyWith(
          stockByMenuId: stockByMenuId,
          errorMessage: _stockErrorMessage(item.title),
        );
        return;
      }

      final updatedLines = [...state.lines];
      updatedLines[existingIndex] = existing.copyWith(quantity: newQuantity);
      state = state.copyWith(
        lines: updatedLines,
        stockByMenuId: stockByMenuId,
        clearError: true,
      );
      return;
    }

    if (!_canSetMenuQuantity(item.id, quantity)) {
      state = state.copyWith(
        stockByMenuId: stockByMenuId,
        errorMessage: _stockErrorMessage(item.title),
      );
      return;
    }

    final newLine = OrderLineItem(
      id: _uuid.v4(),
      menuId: item.id,
      title: item.title,
      sellPrice: item.sellPrice,
      quantity: quantity,
      note: trimmedNote,
    );
    state = state.copyWith(
      lines: [...state.lines, newLine],
      stockByMenuId: stockByMenuId,
      clearError: true,
    );
  }

  void updateLineQuantity(String lineId, int quantity) {
    if (quantity < 1) {
      removeLine(lineId);
      return;
    }

    final index = state.lines.indexWhere((line) => line.id == lineId);
    if (index < 0) return;

    final line = state.lines[index];
    if (!_canSetMenuQuantity(
      line.menuId,
      quantity,
      excludeLineId: line.id,
    )) {
      state = state.copyWith(errorMessage: _stockErrorMessage(line.title));
      return;
    }

    final updatedLines = [...state.lines];
    updatedLines[index] = line.copyWith(quantity: quantity);
    state = state.copyWith(lines: updatedLines, clearError: true);
  }

  void updateLineNote(String lineId, String note) {
    final index = state.lines.indexWhere((line) => line.id == lineId);
    if (index < 0) return;

    final updatedLines = [...state.lines];
    updatedLines[index] = state.lines[index].copyWith(note: note.trim());
    state = state.copyWith(lines: updatedLines, clearError: true);
  }

  void removeLine(String lineId) {
    state = state.copyWith(
      lines: state.lines.where((line) => line.id != lineId).toList(),
      clearError: true,
    );
  }

  void clear() {
    state = const OrderState();
  }

  String? findLineIdForMenu(String menuId, {String note = ''}) =>
      state.findLineIdForMenu(menuId, note: note);

  int quantityForMenu(String menuId, {String note = ''}) =>
      state.quantityForMenu(menuId, note: note);

  bool _canSetMenuQuantity(
    String menuId,
    int quantity, {
    String? excludeLineId,
  }) {
    final stock = state.stockByMenuId[menuId];
    if (stock == null) return true;

    final otherLinesTotal = state.lines
        .where((line) => line.menuId == menuId && line.id != excludeLineId)
        .fold(0, (sum, line) => sum + line.quantity);

    return otherLinesTotal + quantity <= stock;
  }

  String _stockErrorMessage(String title) =>
      'Not enough stock for $title';
}

final orderProvider = NotifierProvider<OrderController, OrderState>(
  OrderController.new,
);
