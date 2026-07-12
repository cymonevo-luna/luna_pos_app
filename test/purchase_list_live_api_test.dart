import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/api_exception.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/models/purchase_request.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:luna_pos/testing/test_auth.dart';

/// Live API verification for operational purchase list access.
///
/// Skipped in CI by default; run with:
/// `flutter test test/purchase_list_live_api_test.dart --dart-define=INTEGRATION_USE_LIVE_API=true --dart-define=API_BASE_URL=https://pos-api.cymonevo.com`
void main() {
  const useLiveApi = bool.fromEnvironment(
    'INTEGRATION_USE_LIVE_API',
    defaultValue: false,
  );

  test(
    'operational account can list purchase requests without 403',
    () async {
      await AppConfig.load();
      await locator.reset();

      final apiBaseUrl = const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://pos-api.cymonevo.com',
      );

      final secure = _InMemorySecureStorage();
      final api = ApiClient(baseUrl: apiBaseUrl);
      locator
        ..registerSingleton<SecureStorageService>(secure)
        ..registerSingleton<ApiClient>(api)
        ..registerLazySingleton<PurchaseRequestRepository>(
          () => PurchaseRequestRepository(locator<ApiClient>()),
        );

      await loginAsTestRole(api, secure, TestAccountRole.operational);

      try {
        final response = await locator<PurchaseRequestRepository>().list();
        expect(response.page, greaterThanOrEqualTo(1));
        expect(response.perPage, greaterThanOrEqualTo(1));
        expect(response.total, greaterThanOrEqualTo(0));
      } on ApiException catch (e) {
        expect(e.type, isNot(ApiErrorType.forbidden));
        rethrow;
      }
    },
    skip: !useLiveApi ? 'Set INTEGRATION_USE_LIVE_API=true to run live API test' : false,
  );

  for (final status in PurchaseRequestStatus.values) {
    test(
      'operational account can filter purchase requests by ${status.name}',
      () async {
        await AppConfig.load();
        await locator.reset();

        final apiBaseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://pos-api.cymonevo.com',
        );

        final secure = _InMemorySecureStorage();
        final api = ApiClient(baseUrl: apiBaseUrl);
        locator
          ..registerSingleton<SecureStorageService>(secure)
          ..registerSingleton<ApiClient>(api)
          ..registerLazySingleton<PurchaseRequestRepository>(
            () => PurchaseRequestRepository(locator<ApiClient>()),
          );

        await loginAsTestRole(api, secure, TestAccountRole.operational);

        try {
          final response =
              await locator<PurchaseRequestRepository>().list(status: status);
          expect(response.page, greaterThanOrEqualTo(1));
          expect(response.perPage, greaterThanOrEqualTo(1));
          expect(response.total, greaterThanOrEqualTo(0));
        } on ApiException catch (e) {
          expect(e.type, isNot(ApiErrorType.forbidden));
          rethrow;
        }
      },
      skip: !useLiveApi
          ? 'Set INTEGRATION_USE_LIVE_API=true to run live API test'
          : false,
    );
  }
}

class _InMemorySecureStorage extends SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async => _store[key] = value;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();
}
