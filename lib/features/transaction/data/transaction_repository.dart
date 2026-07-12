import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/transaction.dart';

class TransactionRepository {
  TransactionRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;

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

  Future<PaginatedResponse<TransactionListItem>> fetchTransactions({
    int page = 1,
    int perPage = defaultPerPage,
    DateTime? dateFrom,
    DateTime? dateTo,
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

    return _api.get<PaginatedResponse<TransactionListItem>>(
      '/api/v1/pos/transactions',
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        TransactionListItem.fromJson,
      ),
    );
  }

  Future<TransactionDetail> fetchTransactionDetail(String id) {
    return _api.get<TransactionDetail>(
      '/api/v1/pos/transactions/$id',
      decoder: (raw) =>
          TransactionDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  static String _formatQueryDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
