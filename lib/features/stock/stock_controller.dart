import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import 'data/food_supply_repository.dart';
import 'models/food_supply.dart';

class StockState {
  const StockState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.submitting = false,
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
  final String? error;
  final bool forbidden;
  final List<FoodSupply> items;
  final int page;
  final int total;
  final bool hasMore;
  final String search;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  StockState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    bool? submitting,
    String? error,
    bool? forbidden,
    List<FoodSupply>? items,
    int? page,
    int? total,
    bool? hasMore,
    String? search,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return StockState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      submitting: submitting ?? this.submitting,
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

class StockController extends Notifier<StockState> {
  FoodSupplyRepository get _repository => locator<FoodSupplyRepository>();

  Timer? _searchDebounce;

  @override
  StockState build() {
    ref.onDispose(() => _searchDebounce?.cancel());
    Future.microtask(loadInitial);
    return const StockState(loading: true);
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
    state = state.copyWith(search: query, clearError: true, clearForbidden: true);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _fetch(page: 1, append: false, forceLoading: true);
    });
  }

  Future<FoodSupply?> createSupply(FoodSupplyRequest request) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final created = await _repository.create(request);
      await refresh();
      state = state.copyWith(submitting: false);
      return created;
    } on ApiException catch (e) {
      state = state.copyWith(submitting: false, error: e.message);
      rethrow;
    } catch (_) {
      state = state.copyWith(
        submitting: false,
        error: 'Failed to create supply',
      );
      rethrow;
    }
  }

  Future<FoodSupply?> updateSupply(String id, FoodSupplyRequest request) async {
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final updated = await _repository.update(id, request);
      final items = state.items
          .map((item) => item.id == id ? updated : item)
          .toList(growable: false);
      state = state.copyWith(items: items, submitting: false);
      return updated;
    } on ApiException catch (e) {
      state = state.copyWith(submitting: false, error: e.message);
      rethrow;
    } catch (_) {
      state = state.copyWith(
        submitting: false,
        error: 'Failed to update supply',
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
    state = state.copyWith(
      loading: forceLoading || (!refreshing && !loadingMore && !append),
      refreshing: refreshing,
      loadingMore: loadingMore,
      clearError: true,
      clearForbidden: true,
    );

    try {
      final PaginatedResponse<FoodSupply> response =
          await _repository.fetchFoodSupplies(
        page: page,
        perPage: FoodSupplyRepository.defaultPerPage,
        search: state.search,
      );

      final merged = append ? [...state.items, ...response.items] : response.items;

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
      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: 'Failed to load stock',
        items: append ? state.items : const [],
      );
    }
  }
}

final stockProvider = NotifierProvider<StockController, StockState>(
  StockController.new,
);
