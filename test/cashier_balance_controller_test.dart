import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/cashier_balance/cashier_balance_controller.dart';
import 'package:luna_pos/features/cashier_balance/data/cashier_balance_repository.dart';
import 'package:luna_pos/features/cashier_balance/models/cashier_balance.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<CashierBalanceRepository>(
        () => CashierBalanceRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> waitForInitialLoad() async {
    container.read(cashierBalanceController.notifier);
    for (var i = 0;
        i < 50 && container.read(cashierBalanceController).loading;
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('loadInitial sets balance and entries from repository', () async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 150000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'entry-1',
            'amount': 25000,
            'purpose': 'POS test',
            'requested_by_username': 'cashier-test',
            'type': 'ADD',
            'created_at': '2026-07-18T10:00:00Z',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await waitForInitialLoad();

    final state = container.read(cashierBalanceController);
    expect(state.balance?.balance, 150000);
    expect(state.entries, hasLength(1));
    expect(state.entries.first.purpose, 'POS test');
    expect(state.entries.first.requestedByUsername, 'cashier-test');
    expect(state.loading, isFalse);
  });

  test('adjustBalance updates balance and prepends entry', () async {
    adapter.onGet(
      CashierBalanceRepository.balancePath,
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'balance': 100000,
          'updated_at': '2026-07-18T10:00:00Z',
        },
      }),
    );
    adapter.onGet(
      CashierBalanceRepository.entriesPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onPost(
      CashierBalanceRepository.adjustmentsPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'balance': {
            'balance': 125000,
            'updated_at': '2026-07-18T10:05:00Z',
          },
          'entry': {
            'id': 'entry-2',
            'amount': 25000,
            'purpose': 'POS test',
            'requested_by_username': 'cashier-test',
            'type': 'ADD',
            'created_at': '2026-07-18T10:05:00Z',
          },
        },
      }),
      data: {
        'amount': 25000,
        'purpose': 'POS test',
        'type': 'ADD',
      },
    );

    await waitForInitialLoad();

    await container.read(cashierBalanceController.notifier).adjustBalance(
          const CashierBalanceAdjustmentRequest(
            amount: 25000,
            purpose: 'POS test',
            type: CashierBalanceAdjustmentType.add,
          ),
        );

    final state = container.read(cashierBalanceController);
    expect(state.balance?.balance, 125000);
    expect(state.entries.first.id, 'entry-2');
    expect(state.entries.first.signedAmount, 25000);
  });
}
