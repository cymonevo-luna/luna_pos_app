import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import 'data/recurring_expense_repository.dart';
import 'models/recurring_expense.dart';

class RecurringExpenseListState {
  const RecurringExpenseListState({
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
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final bool submitting;
  final bool deleting;
  final String? error;
  final bool forbidden;
  final List<RecurringExpense> items;
  final int page;
  final int total;
  final bool hasMore;
  final String search;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  RecurringExpenseListState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    bool? submitting,
    bool? deleting,
    String? error,
    bool? forbidden,
    List<RecurringExpense>? items,
    int? page,
    int? total,
    bool? hasMore,
    String? search,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return RecurringExpenseListState(
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
    );
  }
}

class RecurringExpenseListController extends Notifier<RecurringExpenseListState> {
  RecurringExpenseRepository get _repository =>
      locator<RecurringExpenseRepository>();

  Timer? _searchDebounce;

  @override
  RecurringExpenseListState build() {
    ref.onDispose(() => _searchDebounce?.cancel());
    Future.microtask(loadInitial);
    return const RecurringExpenseListState(loading: true);
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

  Future<RecurringExpense?> createExpense(
    RecurringExpenseRequest request,
  ) async {
    if (!ref.mounted) return null;
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final created = await _repository.create(request);
      if (!ref.mounted) return created;
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
        error: 'Failed to create recurring expense',
      );
      rethrow;
    }
  }

  Future<RecurringExpense?> updateExpense(
    String id,
    RecurringExpenseRequest request,
  ) async {
    if (!ref.mounted) return null;
    state = state.copyWith(submitting: true, clearError: true);
    try {
      await _repository.update(id, request);
      final updated = await _repository.fetchRecurringExpense(id);
      if (!ref.mounted) return updated;
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
        error: 'Failed to update recurring expense',
      );
      rethrow;
    }
  }

  Future<bool> deleteExpense(String id) async {
    if (!ref.mounted) return false;
    state = state.copyWith(deleting: true, clearError: true);
    try {
      await _repository.delete(id);
      if (!ref.mounted) return true;
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
        error: 'Failed to delete recurring expense',
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
      final PaginatedResponse<RecurringExpense> response =
          await _repository.fetchRecurringExpenses(
        page: page,
        perPage: RecurringExpenseRepository.defaultPerPage,
        search: state.search,
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
        error: 'Failed to load recurring expenses',
        items: append ? state.items : const [],
      );
    }
  }
}

final recurringExpenseListProvider =
    NotifierProvider<RecurringExpenseListController, RecurringExpenseListState>(
  RecurringExpenseListController.new,
);
