import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../../../core/network/resource_cache.dart';
import '../models/production_request.dart';

class ProductionRequestRepository {
  ProductionRequestRepository(this._api, this._cache);

  final ApiClient _api;
  final ResourceCache _cache;

  static const defaultPerPage = 20;
  static const listPath = '/api/v1/pos/production-requests';
  static const listCachePrefix = 'GET:$listPath';

  Future<PaginatedResponse<ProductionRequestSummary>> fetchProductionRequests({
    String status = ProductionRequestStatus.readyToPick,
    int page = 1,
    int perPage = defaultPerPage,
    bool forceRefresh = false,
  }) {
    final query = {
      'status': status,
      'page': page,
      'per_page': perPage,
    };
    final cacheKey = resourceCacheKey('GET', listPath, query);

    return _cache.get(
      cacheKey,
      () => _api.get<PaginatedResponse<ProductionRequestSummary>>(
        listPath,
        query: query,
        decoder: (raw) => decodePaginatedEnvelope(
          raw,
          ProductionRequestSummary.fromJson,
        ),
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<ProductionRequestDetail> fetchProductionRequestDetail(String id) {
    return _api.get<ProductionRequestDetail>(
      '$listPath/$id',
      decoder: (raw) =>
          ProductionRequestDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<ProductionRequestDetail> markDone(String id) {
    invalidateProductionRequestList();
    return _api.patch<ProductionRequestDetail>(
      '$listPath/$id/status',
      body: {'status': ProductionRequestStatus.done},
      decoder: (raw) =>
          ProductionRequestDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  void invalidateProductionRequestList() =>
      _cache.invalidatePrefix(listCachePrefix);
}
