import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:luna_pos/features/purchase/data/purchase_proof_upload.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/purchase_request.dart';
import 'package:luna_pos/features/purchase/purchase_detail_controller.dart';

import 'helpers/auth_harness.dart';
import 'helpers/purchase_test_fakes.dart';

void main() {
  late DioAdapter adapter;
  late FakePurchaseProofUpload proofUpload;

  Map<String, dynamic> detailPayload({
    PurchaseRequestStatus status = PurchaseRequestStatus.requested,
  }) =>
      {
        'id': 'pr-detail',
        'supplier_id': 'sup-1',
        'supplier_name': 'Supplier A',
        'status': switch (status) {
          PurchaseRequestStatus.pending => 'PENDING',
          PurchaseRequestStatus.requested => 'REQUESTED',
          PurchaseRequestStatus.paid => 'PAID',
          PurchaseRequestStatus.delivered => 'DELIVERED',
        },
        'items': [],
      };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    proofUpload = FakePurchaseProofUpload();
    final secure = FakeSecureStorage();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<PurchaseProofUpload>(() => proofUpload)
      ..registerLazySingleton<PurchaseImagePicker>(
        () => FakePurchaseImagePicker(),
      );

    adapter.onGet(
      '/api/admin/purchase-requests/pr-detail',
      (server) => server.reply(200, {
        'success': true,
        'data': detailPayload(),
      }),
    );
  });

  Future<XFile> testImage() async {
    final file = File(
      '${Directory.systemTemp.path}/proof-${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]));
    return XFile(file.path, name: 'proof.jpg');
  }

  test('upload then PATCH sequence updates status to PAID', () async {
    final callOrder = <String>[];
    proofUpload.uploadedUrl = '/uploads/proof.jpg';

    adapter.onPatch(
      '/api/admin/purchase-requests/pr-detail/status',
      (server) {
        callOrder.add('patch');
        return server.reply(200, {
          'success': true,
          'data': detailPayload(status: PurchaseRequestStatus.paid),
        });
      },
      data: {'status': 'PAID', 'proof_url': '/uploads/proof.jpg'},
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(purchaseDetailProvider('pr-detail').notifier).retry();
    await Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return container.read(purchaseDetailProvider('pr-detail')).loading;
    });

    final notifier = container.read(purchaseDetailProvider('pr-detail').notifier);
    final image = await testImage();
    final success = await notifier.updateStatusWithFile(
      PurchaseRequestStatus.paid,
      image,
    );

    expect(success, isTrue);
    expect(proofUpload.lastUploadedPath, image.path);
    expect(callOrder, ['patch']);
    expect(
      container.read(purchaseDetailProvider('pr-detail')).detail?.status,
      PurchaseRequestStatus.paid,
    );
  });

  test('updatePaidDate patches record-date then reloads detail', () async {
    const updatedPaidAt = '2026-07-05T03:30:00.000Z';
    var patched = false;

    adapter.reset();

    adapter.onPatch(
      '/api/admin/purchase-requests/pr-detail/record-date',
      (server) {
        patched = true;
        return server.reply(200, {'success': true});
      },
      data: {'paid_at': updatedPaidAt},
    );

    adapter.onGet(
      '/api/admin/purchase-requests/pr-detail',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          ...detailPayload(status: PurchaseRequestStatus.paid),
          'status_history': patched
              ? [
                  {
                    'status': 'REQUESTED',
                    'created_at': '2026-07-10T08:00:00Z',
                  },
                  {
                    'status': 'PAID',
                    'created_at': updatedPaidAt,
                  },
                ]
              : [
                  {
                    'status': 'PAID',
                    'created_at': '2026-07-12T10:00:00Z',
                  },
                ],
        },
      }),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(purchaseDetailProvider('pr-detail').notifier).retry();
    await Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return container.read(purchaseDetailProvider('pr-detail')).loading;
    });

    final notifier = container.read(purchaseDetailProvider('pr-detail').notifier);
    final success = await notifier.updatePaidDate(
      DateTime.parse(updatedPaidAt),
    );

    expect(success, isTrue);
    expect(patched, isTrue);
    expect(
      container.read(purchaseDetailProvider('pr-detail')).detail?.paidDateFromHistory,
      DateTime.parse(updatedPaidAt),
    );
  });

  test('PATCH failure keeps previous status and surfaces error', () async {
    adapter.onPatch(
      '/api/admin/purchase-requests/pr-detail/status',
      (server) => server.reply(422, {
        'success': false,
        'message': 'proof_url is required for PAID status',
      }),
      data: {'status': 'PAID', 'proof_url': '/uploads/proof.jpg'},
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(purchaseDetailProvider('pr-detail').notifier).retry();
    await Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return container.read(purchaseDetailProvider('pr-detail')).loading;
    });

    final notifier = container.read(purchaseDetailProvider('pr-detail').notifier);
    final success = await notifier.updateStatusWithFile(
      PurchaseRequestStatus.paid,
      await testImage(),
    );

    expect(success, isFalse);
    final state = container.read(purchaseDetailProvider('pr-detail'));
    expect(state.detail?.status, PurchaseRequestStatus.requested);
    expect(state.error, 'Invalid request.');
  });
}
