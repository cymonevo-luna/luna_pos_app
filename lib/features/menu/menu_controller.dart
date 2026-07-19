import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/resource_cache.dart';
import 'data/menu_repository.dart';
import 'models/pos_menu.dart';

class MenuState {
  const MenuState({
    this.loading = false,
    this.refreshing = false,
    this.error,
    this.data,
    this.search = '',
  });

  final bool loading;
  final bool refreshing;
  final String? error;
  final POSMenusResponse? data;
  final String search;

  bool get isEmpty =>
      data != null &&
      (data!.categories.isEmpty ||
          data!.categories.every((category) => category.menus.isEmpty));

  POSMenusResponse? get filteredData {
    final loaded = data;
    if (loaded == null) return null;

    final normalizedQuery = search.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return loaded;

    final filteredCategories = <POSCategoryGroup>[];
    for (final category in loaded.categories) {
      final filteredMenus = category.menus.where((menu) {
        final title = menu.title.trim().toLowerCase();
        final description = (menu.description ?? '').trim().toLowerCase();
        return title.contains(normalizedQuery) ||
            description.contains(normalizedQuery);
      }).toList();

      if (filteredMenus.isNotEmpty) {
        filteredCategories.add(category.copyWith(menus: filteredMenus));
      }
    }

    return POSMenusResponse(categories: filteredCategories);
  }

  bool get hasNoSearchResults {
    if (search.trim().isEmpty || data == null) return false;

    final filtered = filteredData;
    if (filtered == null) return false;

    return filtered.categories.isEmpty ||
        filtered.categories.every((category) => category.menus.isEmpty);
  }

  MenuState copyWith({
    bool? loading,
    bool? refreshing,
    String? error,
    POSMenusResponse? data,
    String? search,
    bool clearError = false,
  }) {
    return MenuState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
      search: search ?? this.search,
    );
  }
}

class MenuController extends Notifier<MenuState> {
  MenuRepository get _repository => locator<MenuRepository>();

  DateTime? _fetchedAt;

  @override
  MenuState build() => const MenuState();

  Future<void> loadIfNeeded() async {
    if (state.loading || state.refreshing) return;

    final fetchedAt = _fetchedAt;
    if (state.data != null &&
        state.error == null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
      return;
    }

    await load();
  }

  Future<void> load() => _fetch(refreshing: false);

  Future<void> refresh() => _fetch(refreshing: true, forceRefresh: true);

  Future<void> retry() => _fetch(refreshing: false, forceLoading: true);

  /// Clears in-memory and repository menu caches after stock-changing mutations.
  void invalidateAfterMutation() {
    _fetchedAt = null;
    _repository.invalidateMenus();
    state = const MenuState();
  }

  void setSearch(String query) {
    state = state.copyWith(search: query);
  }

  Future<void> _fetch({
    required bool refreshing,
    bool forceLoading = false,
    bool forceRefresh = false,
  }) async {
    state = state.copyWith(
      loading: forceLoading || (!refreshing && state.data == null),
      refreshing: refreshing,
      clearError: true,
    );

    try {
      final data = await _repository.fetchPOSMenus(forceRefresh: forceRefresh);
      _fetchedAt = DateTime.now();

      state = state.copyWith(loading: false, refreshing: false, data: data);
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
}

final menuProvider = NotifierProvider<MenuController, MenuState>(
  MenuController.new,
);
