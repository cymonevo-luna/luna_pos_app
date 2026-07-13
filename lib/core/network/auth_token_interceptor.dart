import 'package:dio/dio.dart';

import '../auth/token_refresh_service.dart';

/// Injects bearer tokens, proactively refreshes near-expiry access tokens, and
/// retries protected requests once after a 401 when the refresh token is valid.
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({
    required this.tokenRefresh,
    required this._dio,
    required this.onSessionExpired,
  });

  final TokenRefreshService tokenRefresh;
  final Dio _dio;
  final void Function() onSessionExpired;

  static const _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (TokenRefreshService.isAuthEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    if (await tokenRefresh.isAccessExpiringSoon) {
      await tokenRefresh.refresh();
    }

    final token = await tokenRefresh.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode == 403) {
      onSessionExpired();
      handler.next(err);
      return;
    }

    if (statusCode != 401) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    if (TokenRefreshService.isAuthEndpoint(options.path)) {
      handler.next(err);
      return;
    }

    if (options.extra[_retriedKey] == true) {
      await tokenRefresh.handleUnauthorized();
      handler.next(err);
      return;
    }

    final refreshed = await tokenRefresh.refresh();
    if (!refreshed) {
      await tokenRefresh.handleUnauthorized();
      handler.next(err);
      return;
    }

    final token = await tokenRefresh.readAccessToken();
    if (token == null) {
      await tokenRefresh.handleUnauthorized();
      handler.next(err);
      return;
    }

    try {
      final response = await _dio.fetch<dynamic>(
        options.copyWith(
          extra: {...options.extra, _retriedKey: true},
          headers: {
            ...options.headers,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        await tokenRefresh.handleUnauthorized();
      }
      handler.next(retryError);
    }
  }
}
