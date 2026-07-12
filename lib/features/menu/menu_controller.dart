import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/menu_repository.dart';
import 'models/pos_menu.dart';

class MenuState {
  const MenuState({
    this.loading = false,
    this.refreshing = false,
    this.error,
    this.data,
    this.selectedItemId,
  });

  final bool loading;
  final bool refreshing;
  final String? error;
  final POSMenusResponse? data;
  final String? selectedItemId;

  bool get isEmpty =>
      data != null &&
      (data!.categories.isEmpty ||
          data!.categories.every((category) => category.menus.isEmpty));

  MenuState copyWith({
    bool? loading,
    bool? refreshing,
    String? error,
    POSMenusResponse? data,
    String? selectedItemId,
    bool clearError = false,
    bool clearSelection = false,
  }) {
    return MenuState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
      selectedItemId:
          clearSelection ? null : (selectedItemId ?? this.selectedItemId),
    );
  }
}

class MenuController extends Notifier<MenuState> {
  MenuRepository get _repository => locator<MenuRepository>();

  @override
  MenuState build() {
    Future.microtask(load);
    return const MenuState(loading: true);
  }

  Future<void> load() => _fetch(refreshing: false);

  Future<void> refresh() => _fetch(refreshing: true);

  Future<void> retry() => _fetch(refreshing: false, forceLoading: true);

  Future<void> _fetch({
    required bool refreshing,
    bool forceLoading = false,
  }) async {
    state = state.copyWith(
      loading: forceLoading || (!refreshing && state.data == null),
      refreshing: refreshing,
      clearError: true,
    );

    try {
      final data = await _repository.fetchPOSMenus();
      final selectedId = state.selectedItemId;
      final stillSelected = selectedId != null &&
          data.categories.any(
            (category) =>
                category.menus.any((menu) => menu.id == selectedId),
          );

      state = state.copyWith(
        loading: false,
        refreshing: false,
        data: data,
        clearSelection: !stillSelected,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: 'Failed to load menu items',
      );
    }
  }

  void toggleSelection(POSMenuItem item) {
    if (!item.isInStock) return;

    if (state.selectedItemId == item.id) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedItemId: item.id);
    }
  }
}

final menuProvider = NotifierProvider<MenuController, MenuState>(
  MenuController.new,
);
