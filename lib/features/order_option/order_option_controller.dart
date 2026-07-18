import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/storage/preferences_service.dart';
import 'data/order_option_repository.dart';
import 'models/order_option.dart';

class OrderOptionState {
  const OrderOptionState({
    this.loading = false,
    this.error,
    this.options = const [],
    this.selectedId,
  });

  final bool loading;
  final String? error;
  final List<OrderOption> options;
  final String? selectedId;

  bool get hasOptions => options.isNotEmpty;
  bool get canProceed => !loading && hasOptions && selectedId != null;

  OrderOptionState copyWith({
    bool? loading,
    String? error,
    List<OrderOption>? options,
    String? selectedId,
    bool clearError = false,
    bool clearSelectedId = false,
  }) {
    return OrderOptionState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      options: options ?? this.options,
      selectedId: clearSelectedId ? null : (selectedId ?? this.selectedId),
    );
  }
}

OrderOption? defaultOrderOption(List<OrderOption> options) {
  if (options.isEmpty) return null;
  return options.reduce(
    (best, option) => option.priority > best.priority ? option : best,
  );
}

class OrderOptionController extends Notifier<OrderOptionState> {
  OrderOptionRepository get _repository => locator<OrderOptionRepository>();
  PreferencesService get _prefs => locator<PreferencesService>();

  @override
  OrderOptionState build() => const OrderOptionState();

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final options = await _repository.fetchOrderOptions();
      final savedId = _prefs.getString(PrefKeys.orderOptionId);
      final savedOption =
          savedId == null ? null : options.where((o) => o.id == savedId).firstOrNull;
      final selected = savedOption ?? defaultOrderOption(options);

      state = state.copyWith(
        loading: false,
        options: options,
        selectedId: selected?.id,
        clearSelectedId: selected == null,
      );
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load order options',
      );
    }
  }

  void select(String id) {
    if (!state.options.any((option) => option.id == id)) return;
    state = state.copyWith(selectedId: id);
    _prefs.setString(PrefKeys.orderOptionId, id);
  }
}

final orderOptionProvider =
    NotifierProvider<OrderOptionController, OrderOptionState>(
  OrderOptionController.new,
);
