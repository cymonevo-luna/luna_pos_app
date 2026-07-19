import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../../../core/network/resource_cache.dart';
import '../models/cashier_balance.dart';

class CashierBalanceRepository {
  CashierBalanceRepository(this._api, this._cache);

  final ApiClient _api;
  final ResourceCache _cache;

  static const defaultPerPage = 20;
  static const balancePath = '/api/v1/pos/cashier-balance';
  static const entriesPath = '/api/v1/pos/cashier-balance/entries';
  static const adjustmentsPath = '/api/v1/pos/cashier-balance/adjustments';
  static const balanceCacheKey = 'GET:$balancePath';
  static const entriesCachePrefix = 'GET:$entriesPath';

  Future<CashierBalance> fetchBalance({bool forceRefresh = false}) {
    return _cache.get(
      balanceCacheKey,
      () => _api.get<CashierBalance>(
        balancePath,
        decoder: (raw) => CashierBalance.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<PaginatedResponse<CashierBalanceEntry>> fetchEntries({
    int page = 1,
    int perPage = defaultPerPage,
    bool forceRefresh = false,
  }) {
    final query = {
      'page': page,
      'per_page': perPage,
    };
    final cacheKey = resourceCacheKey('GET', entriesPath, query);

    return _cache.get(
      cacheKey,
      () => _api.get<PaginatedResponse<CashierBalanceEntry>>(
        entriesPath,
        query: query,
        decoder: (raw) => decodePaginatedEnvelope(
          raw,
          CashierBalanceEntry.fromJson,
        ),
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<CashierBalanceAdjustmentResponse> createAdjustment(
    CashierBalanceAdjustmentRequest request,
  ) {
    invalidateBalanceCache();
    return _api.post<CashierBalanceAdjustmentResponse>(
      adjustmentsPath,
      body: request.toJson(),
      decoder: (raw) =>
          CashierBalanceAdjustmentResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  void invalidateBalanceCache() {
    _cache.invalidate(balanceCacheKey);
    _cache.invalidatePrefix(entriesCachePrefix);
  }
}
