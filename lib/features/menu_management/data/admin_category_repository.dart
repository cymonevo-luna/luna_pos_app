import '../../../core/network/api_client.dart';
import '../../../core/network/paginated_response.dart';
import '../models/admin_category.dart';

class AdminCategoryRepository {
  AdminCategoryRepository(this._api);

  final ApiClient _api;

  static const listPath = '/api/admin/categories';
  static const pickerPerPage = 100;

  Future<PaginatedResponse<AdminCategory>> fetchCategories({
    int page = 1,
    int perPage = pickerPerPage,
  }) {
    return _api.get<PaginatedResponse<AdminCategory>>(
      listPath,
      query: {
        'page': page,
        'per_page': perPage,
      },
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        AdminCategory.fromJson,
      ),
    );
  }
}
