import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/api_exception.dart';
import 'package:luna_pos/core/network/rate_limit_interceptor.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';

import 'helpers/auth_harness.dart';
import 'helpers/sequential_response_adapter.dart';

const _rateLimitedBody = {
  'success': false,
  'error': {'code': 'rate_limited', 'message': 'too many requests'},
};

const _rateLimitedHeaders = {
  'retry-after': ['0'],
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;
  late ApiClient client;

  setUp(() async {
    await locator.reset();
    secure = FakeSecureStorage();

    final mocked = buildMockedApiClient(
      secure: secure,
      withAuthInterceptor: true,
    );
    client = mocked.client;
    adapter = mocked.adapter;

    locator
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(client)
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), testResourceCache()),
      );
  });

  void seedValidSession() {
    secure.store[SecureKeys.authToken] = 'access-token';
    secure.store[SecureKeys.refreshToken] = 'ref';
    secure.store[SecureKeys.refreshExpiresAt] =
        '${DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch}';
  }

  test('GET 429 retries and succeeds', () async {
    final sequential = buildSequentialApiClient(
      withAuthInterceptor: true,
      secure: secure,
      responses: [
        const SequentialResponse(
          statusCode: 429,
          body: _rateLimitedBody,
          headers: _rateLimitedHeaders,
        ),
        const SequentialResponse(
          statusCode: 200,
          body: {
            'success': true,
            'data': {'categories': []},
          },
        ),
      ],
    );
    seedValidSession();
    sequential.secure.store.addAll(secure.store);

    locator.unregister<ApiClient>();
    locator.registerSingleton<ApiClient>(sequential.client);

    final menus = await locator<MenuRepository>().fetchPOSMenus();

    expect(menus.categories, isEmpty);
    expect(sequential.adapter.callCount, 2);
  });

  test('POST 429 is not retried', () async {
    adapter.onPost(
      '/api/v1/pos/orders',
      (server) => server.reply(
        429,
        _rateLimitedBody,
        headers: _rateLimitedHeaders,
      ),
      data: {'items': []},
    );

    await expectLater(
      client.post<Map<String, dynamic>>(
        '/api/v1/pos/orders',
        body: {'items': []},
      ),
      throwsA(
        isA<ApiException>().having(
          (e) => e.statusCode,
          'statusCode',
          429,
        ),
      ),
    );

    expect(adapter.history.where((h) => h.request.route == '/api/v1/pos/orders').length, 1);
  });

  test('three consecutive 429s exhaust retries', () async {
    final sequential = buildSequentialApiClient(
      withAuthInterceptor: true,
      secure: secure,
      responses: const [
        SequentialResponse(
          statusCode: 429,
          body: _rateLimitedBody,
          headers: _rateLimitedHeaders,
        ),
        SequentialResponse(
          statusCode: 429,
          body: _rateLimitedBody,
          headers: _rateLimitedHeaders,
        ),
        SequentialResponse(
          statusCode: 429,
          body: _rateLimitedBody,
          headers: _rateLimitedHeaders,
        ),
      ],
    );
    seedValidSession();
    sequential.secure.store.addAll(secure.store);

    locator.unregister<ApiClient>();
    locator.registerSingleton<ApiClient>(sequential.client);

    await expectLater(
      locator<MenuRepository>().fetchPOSMenus(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.statusCode,
          'statusCode',
          429,
        ),
      ),
    );

    expect(sequential.adapter.callCount, 3);
  });

  test('401 token refresh takes priority over 429 retry logic', () async {
    seedValidSession();
    stubTokenRefresh(adapter, refreshToken: 'ref');

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(401, {
        'success': false,
        'error': {'code': 'unauthorized', 'message': 'expired'},
      }),
      headers: {'Authorization': 'Bearer access-token'},
    );
    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, {
        'success': true,
        'data': {'categories': []},
      }),
      headers: {'Authorization': 'Bearer acc-new'},
    );

    final menus = await locator<MenuRepository>().fetchPOSMenus();

    expect(menus.categories, isEmpty);
    expect(secure.store[SecureKeys.authToken], 'acc-new');
  });

  test('idempotent POST 429 is retried when flagged', () async {
    final sequential = buildSequentialApiClient(
      responses: [
        const SequentialResponse(
          statusCode: 429,
          body: _rateLimitedBody,
          headers: _rateLimitedHeaders,
        ),
        const SequentialResponse(
          statusCode: 200,
          body: {
            'success': true,
            'data': {'id': 'order-1'},
          },
        ),
      ],
    );

    final response = await sequential.client.raw.post<Map<String, dynamic>>(
      '/api/v1/pos/orders/retry',
      data: {'idempotency_key': 'abc'},
      options: Options(
        extra: {RateLimitInterceptor.idempotentExtraKey: true},
      ),
    );

    expect(response.data?['data']?['id'], 'order-1');
    expect(sequential.adapter.callCount, 2);
  });

  test('request cancellation is respected during backoff', () async {
    seedValidSession();
    final cancelToken = CancelToken();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(
        429,
        _rateLimitedBody,
        headers: {
          'retry-after': ['5'],
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );

    final request = client.get<Map<String, dynamic>>(
      '/api/v1/pos/menus',
      cancelToken: cancelToken,
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    cancelToken.cancel('user cancelled');

    await expectLater(
      request,
      throwsA(
        isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiErrorType.cancelled,
        ),
      ),
    );
  });
}
