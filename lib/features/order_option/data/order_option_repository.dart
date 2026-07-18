import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../models/order_option.dart';

class OrderOptionRepository {
  OrderOptionRepository(this._api);

  final ApiClient _api;

  Future<List<OrderOption>> fetchOrderOptions() async {
    final response = await _api.get<OrderOptionsResponse>(
      '/api/v1/pos/order-options',
      decoder: (raw) =>
          OrderOptionsResponse.fromJson(unwrapApiEnvelope(raw)),
    );
    return response.options;
  }
}
