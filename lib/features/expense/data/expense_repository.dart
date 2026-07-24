import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/paginated_response.dart';
import '../models/expense.dart';

class ExpenseRepository {
  ExpenseRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const listPath = '/api/admin/expenses';

  Future<PaginatedResponse<Expense>> fetchExpenses({
    int page = 1,
    int perPage = defaultPerPage,
    String? search,
  }) {
    final query = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['search'] = trimmedSearch;
    }

    return _api.get<PaginatedResponse<Expense>>(
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        Expense.fromJson,
      ),
    );
  }

  Future<Expense> fetchExpense(String id) {
    return _api.get<Expense>(
      '$listPath/$id',
      decoder: (raw) => Expense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<Expense> create(ExpenseRequest request) {
    return _api.post<Expense>(
      listPath,
      body: _requestBody(request),
      decoder: (raw) => Expense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<Expense> update(String id, ExpenseRequest request) {
    return _api.put<Expense>(
      '$listPath/$id',
      body: _requestBody(request),
      decoder: (raw) => Expense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<Expense> patchExpenseRecordDate(String expenseId, DateTime recordDate) {
    return _api.patch<Expense>(
      '$listPath/$expenseId/record-date',
      body: {
        'record_date': recordDate.toUtc().toIso8601String(),
      },
      decoder: (raw) => Expense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<void> delete(String id) {
    return _api.delete<void>(
      '$listPath/$id',
      decoder: (_) {},
    );
  }

  Map<String, dynamic> _requestBody(ExpenseRequest request) {
    return {
      'title': request.title,
      'description': request.description ?? '',
      'amount': request.amount,
      'source_of_fund': _sourceOfFundToApi(request.sourceOfFund),
      if (request.receiptUrl != null) 'receipt_url': request.receiptUrl,
    };
  }

  String _sourceOfFundToApi(ExpenseSourceOfFund source) => switch (source) {
        ExpenseSourceOfFund.cashier => 'CASHIER',
        ExpenseSourceOfFund.personalMoney => 'PERSONAL_MONEY',
      };
}
