import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart';

import '../helpers/auth_harness.dart';

const _liveApiBaseUrl = 'https://pos-api.cymonevo.com';

void main() {
  test('operational user can list food supplies from live API', () async {
    final secure = FakeSecureStorage();
    final api = ApiClient(baseUrl: _liveApiBaseUrl);

    final session = await loginAsTestRole(
      api,
      secure,
      TestAccountRole.operational,
    );

    expect(session.user.roles, contains('operational'));

    final repository = FoodSupplyRepository(api);
    final response = await repository.fetchFoodSupplies();

    expect(response.items, isA<List>());
    expect(response.page, greaterThanOrEqualTo(1));
    expect(response.total, greaterThanOrEqualTo(0));
  });
}
