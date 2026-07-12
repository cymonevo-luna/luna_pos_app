import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/production_request.dart';

class ProductionRequestRepository {
  ProductionRequestRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const listPath = '/api/v1/pos/production-requests';

  Future<PaginatedResponse<ProductionRequestSummary>> fetchProductionRequests({
    String status = ProductionRequestStatus.readyToPick,
    int page = 1,
    int perPage = defaultPerPage,
  }) {
    return _api.get<PaginatedResponse<ProductionRequestSummary>>(
      listPath,
      query: {
        'status': status,
        'page': page,
        'per_page': perPage,
      },
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        ProductionRequestSummary.fromJson,
      ),
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
    return _api.patch<ProductionRequestDetail>(
      '$listPath/$id/status',
      body: {'status': ProductionRequestStatus.done},
      decoder: (raw) =>
          ProductionRequestDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
