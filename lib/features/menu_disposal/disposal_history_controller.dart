import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import '../../core/network/resource_cache.dart';
import 'data/menu_disposal_repository.dart';
import 'models/menu_disposal.dart';

class DisposalHistoryFilter {
  const DisposalHistoryFilter({this.dateFrom, this.dateTo});

  final DateTime? dateFrom;
  final DateTime? dateTo;

  bool get hasDateRange => dateFrom != null || dateTo != null;

  DisposalHistoryFilter copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearDateFrom = false,
    bool clearDateTo = false,
  }) {
    return DisposalHistoryFilter(
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
    );
  }
}

class DisposalHistoryState {
  const DisposalHistoryState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.error,
    this.forbidden = false,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.filter = const DisposalHistoryFilter(),
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final String? error;
  final bool forbidden;
  final List<MenuDisposalListItem> items;
  final int page;
  final int total;
  final bool hasMore;
  final DisposalHistoryFilter filter;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  DisposalHistoryState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    String? error,
    bool? forbidden,
    List<MenuDisposalListItem>? items,
    int? page,
    int? total,
    bool? hasMore,
    DisposalHistoryFilter? filter,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return DisposalHistoryState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      filter: filter ?? this.filter,
    );
  }
}

class DisposalHistoryController extends Notifier<DisposalHistoryState> {
  MenuDisposalRepository get _repository => locator<MenuDisposalRepository>();

  DateTime? _fetchedAt;

  @override
  DisposalHistoryState build() => const DisposalHistoryState();

  Future<void> loadIfNeeded() async {
    if (state.loading || state.refreshing) return;

    final fetchedAt = _fetchedAt;
    if (state.items.isNotEmpty &&
        state.error == null &&
        !state.filter.hasDateRange &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
      return;
    }

    if (state.items.isEmpty && state.error == null) {
      await loadInitial();
      return;
    }

    if (fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
      return;
    }

    await loadInitial();
  }

  Future<void> loadInitial() => _fetch(page: 1, append: false);

  Future<void> refresh() =>
      _fetch(page: 1, append: false, refreshing: true, forceRefresh: true);

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

  Future<void> applyDateFilter({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    state = state.copyWith(
      filter: DisposalHistoryFilter(dateFrom: dateFrom, dateTo: dateTo),
      clearError: true,
      clearForbidden: true,
    );
    await _fetch(page: 1, append: false, forceLoading: true, forceRefresh: true);
  }

  Future<void> clearDateFilter() => applyDateFilter();

  Future<void> _fetch({
    required int page,
    required bool append,
    bool refreshing = false,
    bool loadingMore = false,
    bool forceLoading = false,
    bool forceRefresh = false,
  }) async {
    state = state.copyWith(
      loading: forceLoading || (!refreshing && !loadingMore && !append),
      refreshing: refreshing,
      loadingMore: loadingMore,
      clearError: true,
      clearForbidden: true,
    );

    try {
      final PaginatedResponse<MenuDisposalListItem> response =
          await _repository.listMenuDisposals(
        page: page,
        perPage: MenuDisposalRepository.defaultPerPage,
        dateFrom: state.filter.dateFrom,
        dateTo: state.filter.dateTo,
        forceRefresh: forceRefresh,
      );

      final merged = append
          ? [...state.items, ...response.items]
          : response.items;

      if (!append) {
        _fetchedAt = DateTime.now();
      }

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
        error: 'Failed to load disposal history',
        items: append ? state.items : const [],
      );
    }
  }
}

final disposalHistoryProvider =
    NotifierProvider<DisposalHistoryController, DisposalHistoryState>(
  DisposalHistoryController.new,
);
