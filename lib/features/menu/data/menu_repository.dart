import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/resource_cache.dart';
import '../models/pos_menu.dart';

class MenuRepository {
  MenuRepository(this._api, this._cache);

  static const menusPath = '/api/v1/pos/menus';
  static const menusCacheKey = 'GET:$menusPath';

  final ApiClient _api;
  final ResourceCache _cache;

  Future<POSMenusResponse> fetchPOSMenus({bool forceRefresh = false}) {
    return _cache.get(
      menusCacheKey,
      () => _api.get<POSMenusResponse>(
        menusPath,
        decoder: (raw) => POSMenusResponse.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }

  void invalidateMenus() => _cache.invalidate(menusCacheKey);
}
