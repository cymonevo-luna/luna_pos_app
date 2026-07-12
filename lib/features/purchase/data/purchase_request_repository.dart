import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/purchase_request.dart';

class PurchaseRequestRepository {
  PurchaseRequestRepository(this._api);

  final ApiClient _api;

  static const listPath = '/api/admin/purchase-requests';
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
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        PurchaseRequestSummary.fromJson,
      ),
    );
  }

  Future<PurchaseRequestDetail> get(String id) => _api.get<PurchaseRequestDetail>(
        '$listPath/$id',
        decoder: (raw) =>
            PurchaseRequestDetail.fromJson(unwrapApiEnvelope(raw)),
      );

  Future<PurchaseRequestDetail> updateStatus(
    String id,
    PurchaseRequestStatus status, {
    String? proofUrl,
  }) {
    final body = <String, dynamic>{
      'status': _statusQueryValue(status),
      if (proofUrl != null && proofUrl.isNotEmpty) 'proof_url': proofUrl,
    };
    return _api.patch<PurchaseRequestDetail>(
      '$listPath/$id/status',
      body: body,
      decoder: (raw) =>
          PurchaseRequestDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<PurchaseRequestDetail> create({
    required String supplierId,
    required List<PurchaseLineCreateInput> items,
    String? notes,
  }) {
    final trimmedNotes = notes?.trim();
    return _api.post<PurchaseRequestDetail>(
      listPath,
      body: {
        'supplier_id': supplierId,
        'items': items
            .map(
              (item) => {
                'food_supply_id': item.foodSupplyId,
                'quantity': item.quantity.toString(),
              },
            )
            .toList(),
        if (trimmedNotes != null && trimmedNotes.isNotEmpty)
          'notes': trimmedNotes,
      },
      decoder: (raw) =>
          PurchaseRequestDetail.fromJson(unwrapApiEnvelope(raw)),
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

class PurchaseLineCreateInput {
  const PurchaseLineCreateInput({
    required this.foodSupplyId,
    required this.quantity,
  });

  final String foodSupplyId;
  final num quantity;
}
