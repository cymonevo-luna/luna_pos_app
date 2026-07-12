import '../../../core/network/api_client.dart';
import '../../../core/network/paginated_response.dart';
import '../models/purchase_request.dart';

class PurchaseRequestRepository {
  PurchaseRequestRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;

  Future<PaginatedResponse<PurchaseRequestSummary>> list({
    int page = 1,
    int perPage = defaultPerPage,
    PurchaseRequestStatus? status,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null) {
      query['status'] = _statusQueryValue(status);
    }

    return _api.get<PaginatedResponse<PurchaseRequestSummary>>(
      '/api/admin/purchase-requests',
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        PurchaseRequestSummary.fromJson,
      ),
    );
  }

  static String _statusQueryValue(PurchaseRequestStatus status) =>
      switch (status) {
        PurchaseRequestStatus.pending => 'PENDING',
        PurchaseRequestStatus.requested => 'REQUESTED',
        PurchaseRequestStatus.paid => 'PAID',
        PurchaseRequestStatus.delivered => 'DELIVERED',
      };
}
