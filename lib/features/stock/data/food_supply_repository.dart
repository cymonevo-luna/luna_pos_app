import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/food_supply.dart';

class FoodSupplyRepository {
  FoodSupplyRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const listPath = '/api/admin/food-supplies';

  Future<PaginatedResponse<FoodSupply>> fetchFoodSupplies({
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

    return _api.get<PaginatedResponse<FoodSupply>>(
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        FoodSupply.fromJson,
      ),
    );
  }

  Future<FoodSupply> fetchFoodSupply(String id) {
    return _api.get<FoodSupply>(
      '$listPath/$id',
      decoder: (raw) => FoodSupply.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<FoodSupply> create(FoodSupplyRequest request) {
    return _api.post<FoodSupply>(
      listPath,
      body: _requestBody(request),
      decoder: (raw) => FoodSupply.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<FoodSupply> update(String id, FoodSupplyRequest request) {
    return _api.put<FoodSupply>(
      '$listPath/$id',
      body: _requestBody(request),
      decoder: (raw) => FoodSupply.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Map<String, dynamic> _requestBody(FoodSupplyRequest request) {
    return {
      'title': request.title,
      'description': request.description ?? '',
      'stock_quantity': request.stockQuantity,
      'unit': request.unit,
    };
  }
}
