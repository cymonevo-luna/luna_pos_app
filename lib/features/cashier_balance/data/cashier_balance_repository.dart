import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/cashier_balance.dart';

class CashierBalanceRepository {
  CashierBalanceRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const balancePath = '/api/v1/pos/cashier-balance';
  static const entriesPath = '/api/v1/pos/cashier-balance/entries';
  static const adjustmentsPath = '/api/v1/pos/cashier-balance/adjustments';

  Future<CashierBalance> fetchBalance() {
    return _api.get<CashierBalance>(
      balancePath,
      decoder: (raw) => CashierBalance.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<PaginatedResponse<CashierBalanceEntry>> fetchEntries({
    int page = 1,
    int perPage = defaultPerPage,
  }) {
    return _api.get<PaginatedResponse<CashierBalanceEntry>>(
      entriesPath,
      query: {
        'page': page,
        'per_page': perPage,
      },
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        CashierBalanceEntry.fromJson,
      ),
    );
  }

  Future<CashierBalanceAdjustmentResponse> createAdjustment(
    CashierBalanceAdjustmentRequest request,
  ) {
    return _api.post<CashierBalanceAdjustmentResponse>(
      adjustmentsPath,
      body: request.toJson(),
      decoder: (raw) =>
          CashierBalanceAdjustmentResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
