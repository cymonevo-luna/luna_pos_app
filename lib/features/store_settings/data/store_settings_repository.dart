import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../models/store_settings.dart';

class StoreSettingsRepository {
  StoreSettingsRepository(this._api);

  final ApiClient _api;

  Future<StoreSettings> fetchStoreSettings() {
    return _api.get<StoreSettings>(
      '/api/v1/pos/store-settings',
      decoder: (raw) => StoreSettings.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
