import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/resource_cache.dart';
import '../models/daily_menu_summary.dart';

class DailyMenuSummaryRepository {
  DailyMenuSummaryRepository(this._api, this._cache);

  final ApiClient _api;
  final ResourceCache _cache;

  static const summaryPath = '/api/v1/pos/transactions/summary/by-menu';
  static const summaryCacheKey = 'GET:$summaryPath';

  Future<DailyMenuSummaryResponse> fetchTodaySummary({
    bool forceRefresh = false,
  }) {
    return _cache.get(
      summaryCacheKey,
      () => _api.get<DailyMenuSummaryResponse>(
        summaryPath,
        decoder: (raw) =>
            DailyMenuSummaryResponse.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }
}
