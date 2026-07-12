import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/purchase_request.dart';

import '../helpers/auth_harness.dart';

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

  test('end-to-end status flow returns both proof URLs on GET detail', () async {
    const id = 'pr-e2e';

    adapter.onPatch(
      '/api/admin/purchase-requests/$id/status',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': id,
          'supplier_id': 'sup-1',
          'supplier_name': 'Supplier A',
          'status': 'PAID',
          'paid_proof_url': '/uploads/paid-proof.jpg',
          'items': [],
        },
      }),
      data: {
        'status': 'PAID',
        'proof_url': '/uploads/paid-proof.jpg',
      },
    );

    final paid = await locator<PurchaseRequestRepository>().updateStatus(
      id,
      PurchaseRequestStatus.paid,
      proofUrl: '/uploads/paid-proof.jpg',
    );
    expect(paid.status, PurchaseRequestStatus.paid);
    expect(paid.paidProofUrl, '/uploads/paid-proof.jpg');

    adapter.onPatch(
      '/api/admin/purchase-requests/$id/status',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': id,
          'supplier_id': 'sup-1',
          'supplier_name': 'Supplier A',
          'status': 'DELIVERED',
          'paid_proof_url': '/uploads/paid-proof.jpg',
          'delivered_proof_url': '/uploads/delivered-proof.jpg',
          'items': [],
        },
      }),
      data: {
        'status': 'DELIVERED',
        'proof_url': '/uploads/delivered-proof.jpg',
      },
    );

    final delivered = await locator<PurchaseRequestRepository>().updateStatus(
      id,
      PurchaseRequestStatus.delivered,
      proofUrl: '/uploads/delivered-proof.jpg',
    );
    expect(delivered.status, PurchaseRequestStatus.delivered);
    expect(delivered.deliveredProofUrl, '/uploads/delivered-proof.jpg');

    adapter.onGet(
      '/api/admin/purchase-requests/$id',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': id,
          'supplier_id': 'sup-1',
          'supplier_name': 'Supplier A',
          'status': 'DELIVERED',
          'paid_proof_url': '/uploads/paid-proof.jpg',
          'delivered_proof_url': '/uploads/delivered-proof.jpg',
          'items': [],
        },
      }),
    );

    final detail = await locator<PurchaseRequestRepository>().get(id);
    expect(detail.paidProofUrl, '/uploads/paid-proof.jpg');
    expect(detail.deliveredProofUrl, '/uploads/delivered-proof.jpg');
  });
}
