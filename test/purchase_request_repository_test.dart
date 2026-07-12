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

  test('create posts purchase request body', () async {
    adapter.onPost(
      PurchaseRequestRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'pr-new',
          'supplier_id': 'sup-1',
          'supplier_name': 'Toko Sembako Jaya',
          'status': 'PENDING',
          'total_estimated_amount': 140000,
          'items': [
            {
              'food_supply_id': 'fs-1',
              'food_supply_title': 'Flour',
              'quantity': '1000',
              'unit': 'gr',
            },
          ],
        },
      }),
      data: {
        'supplier_id': 'sup-1',
        'items': [
          {'food_supply_id': 'fs-1', 'quantity': '1000'},
        ],
        'notes': 'weekly restock',
      },
    );

    final created = await locator<PurchaseRequestRepository>().create(
      supplierId: 'sup-1',
      items: const [
        PurchaseLineCreateInput(foodSupplyId: 'fs-1', quantity: 1000),
      ],
      notes: 'weekly restock',
    );

    expect(created.id, 'pr-new');
    expect(created.status, PurchaseRequestStatus.pending);
    expect(created.items, hasLength(1));
    expect(created.items.first.quantity, 1000);
  });

  test('get parses purchase request detail', () async {
    adapter.onGet(
      '/api/admin/purchase-requests/pr-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'pr-1',
          'supplier_id': 'sup-1',
          'supplier_name': 'Toko Sembako Jaya',
          'status': 'PAID',
          'total_estimated_amount': 140000,
          'paid_proof_url': '/uploads/paid.jpg',
          'items': [
            {
              'food_supply_id': 'fs-1',
              'food_supply_title': 'Flour',
              'quantity': '1000',
              'unit': 'gr',
              'unit_price': 140,
              'line_total': 140000,
            },
          ],
        },
      }),
    );

    final detail = await locator<PurchaseRequestRepository>().get('pr-1');

    expect(detail.status, PurchaseRequestStatus.paid);
    expect(detail.paidProofUrl, '/uploads/paid.jpg');
    expect(detail.items.first.lineTotal, 140000);
  });

  test('updateStatus patches status with optional proof url', () async {
    adapter.onPatch(
      '/api/admin/purchase-requests/pr-1/status',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'pr-1',
          'supplier_id': 'sup-1',
          'supplier_name': 'Toko Sembako Jaya',
          'status': 'DELIVERED',
          'delivered_proof_url': '/uploads/delivered.jpg',
          'items': [],
        },
      }),
      data: {
        'status': 'DELIVERED',
        'proof_url': '/uploads/delivered.jpg',
      },
    );

    final updated = await locator<PurchaseRequestRepository>().updateStatus(
      'pr-1',
      PurchaseRequestStatus.delivered,
      proofUrl: '/uploads/delivered.jpg',
    );

    expect(updated.status, PurchaseRequestStatus.delivered);
    expect(updated.deliveredProofUrl, '/uploads/delivered.jpg');
  });
}
