import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../models/pos_menu.dart';

class MenuRepository {
  MenuRepository(this._api);

  final ApiClient _api;

  Future<POSMenusResponse> fetchPOSMenus() {
    return _api.get<POSMenusResponse>(
      '/api/v1/pos/menus',
      decoder: (raw) => POSMenusResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
