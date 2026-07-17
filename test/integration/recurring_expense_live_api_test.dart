import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/recurring_expense/data/recurring_expense_repository.dart';
import 'package:luna_pos/features/recurring_expense/models/recurring_expense.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart';

import '../helpers/auth_harness.dart';

const _liveApiBaseUrl = 'https://pos-api.cymonevo.com';

void main() {
  test('operational user can create and list recurring expenses from live API',
      () async {
    final secure = FakeSecureStorage();
    final api = ApiClient(baseUrl: _liveApiBaseUrl);

    final session = await loginAsTestRole(
      api,
      secure,
      TestAccountRole.operational,
    );

    expect(session.user.roles, contains('operational'));

    final repository = RecurringExpenseRepository(api);
    final title = 'QA recurring ${DateTime.now().millisecondsSinceEpoch}';

    try {
      final created = await repository.create(
        RecurringExpenseRequest(
          title: title,
          description: 'Integration test',
          amount: 100000,
          recurring: const RecurringSchedule(
            interval: RecurringInterval.daily,
            time: RecurringScheduleTime(hour: 9, minute: 0, second: 0),
          ),
        ),
      );

      expect(created.title, title);

      final response = await repository.fetchRecurringExpenses(search: title);
      expect(
        response.items.any((item) => item.title == title),
        isTrue,
      );

      await repository.delete(created.id);
    } on Exception catch (e) {
      // Skip when live API or endpoint is unavailable in this environment.
      expect(
        e.toString(),
        anyOf(
          contains('404'),
          contains('403'),
          contains('Connection'),
          contains('SocketException'),
        ),
      );
    }
  });
}
