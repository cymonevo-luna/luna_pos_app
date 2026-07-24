import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/admin_menu.dart';

class AdminMenuRepository {
  AdminMenuRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const listPath = '/api/admin/menus';

  Future<PaginatedResponse<AdminMenu>> fetchMenus({
    int page = 1,
    int perPage = defaultPerPage,
    String? search,
    AdminMenuSortBy? sortBy,
    AdminMenuSortOrder sortOrder = AdminMenuSortOrder.asc,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['search'] = trimmedSearch;
    }
    if (sortBy != null) {
      query['sort_by'] = _sortByToApi(sortBy);
      query['sort_order'] = _sortOrderToApi(sortOrder);
    }

    return _api.get<PaginatedResponse<AdminMenu>>(
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        AdminMenu.fromJson,
      ),
    );
  }

  Future<AdminMenu> fetchMenu(String id) {
    return _api.get<AdminMenu>(
      '$listPath/$id',
      decoder: (raw) => AdminMenu.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<AdminMenu> create(AdminMenuRequest request) {
    return _api.post<AdminMenu>(
      listPath,
      body: _requestBody(request),
      decoder: (raw) => AdminMenu.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<AdminMenu> update(String id, AdminMenuRequest request) {
    return _api.put<AdminMenu>(
      '$listPath/$id',
      body: _requestBody(request),
      decoder: (raw) => AdminMenu.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<void> delete(String id) {
    return _api.delete<void>(
      '$listPath/$id',
      decoder: (_) {},
    );
  }

  Map<String, dynamic> _requestBody(AdminMenuRequest request) {
    return {
      'title': request.title,
      'description': request.description ?? '',
      'category_id': request.categoryId,
      if (request.photoUrl != null) 'photo_url': request.photoUrl,
      'sell_price': request.sellPrice,
      'recipe_yield': request.recipeYield,
      'margin_percent': request.marginPercent,
      'vat_percent': request.vatPercent,
    };
  }

  String _sortByToApi(AdminMenuSortBy sortBy) => switch (sortBy) {
        AdminMenuSortBy.title => 'title',
        AdminMenuSortBy.stock => 'stock',
      };

  String _sortOrderToApi(AdminMenuSortOrder sortOrder) => switch (sortOrder) {
        AdminMenuSortOrder.asc => 'asc',
        AdminMenuSortOrder.desc => 'desc',
      };
}
