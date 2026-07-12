import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import 'data/purchase_request_repository.dart';
import 'models/purchase_request.dart';

class PurchaseListFilter {
  const PurchaseListFilter({this.status});

  final PurchaseRequestStatus? status;

  PurchaseListFilter copyWith({
    PurchaseRequestStatus? status,
    bool clearStatus = false,
  }) {
    return PurchaseListFilter(
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}

class PurchaseListState {
  const PurchaseListState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.error,
    this.forbidden = false,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.filter = const PurchaseListFilter(),
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final String? error;
  final bool forbidden;
  final List<PurchaseRequestSummary> items;
  final int page;
  final int total;
  final bool hasMore;
  final PurchaseListFilter filter;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  PurchaseListState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    String? error,
    bool? forbidden,
    List<PurchaseRequestSummary>? items,
    int? page,
    int? total,
    bool? hasMore,
    PurchaseListFilter? filter,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return PurchaseListState(
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

class PurchaseListController extends Notifier<PurchaseListState> {
  PurchaseRequestRepository get _repository =>
      locator<PurchaseRequestRepository>();

  @override
  PurchaseListState build() {
    Future.microtask(loadInitial);
    return const PurchaseListState(loading: true);
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

  Future<void> applyStatusFilter(PurchaseRequestStatus? status) async {
    state = state.copyWith(
      filter: PurchaseListFilter(status: status),
      clearError: true,
      clearForbidden: true,
    );
    await _fetch(page: 1, append: false, forceLoading: true);
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
      final PaginatedResponse<PurchaseRequestSummary> response =
          await _repository.list(
        page: page,
        perPage: PurchaseRequestRepository.defaultPerPage,
        status: state.filter.status,
      );

      final merged = append
          ? [...state.items, ...response.items]
          : response.items;

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
        error: 'Failed to load purchase requests',
        items: append ? state.items : const [],
      );
    }
  }
}

final purchaseListProvider =
    NotifierProvider<PurchaseListController, PurchaseListState>(
  PurchaseListController.new,
);
