import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/resource_cache.dart';
import 'data/daily_menu_summary_repository.dart';
import 'models/daily_menu_summary.dart';

class DailyMenuSummaryState {
  const DailyMenuSummaryState({
    this.loading = false,
    this.error,
    this.forbidden = false,
    this.summary,
  });

  final bool loading;
  final String? error;
  final bool forbidden;
  final DailyMenuSummaryResponse? summary;

  DailyMenuSummaryState copyWith({
    bool? loading,
    String? error,
    bool? forbidden,
    DailyMenuSummaryResponse? summary,
    bool clearError = false,
    bool clearForbidden = false,
    bool clearSummary = false,
  }) {
    return DailyMenuSummaryState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      summary: clearSummary ? null : (summary ?? this.summary),
    );
  }
}

class DailyMenuSummaryController extends Notifier<DailyMenuSummaryState> {
  DailyMenuSummaryRepository get _repository =>
      locator<DailyMenuSummaryRepository>();

  DateTime? _fetchedAt;

  @override
  DailyMenuSummaryState build() => const DailyMenuSummaryState();

  Future<void> loadIfNeeded() async {
    if (state.loading) return;

    final fetchedAt = _fetchedAt;
    if (state.summary != null &&
        state.error == null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
      return;
    }

    if (state.summary == null && state.error == null) {
      await _fetch();
    }
  }

  Future<void> refresh() => _fetch(forceRefresh: true);

  Future<void> retry() => _fetch(forceLoading: true);

  Future<void> _fetch({
    bool forceLoading = false,
    bool forceRefresh = false,
  }) async {
    if (!ref.mounted) return;
    state = state.copyWith(
      loading: forceLoading || state.summary == null,
      clearError: true,
      clearForbidden: true,
    );

    try {
      final summary =
          await _repository.fetchTodaySummary(forceRefresh: forceRefresh);
      if (!ref.mounted) return;
      _fetchedAt = DateTime.now();
      state = state.copyWith(loading: false, summary: summary);
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          forbidden: true,
          error: e.message,
          clearSummary: true,
        );
        return;
      }

      state = state.copyWith(
        loading: false,
        error: e.message,
        clearSummary: true,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        error: 'Failed to load daily menu summary',
        clearSummary: true,
      );
    }
  }
}

final dailyMenuSummaryController =
    NotifierProvider<DailyMenuSummaryController, DailyMenuSummaryState>(
  DailyMenuSummaryController.new,
);
