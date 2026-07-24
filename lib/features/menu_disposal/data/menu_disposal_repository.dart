import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../../../core/network/resource_cache.dart';
import '../../menu/data/menu_repository.dart';
import '../models/menu_disposal.dart';

class MenuDisposalRepository {
  MenuDisposalRepository(this._api, this._cache);

  final ApiClient _api;
  final ResourceCache _cache;

  static const defaultPerPage = 20;
  static const listPath = '/api/v1/pos/menu-disposals';
  static const listCachePrefix = 'GET:$listPath';

  Future<MenuDisposal> createMenuDisposal({
    required String menuId,
    required int quantity,
    String? note,
  }) {
    final trimmedNote = note?.trim();
    final body = <String, dynamic>{
      'menu_id': menuId,
      'quantity': quantity,
    };
    if (trimmedNote != null && trimmedNote.isNotEmpty) {
      body['note'] = trimmedNote;
    }

    _cache.invalidatePrefix(listCachePrefix);
    _cache.invalidate(MenuRepository.menusCacheKey);

    return _api.post<MenuDisposal>(
      listPath,
      body: body,
      decoder: (raw) => MenuDisposal.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<PaginatedResponse<MenuDisposalListItem>> listMenuDisposals({
    int page = 1,
    int perPage = defaultPerPage,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool forceRefresh = false,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (dateFrom != null) {
      query['date_from'] = _formatQueryDate(dateFrom);
    }
    if (dateTo != null) {
      query['date_to'] = _formatQueryDate(dateTo);
    }

    final cacheKey = resourceCacheKey('GET', listPath, query);

    return _cache.get(
      cacheKey,
      () => _api.get<PaginatedResponse<MenuDisposalListItem>>(
        listPath,
        query: query,
        decoder: (raw) => decodePaginatedEnvelope(
          raw,
          MenuDisposalListItem.fromJson,
        ),
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<MenuDisposalListItem> getMenuDisposal(
    String id, {
    bool forceRefresh = false,
  }) {
    final path = '$listPath/$id';
    final cacheKey = resourceCacheKey('GET', path, const {});

    return _cache.get(
      cacheKey,
      () => _api.get<MenuDisposalListItem>(
        path,
        decoder: (raw) =>
            MenuDisposalListItem.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }

  void invalidateList() => _cache.invalidatePrefix(listCachePrefix);

  static String _formatQueryDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
