import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import '../../core/network/validation_errors.dart';
import 'data/production_request_repository.dart';
import 'models/production_request.dart';

String _userVisibleError(ApiException exception) {
  if (exception.type == ApiErrorType.forbidden) {
    return exception.message;
  }
  final validation = validationMessageFor(exception);
  if (validation != null) return validation;
  return exception.message;
}

class ProductionRequestListState {
  const ProductionRequestListState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.error,
    this.forbidden = false,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.status = ProductionRequestStatus.readyToPick,
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final String? error;
  final bool forbidden;
  final List<ProductionRequestSummary> items;
  final int page;
  final int total;
  final bool hasMore;
  final String status;

  bool get isEmpty => !loading && error == null && !forbidden && items.isEmpty;

  ProductionRequestListState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    String? error,
    bool? forbidden,
    List<ProductionRequestSummary>? items,
    int? page,
    int? total,
    bool? hasMore,
    String? status,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return ProductionRequestListState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      status: status ?? this.status,
    );
  }
}

class ProductionRequestListController extends Notifier<ProductionRequestListState> {
  ProductionRequestRepository get _repository =>
      locator<ProductionRequestRepository>();

  @override
  ProductionRequestListState build() {
    Future.microtask(loadInitial);
    return const ProductionRequestListState(loading: true);
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

  Future<void> setStatusFilter(String status) async {
    state = state.copyWith(
      status: status,
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
      final PaginatedResponse<ProductionRequestSummary> response =
          await _repository.fetchProductionRequests(
        status: state.status,
        page: page,
        perPage: ProductionRequestRepository.defaultPerPage,
      );

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
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          refreshing: false,
          loadingMore: false,
          forbidden: true,
          error: _userVisibleError(e),
        );
        return;
      }

      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: _userVisibleError(e),
        items: append ? state.items : const [],
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: 'Failed to load production requests',
        items: append ? state.items : const [],
      );
    }
  }
}

class ProductionRequestDetailState {
  const ProductionRequestDetailState({
    this.loading = false,
    this.markingDone = false,
    this.error,
    this.forbidden = false,
    this.detail,
  });

  final bool loading;
  final bool markingDone;
  final String? error;
  final bool forbidden;
  final ProductionRequestDetail? detail;

  ProductionRequestDetailState copyWith({
    bool? loading,
    bool? markingDone,
    String? error,
    bool? forbidden,
    ProductionRequestDetail? detail,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return ProductionRequestDetailState(
      loading: loading ?? this.loading,
      markingDone: markingDone ?? this.markingDone,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      detail: detail ?? this.detail,
    );
  }
}

class ProductionRequestDetailController extends Notifier<ProductionRequestDetailState> {
  ProductionRequestDetailController(this._requestId);

  final String _requestId;

  ProductionRequestRepository get _repository =>
      locator<ProductionRequestRepository>();

  @override
  ProductionRequestDetailState build() {
    Future.microtask(load);
    return const ProductionRequestDetailState(loading: true);
  }

  Future<void> load() async {
    state = state.copyWith(
      loading: true,
      clearError: true,
      clearForbidden: true,
    );

    try {
      final detail = await _repository.fetchProductionRequestDetail(_requestId);
      state = state.copyWith(loading: false, detail: detail);
    } on ApiException catch (e) {
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          forbidden: true,
          error: _userVisibleError(e),
        );
        return;
      }
      state = state.copyWith(loading: false, error: _userVisibleError(e));
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load production request',
      );
    }
  }

  Future<void> retry() => load();

  Future<bool> markDone() async {
    state = state.copyWith(markingDone: true, clearError: true);

    try {
      final detail = await _repository.markDone(_requestId);
      state = state.copyWith(markingDone: false, detail: detail);
      return true;
    } on ApiException catch (e) {
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          markingDone: false,
          forbidden: true,
          error: _userVisibleError(e),
        );
        return false;
      }
      state = state.copyWith(
        markingDone: false,
        error: _userVisibleError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        markingDone: false,
        error: 'Failed to mark production request as done',
      );
      return false;
    }
  }
}

final productionRequestListProvider =
    NotifierProvider<ProductionRequestListController, ProductionRequestListState>(
  ProductionRequestListController.new,
);

final productionRequestDetailProvider = NotifierProvider.family<
    ProductionRequestDetailController,
    ProductionRequestDetailState,
    String>(
  ProductionRequestDetailController.new,
);
