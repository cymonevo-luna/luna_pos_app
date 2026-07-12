import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/purchase_request.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      );
  });

  test('list parses purchase request summaries', () async {
    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': 'pr-1',
            'supplier_name': 'Toko Sembako Jaya',
            'status': 'REQUESTED',
            'total_estimated_amount': 150000,
            'item_count': 3,
            'created_by_username': 'Operational Test',
            'created_at': '2026-07-12T08:30:00Z',
          },
        ],
        'meta': {
          'page': 1,
          'per_page': PurchaseRequestRepository.defaultPerPage,
          'total': 1,
        },
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final response = await locator<PurchaseRequestRepository>().list();

    expect(response.items, hasLength(1));
    expect(response.items.first.status, PurchaseRequestStatus.requested);
    expect(response.items.first.supplierName, 'Toko Sembako Jaya');
    expect(response.items.first.totalEstimatedAmount, 150000);
    expect(response.items.first.itemCount, 3);
  });

  test('list forwards status filter query param', () async {
    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {
          'page': 1,
          'per_page': PurchaseRequestRepository.defaultPerPage,
          'total': 0,
        },
      }),
      queryParameters: {
        'page': '1',
        'per_page': '20',
        'status': 'PAID',
      },
    );

    final response = await locator<PurchaseRequestRepository>().list(
      status: PurchaseRequestStatus.paid,
    );

    expect(response.items, isEmpty);
    expect(response.total, 0);
  });
}
