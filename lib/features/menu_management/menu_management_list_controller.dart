import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import '../menu/menu_controller.dart';
import 'data/admin_menu_repository.dart';
import 'models/admin_menu.dart';

class MenuManagementState {
  const MenuManagementState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.submitting = false,
    this.deleting = false,
    this.error,
    this.forbidden = false,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.search = '',
    this.sortBy = AdminMenuSortBy.title,
    this.sortOrder = AdminMenuSortOrder.asc,
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final bool submitting;
  final bool deleting;
  final String? error;
  final bool forbidden;
  final List<AdminMenu> items;
  final int page;
  final int total;
  final bool hasMore;
  final String search;
  final AdminMenuSortBy sortBy;
  final AdminMenuSortOrder sortOrder;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  MenuManagementState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    bool? submitting,
    bool? deleting,
    String? error,
    bool? forbidden,
    List<AdminMenu>? items,
    int? page,
    int? total,
    bool? hasMore,
    String? search,
    AdminMenuSortBy? sortBy,
    AdminMenuSortOrder? sortOrder,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return MenuManagementState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      submitting: submitting ?? this.submitting,
      deleting: deleting ?? this.deleting,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class MenuManagementListController extends Notifier<MenuManagementState> {
  AdminMenuRepository get _repository => locator<AdminMenuRepository>();

  Timer? _searchDebounce;

  @override
  MenuManagementState build() {
    ref.onDispose(() => _searchDebounce?.cancel());
    Future.microtask(loadInitial);
    return const MenuManagementState(loading: true);
  }

  Future<void> loadInitial() => _fetch(page: 1, append: false);

  Future<void> refresh() => _fetch(page: 1, append: false, refreshing: true);

  Future<void> retry() => _fetch(page: 1, append: false, forceLoading: true);

  Future<void> loadMore() async {
    if (state.loading ||
        state.refreshing ||
        state.loadingMore ||
        !state.hasMore ||
        state.forbidden) {
      return;
    }
    await _fetch(page: state.page + 1, append: true, loadingMore: true);
  }

  void setSearch(String query) {
    state = state.copyWith(
      search: query,
      clearError: true,
      clearForbidden: true,
    );
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _fetch(page: 1, append: false, forceLoading: true);
    });
  }

  void setSort(AdminMenuSortBy sortBy, AdminMenuSortOrder sortOrder) {
    state = state.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
      clearError: true,
      clearForbidden: true,
    );
    _fetch(page: 1, append: false, forceLoading: true);
  }

  void toggleSortOrder() {
    final nextOrder = state.sortOrder == AdminMenuSortOrder.asc
        ? AdminMenuSortOrder.desc
        : AdminMenuSortOrder.asc;
    setSort(state.sortBy, nextOrder);
  }

  Future<AdminMenu?> createMenu(AdminMenuRequest request) async {
    if (!ref.mounted) return null;
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final created = await _repository.create(request);
      if (!ref.mounted) return created;
      ref.read(menuProvider.notifier).invalidateAfterMutation();
      await refresh();
      if (!ref.mounted) return created;
      state = state.copyWith(submitting: false);
      return created;
    } on ApiException catch (e) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(submitting: false, error: e.message);
      rethrow;
    } catch (_) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(
        submitting: false,
        error: 'Failed to create menu',
      );
      rethrow;
    }
  }

  Future<AdminMenu?> updateMenu(String id, AdminMenuRequest request) async {
    if (!ref.mounted) return null;
    state = state.copyWith(submitting: true, clearError: true);
    try {
      await _repository.update(id, request);
      final updated = await _repository.fetchMenu(id);
      if (!ref.mounted) return updated;
      ref.read(menuProvider.notifier).invalidateAfterMutation();
      final items = state.items
          .map((item) => item.id == id ? updated : item)
          .toList(growable: false);
      state = state.copyWith(items: items, submitting: false);
      return updated;
    } on ApiException catch (e) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(submitting: false, error: e.message);
      rethrow;
    } catch (_) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(
        submitting: false,
        error: 'Failed to update menu',
      );
      rethrow;
    }
  }

  Future<bool> deleteMenu(String id) async {
    if (!ref.mounted) return false;
    state = state.copyWith(deleting: true, clearError: true);
    try {
      await _repository.delete(id);
      if (!ref.mounted) return true;
      ref.read(menuProvider.notifier).invalidateAfterMutation();
      final items =
          state.items.where((item) => item.id != id).toList(growable: false);
      state = state.copyWith(
        deleting: false,
        items: items,
        total: state.total > 0 ? state.total - 1 : 0,
      );
      return true;
    } on ApiException catch (e) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(deleting: false, error: e.message);
      rethrow;
    } catch (_) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(
        deleting: false,
        error: 'Failed to delete menu',
      );
      rethrow;
    }
  }

  Future<void> _fetch({
    required int page,
    required bool append,
    bool refreshing = false,
    bool loadingMore = false,
    bool forceLoading = false,
  }) async {
    if (!ref.mounted) return;
    state = state.copyWith(
      loading: forceLoading || (!refreshing && !loadingMore && !append),
      refreshing: refreshing,
      loadingMore: loadingMore,
      clearError: true,
      clearForbidden: true,
    );

    try {
      final PaginatedResponse<AdminMenu> response = await _repository.fetchMenus(
        page: page,
        perPage: AdminMenuRepository.defaultPerPage,
        search: state.search,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
      );

      if (!ref.mounted) return;

      final merged =
          append ? [...state.items, ...response.items] : response.items;

      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        items: merged,
        page: response.page,
        total: response.total,
        hasMore: response.hasMore,
      );
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          refreshing: false,
          loadingMore: false,
          forbidden: true,
          error: e.message,
        );
        return;
      }

      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: e.message,
        items: append ? state.items : const [],
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: 'Failed to load menus',
        items: append ? state.items : const [],
      );
    }
  }
}

final menuManagementProvider =
    NotifierProvider<MenuManagementListController, MenuManagementState>(
  MenuManagementListController.new,
);
