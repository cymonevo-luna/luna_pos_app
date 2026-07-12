import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/supplier.dart';

class SupplierRepository {
  SupplierRepository(this._api);

  final ApiClient _api;

  static const listPath = '/api/admin/suppliers';
  static const defaultPerPage = 20;

  Future<PaginatedResponse<SupplierSummary>> list({
    int page = 1,
    int perPage = defaultPerPage,
    String? search,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['search'] = trimmedSearch;
    }

    return _api.get<PaginatedResponse<SupplierSummary>>(
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        SupplierSummary.fromJson,
      ),
    );
  }

  Future<Supplier> get(String id) {
    return _api.get<Supplier>(
      '$listPath/$id',
      decoder: (raw) => Supplier.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
