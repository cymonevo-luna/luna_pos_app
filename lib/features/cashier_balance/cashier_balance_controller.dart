import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/paginated_response.dart';
import '../../core/network/resource_cache.dart';
import 'data/cashier_balance_repository.dart';
import 'models/cashier_balance.dart';

class CashierBalanceState {
  const CashierBalanceState({
    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,
    this.submitting = false,
    this.error,
    this.forbidden = false,
    this.balance,
    this.entries = const [],
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
  });

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final bool submitting;
  final String? error;
  final bool forbidden;
  final CashierBalance? balance;
  final List<CashierBalanceEntry> entries;
  final int page;
  final int total;
  final bool hasMore;

  bool get isEmpty =>
      !loading && error == null && !forbidden && entries.isEmpty;

  CashierBalanceState copyWith({
    bool? loading,
    bool? refreshing,
    bool? loadingMore,
    bool? submitting,
    String? error,
    bool? forbidden,
    CashierBalance? balance,
    List<CashierBalanceEntry>? entries,
    int? page,
    int? total,
    bool? hasMore,
    bool clearError = false,
    bool clearForbidden = false,
    bool clearBalance = false,
  }) {
    return CashierBalanceState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      balance: clearBalance ? null : (balance ?? this.balance),
      entries: entries ?? this.entries,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CashierBalanceController extends Notifier<CashierBalanceState> {
  CashierBalanceRepository get _repository =>
      locator<CashierBalanceRepository>();

  DateTime? _fetchedAt;

  @override
  CashierBalanceState build() => const CashierBalanceState();

  Future<void> loadIfNeeded() async {
    if (state.loading || state.refreshing) return;

    final fetchedAt = _fetchedAt;
    if (state.entries.isNotEmpty &&
        state.balance != null &&
        state.error == null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
      return;
    }

    if (state.entries.isEmpty && state.error == null) {
      await loadInitial();
    }
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

  Future<void> adjustBalance(CashierBalanceAdjustmentRequest request) async {
    if (!ref.mounted) return;
    state = state.copyWith(submitting: true, clearError: true);
    try {
      final response = await _repository.createAdjustment(request);
      if (!ref.mounted) return;
      final entries = [
        response.entry,
        ...state.entries.where((entry) => entry.id != response.entry.id),
      ];
      _fetchedAt = DateTime.now();
      state = state.copyWith(
        submitting: false,
        balance: response.balance,
        entries: entries,
      );
    } on ApiException catch (e) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(submitting: false, error: e.message);
      rethrow;
    } catch (_) {
      if (!ref.mounted) rethrow;
      state = state.copyWith(
        submitting: false,
        error: 'Failed to adjust cashier balance',
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
    bool forceRefresh = false,
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
      final balanceFuture = append
          ? null
          : _repository.fetchBalance(forceRefresh: forceRefresh);
      final PaginatedResponse<CashierBalanceEntry> entriesResponse =
          await _repository.fetchEntries(
        page: page,
        perPage: CashierBalanceRepository.defaultPerPage,
        forceRefresh: forceRefresh,
      );
      final balance = balanceFuture != null ? await balanceFuture : null;

      if (!ref.mounted) return;

      final merged = append
          ? [...state.entries, ...entriesResponse.items]
          : entriesResponse.items;

      if (!append) {
        _fetchedAt = DateTime.now();
      }

      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        balance: balance ?? state.balance,
        entries: merged,
        page: entriesResponse.page,
        total: entriesResponse.total,
        hasMore: entriesResponse.hasMore,
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
        entries: append ? state.entries : const [],
        clearBalance: !append,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        loadingMore: false,
        error: 'Failed to load cashier balance',
        entries: append ? state.entries : const [],
        clearBalance: !append,
      );
    }
  }
}

final cashierBalanceController =
    NotifierProvider<CashierBalanceController, CashierBalanceState>(
  CashierBalanceController.new,
);
