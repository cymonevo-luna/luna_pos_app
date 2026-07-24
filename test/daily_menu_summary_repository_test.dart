import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/daily_menu_summary/data/daily_menu_summary_repository.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  Map<String, dynamic> sampleSummaryEnvelope() => {
        'success': true,
        'data': {
          'date_from': '2026-07-24',
          'date_to': '2026-07-24',
          'total_revenue': 125000,
          'total_quantity': 8,
          'menus': [
            {
              'menu_id': 'menu-1',
              'menu_title': 'Nasi Goreng',
              'quantity_sold': 5,
              'revenue': 75000,
            },
            {
              'menu_id': 'menu-2',
              'menu_title': 'Es Teh',
              'quantity_sold': 3,
              'revenue': 50000,
            },
          ],
        },
      };

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<DailyMenuSummaryRepository>(
        () => DailyMenuSummaryRepository(
          locator<ApiClient>(),
          testResourceCache(),
        ),
      );
  });

  test('fetchTodaySummary parses summary response', () async {
    adapter.onGet(
      DailyMenuSummaryRepository.summaryPath,
      (server) => server.reply(200, sampleSummaryEnvelope()),
    );

    final response =
        await locator<DailyMenuSummaryRepository>().fetchTodaySummary();

    expect(response.dateFrom, '2026-07-24');
    expect(response.dateTo, '2026-07-24');
    expect(response.totalQuantity, 8);
    expect(response.totalRevenue, 125000);
    expect(response.menus, hasLength(2));
    expect(response.menus.first.menuId, 'menu-1');
    expect(response.menus.first.menuTitle, 'Nasi Goreng');
    expect(response.menus.first.quantitySold, 5);
    expect(response.menus.first.revenue, 75000);
    expect(response.menus.last.menuId, 'menu-2');
    expect(response.menus.last.menuTitle, 'Es Teh');
    expect(response.menus.last.quantitySold, 3);
    expect(response.menus.last.revenue, 50000);
  });

  test('fetchTodaySummary parses RFC3339 date_from and date_to', () async {
    adapter.onGet(
      DailyMenuSummaryRepository.summaryPath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'date_from': '2026-07-24T00:00:00Z',
          'date_to': '2026-07-24T23:59:59Z',
          'total_revenue': 0,
          'total_quantity': 0,
          'menus': <Map<String, dynamic>>[],
        },
      }),
    );

    final response =
        await locator<DailyMenuSummaryRepository>().fetchTodaySummary();

    expect(response.dateFrom, '2026-07-24T00:00:00Z');
    expect(response.dateTo, '2026-07-24T23:59:59Z');
    expect(response.totalQuantity, 0);
    expect(response.totalRevenue, 0);
    expect(response.menus, isEmpty);
  });

  test('fetchTodaySummary calls correct endpoint without date params', () async {
    adapter.onGet(
      DailyMenuSummaryRepository.summaryPath,
      (server) => server.replyCallback(
        200,
        (request) {
          expect(request.path, DailyMenuSummaryRepository.summaryPath);
          expect(request.queryParameters, isEmpty);
          return sampleSummaryEnvelope();
        },
      ),
    );

    await locator<DailyMenuSummaryRepository>().fetchTodaySummary();
  });
}
