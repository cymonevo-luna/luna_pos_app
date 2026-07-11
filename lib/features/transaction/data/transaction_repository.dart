import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../models/transaction.dart';

class TransactionRepository {
  TransactionRepository(this._api);

  final ApiClient _api;

  Future<TransactionResponse> createOfflineTransaction(
    CreateTransactionRequest request,
  ) {
    return _api.post<TransactionResponse>(
      '/api/v1/pos/transactions',
      body: {
        'method': request.method,
        'items': request.items.map((item) => item.toJson()).toList(),
        'amount': request.amount,
        'cash_tendered': request.cashTendered,
        'change_amount': request.changeAmount,
      },
      decoder: (raw) =>
          TransactionResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
