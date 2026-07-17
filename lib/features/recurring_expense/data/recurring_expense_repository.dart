import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/paginated_response.dart';
import '../models/recurring_expense.dart';

class RecurringExpenseRepository {
  RecurringExpenseRepository(this._api);

  final ApiClient _api;

  static const defaultPerPage = 20;
  static const listPath = '/api/admin/recurring-expenses';
  static const staffManagedConflictMessage =
      'This recurring expense is managed by staff salary.';

  Future<PaginatedResponse<RecurringExpense>> fetchRecurringExpenses({
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

    return _api.get<PaginatedResponse<RecurringExpense>>(
      listPath,
      query: query,
      decoder: (raw) => decodePaginatedEnvelope(
        raw,
        RecurringExpense.fromJson,
      ),
    );
  }

  Future<RecurringExpense> fetchRecurringExpense(String id) {
    return _api.get<RecurringExpense>(
      '$listPath/$id',
      decoder: (raw) => RecurringExpense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<RecurringExpense> create(RecurringExpenseRequest request) {
    return _api.post<RecurringExpense>(
      listPath,
      body: _requestBody(request),
      decoder: (raw) => RecurringExpense.fromJson(unwrapApiEnvelope(raw)),
    );
  }

  Future<RecurringExpense> update(String id, RecurringExpenseRequest request) {
    return _guardStaffManagedConflict(
      () => _api.put<RecurringExpense>(
        '$listPath/$id',
        body: _requestBody(request),
        decoder: (raw) => RecurringExpense.fromJson(unwrapApiEnvelope(raw)),
      ),
    );
  }

  Future<void> delete(String id) {
    return _guardStaffManagedConflict(
      () => _api.delete<void>(
        '$listPath/$id',
        decoder: (_) {},
      ),
    );
  }

  Future<T> _guardStaffManagedConflict<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        throw ApiException(
          type: ApiErrorType.conflict,
          message: staffManagedConflictMessage,
          statusCode: 409,
          data: e.data,
        );
      }
      rethrow;
    }
  }

  Map<String, dynamic> _requestBody(RecurringExpenseRequest request) {
    final body = <String, dynamic>{
      'title': request.title,
      'description': request.description ?? '',
      'amount': request.amount,
      'recurring': _recurringBody(request.recurring),
    };
    if (request.isActive != null) {
      body['is_active'] = request.isActive;
    }
    return body;
  }

  Map<String, dynamic> _recurringBody(RecurringSchedule schedule) {
    final recurring = <String, dynamic>{
      'interval': _intervalToApi(schedule.interval),
      'time': {
        'hour': schedule.time.hour,
        'minute': schedule.time.minute,
        'second': schedule.time.second,
      },
    };
    if (schedule.interval != RecurringInterval.daily && schedule.value != null) {
      recurring['value'] = schedule.value;
    }
    return recurring;
  }

  String _intervalToApi(RecurringInterval interval) => switch (interval) {
        RecurringInterval.date => 'DATE',
        RecurringInterval.day => 'DAY',
        RecurringInterval.daily => 'DAILY',
      };
}
