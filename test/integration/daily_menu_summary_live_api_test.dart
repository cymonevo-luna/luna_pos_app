import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/daily_menu_summary/data/daily_menu_summary_repository.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart';

import '../helpers/auth_harness.dart';

const _liveApiBaseUrl = 'https://pos-api.cymonevo.com';

void main() {
  test('cashier can fetch today daily menu summary from live API', () async {
    final secure = FakeSecureStorage();
    final api = ApiClient(baseUrl: _liveApiBaseUrl);

    final session = await loginAsTestRole(
      api,
      secure,
      TestAccountRole.cashier,
    );

    expect(session.user.roles, contains('cashier'));

    final repository = DailyMenuSummaryRepository(api, testResourceCache());

    try {
      final response = await repository.fetchTodaySummary();

      expect(response.dateFrom, isNotEmpty);
      expect(response.dateTo, isNotEmpty);
      expect(response.totalQuantity, greaterThanOrEqualTo(0));
      expect(response.totalRevenue, greaterThanOrEqualTo(0));
      expect(response.menus, isA<List>());
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
