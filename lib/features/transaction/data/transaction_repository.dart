import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../../../core/network/resource_cache.dart';
import '../models/transaction.dart';

class TransactionRepository {
  TransactionRepository(this._api, this._cache);

  final ApiClient _api;
  final ResourceCache _cache;

  static const defaultPerPage = 20;
  static const listPath = '/api/v1/pos/transactions';
  static const listCachePrefix = 'GET:$listPath';

  Future<TransactionResponse> createTransaction(
    CreateTransactionRequest request,
  ) {
    final body = <String, dynamic>{
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
      'order_option_id': request.orderOptionId,
    };
    if (request.cashTendered != null) {
      body['cash_tendered'] = request.cashTendered;
    }
    if (request.changeAmount != null) {
      body['change_amount'] = request.changeAmount;
    }

    _cache.invalidatePrefix(listCachePrefix);

    return _api.post<TransactionResponse>(
      listPath,
      body: body,
      decoder: (raw) =>
          TransactionResponse.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<PaginatedResponse<TransactionListItem>> fetchTransactions({
    int page = 1,
    int perPage = defaultPerPage,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool forceRefresh = false,
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

    final cacheKey = resourceCacheKey('GET', listPath, query);

    return _cache.get(
      cacheKey,
      () => _api.get<PaginatedResponse<TransactionListItem>>(
        listPath,
        query: query,
        decoder: (raw) => decodePaginatedEnvelope(
          raw,
          TransactionListItem.fromJson,
        ),
      ),
      forceRefresh: forceRefresh,
    );
  }

  Future<TransactionDetail> fetchTransactionDetail(String id) {
    return _api.get<TransactionDetail>(
      '$listPath/$id',
      decoder: (raw) =>
          TransactionDetail.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  void invalidateTransactionList() => _cache.invalidatePrefix(listCachePrefix);

  static String _formatQueryDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
