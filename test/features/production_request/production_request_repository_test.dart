import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/production_request/data/production_request_repository.dart';
import 'package:luna_pos/features/production_request/models/production_request.dart';

import '../../helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<ProductionRequestRepository>(
        () => ProductionRequestRepository(locator<ApiClient>()),
      );
  });

  test('fetchProductionRequests parses paginated summaries', () async {
    adapter.onGet(
      ProductionRequestRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'pr-1',
            'status': 'READY_TO_PICK',
            'item_count': 3,
            'created_at': '2026-07-12T10:00:00Z',
          },
          {
            'id': 'pr-2',
            'status': 'READY_TO_PICK',
            'item_count': 1,
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 2},
      }),
      queryParameters: {
        'status': 'READY_TO_PICK',
        'page': '1',
        'per_page': '20',
      },
    );

    final response =
        await locator<ProductionRequestRepository>().fetchProductionRequests();

    expect(response.items, hasLength(2));
    expect(response.page, 1);
    expect(response.total, 2);
    expect(response.hasMore, isFalse);
    expect(response.items.first.id, 'pr-1');
    expect(response.items.first.status, ProductionRequestStatus.readyToPick);
    expect(response.items.first.itemCount, 3);
    expect(response.items.last.itemCount, 1);
  });

  test('fetchProductionRequestDetail parses items', () async {
    adapter.onGet(
      '${ProductionRequestRepository.listPath}/pr-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'pr-1',
          'status': 'READY_TO_PICK',
          'item_count': 2,
          'items': [
            {
              'menu_title': 'Nasi Goreng',
              'quantity': '2',
              'is_finished': false,
            },
            {
              'menu_title': 'Es Teh',
              'quantity': 1,
              'is_finished': true,
            },
          ],
        },
      }),
    );

    final detail = await locator<ProductionRequestRepository>()
        .fetchProductionRequestDetail('pr-1');

    expect(detail.id, 'pr-1');
    expect(detail.status, ProductionRequestStatus.readyToPick);
    expect(detail.items, hasLength(2));
    expect(detail.items.first.menuTitle, 'Nasi Goreng');
    expect(detail.items.first.quantity, 2);
    expect(detail.items.first.isFinished, isFalse);
    expect(detail.items.last.quantity, 1);
    expect(detail.items.last.isFinished, isTrue);
  });

  test('markDone sends PATCH with DONE status', () async {
    adapter.onPatch(
      '${ProductionRequestRepository.listPath}/pr-1/status',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'pr-1',
          'status': 'DONE',
          'items': [
            {
              'menu_title': 'Nasi Goreng',
              'quantity': 2,
              'is_finished': true,
            },
          ],
        },
      }),
      data: {'status': 'DONE'},
    );

    final detail =
        await locator<ProductionRequestRepository>().markDone('pr-1');

    expect(detail.id, 'pr-1');
    expect(detail.status, ProductionRequestStatus.done);
    expect(detail.items.single.isFinished, isTrue);
  });
}
