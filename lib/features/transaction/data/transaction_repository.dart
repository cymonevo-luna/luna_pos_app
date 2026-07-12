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
        'items': request.items.map((item) {
          final json = item.toJson();
          final note = item.note?.trim();
          if (note == null || note.isEmpty) {
            json.remove('note');
          }
          return json;
        }).toList(),
        'subtotal_amount': request.subtotalAmount,
        'discount_amount': request.discountAmount,
        'amount': request.amount,
        'cash_tendered': request.cashTendered,
        'change_amount': request.changeAmount,
      },
      decoder: (raw) =>
          TransactionResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }
}
