import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/api_exception.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
import 'package:luna_pos/features/daily_menu_summary/daily_menu_summary_controller.dart';
import 'package:luna_pos/features/daily_menu_summary/data/daily_menu_summary_repository.dart';
import 'package:luna_pos/features/daily_menu_summary/models/daily_menu_summary.dart';

import 'helpers/auth_harness.dart';

class _FakeDailyMenuSummaryRepository extends DailyMenuSummaryRepository {
  _FakeDailyMenuSummaryRepository(this._handler)
      : super(_noopApiClient(), ResourceCache());

  final Future<DailyMenuSummaryResponse> Function({bool forceRefresh}) _handler;

  @override
  Future<DailyMenuSummaryResponse> fetchTodaySummary({
    bool forceRefresh = false,
  }) {
    return _handler(forceRefresh: forceRefresh);
  }
}

ApiClient _noopApiClient() => buildMockedApiClient().client;

void main() {
  late ProviderContainer container;

  DailyMenuSummaryResponse sampleSummary() => const DailyMenuSummaryResponse(
        dateFrom: '2026-07-24',
        dateTo: '2026-07-24',
        totalRevenue: 125000,
        totalQuantity: 8,
        menus: [
          DailyMenuSummaryItem(
            menuId: 'menu-1',
            menuTitle: 'Nasi Goreng',
            quantitySold: 5,
            revenue: 75000,
          ),
          DailyMenuSummaryItem(
            menuId: 'menu-2',
            menuTitle: 'Es Teh',
            quantitySold: 3,
            revenue: 50000,
          ),
        ],
      );

  setUp(() async {
    await locator.reset();
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> waitForLoad() async {
    await container.read(dailyMenuSummaryController.notifier).loadIfNeeded();
    for (var i = 0;
        i < 50 && container.read(dailyMenuSummaryController).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('loadIfNeeded loads summary successfully', () async {
    locator.registerLazySingleton<DailyMenuSummaryRepository>(
      () => _FakeDailyMenuSummaryRepository(
        ({bool forceRefresh = false}) async => sampleSummary(),
      ),
    );

    await waitForLoad();

    final state = container.read(dailyMenuSummaryController);
    expect(state.loading, isFalse);
    expect(state.error, isNull);
    expect(state.forbidden, isFalse);
    expect(state.summary?.totalQuantity, 8);
    expect(state.summary?.totalRevenue, 125000);
    expect(state.summary?.menus, hasLength(2));
    expect(state.summary?.menus.first.menuTitle, 'Nasi Goreng');
  });

  test('loadIfNeeded handles 403 forbidden', () async {
    locator.registerLazySingleton<DailyMenuSummaryRepository>(
      () => _FakeDailyMenuSummaryRepository(
        ({bool forceRefresh = false}) async {
          throw const ApiException(
            type: ApiErrorType.forbidden,
            message: 'You don\'t have access to this.',
            statusCode: 403,
          );
        },
      ),
    );

    await waitForLoad();

    final state = container.read(dailyMenuSummaryController);
    expect(state.loading, isFalse);
    expect(state.forbidden, isTrue);
    expect(state.summary, isNull);
  });
}
