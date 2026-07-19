import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/resource_cache.dart';
import '../models/store_settings.dart';

class StoreSettingsRepository {
  StoreSettingsRepository(this._api, this._cache);

  static const storeSettingsPath = '/api/v1/pos/store-settings';
  static const storeSettingsCacheKey = 'GET:$storeSettingsPath';

  final ApiClient _api;
  final ResourceCache _cache;

  Future<StoreSettings> fetchStoreSettings({bool forceRefresh = false}) {
    return _cache.get(
      storeSettingsCacheKey,
      () => _api.get<StoreSettings>(
        storeSettingsPath,
        decoder: (raw) => StoreSettings.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }

  void invalidateStoreSettings() => _cache.invalidate(storeSettingsCacheKey);
}
