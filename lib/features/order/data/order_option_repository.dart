import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/resource_cache.dart';
import '../models/order_option.dart';

class OrderOptionRepository {
  OrderOptionRepository(this._api, this._cache);

  static const orderOptionsPath = '/api/v1/pos/order-options';
  static const orderOptionsCacheKey = 'GET:$orderOptionsPath';

  final ApiClient _api;
  final ResourceCache _cache;

  Future<OrderOptionsResponse> fetchOrderOptions({bool forceRefresh = false}) {
    return _cache.get(
      orderOptionsCacheKey,
      () => _api.get<OrderOptionsResponse>(
        orderOptionsPath,
        decoder: (raw) =>
            OrderOptionsResponse.fromJson(unwrapApiEnvelope(raw)),
      ),
      forceRefresh: forceRefresh,
    );
  }

  void invalidateOrderOptions() => _cache.invalidate(orderOptionsCacheKey);
}
