import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/token_refresh_service.dart';
import 'api_exception.dart';
import 'auth_token_interceptor.dart';
import 'rate_limit_interceptor.dart';

/// Decodes a raw JSON body (`Map`/`List`) into a typed model.
typedef JsonDecoder<T> = T Function(dynamic data);

/// A thin, reusable HTTP client built on Dio.
///
/// Registered in the service locator; resolve via `locator<ApiClient>()`:
/// ```dart
/// final user = await locator<ApiClient>().get<User>(
///   '/api/v1/users/$id',
///   decoder: (json) => User.fromJson(json),
/// );
/// ```
///
/// All failures are normalized to [ApiException], so callers never touch Dio
/// types directly.
class ApiClient {
  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
    this.onSessionExpired,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            contentType: Headers.jsonContentType,
            headers: headers,
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!_authInterceptorAttached &&
              _authToken != null &&
              !TokenRefreshService.isAuthEndpoint(options.path) &&
              !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
      ),
    );
    _dio.interceptors.add(RateLimitInterceptor(_dio));
  }

  final Dio _dio;
  String? _authToken;
  bool _authInterceptorAttached = false;

  /// Called when the server returns 401/403 (e.g. to trigger logout).
  final VoidCallback? onSessionExpired;

  /// Escape hatch for advanced Dio usage (uploads, custom options, etc.).
  Dio get raw => _dio;

  /// Attach the auth interceptor once. Called from [setupLocator] after
  /// [TokenRefreshService] is registered.
  void attachAuthInterceptor(TokenRefreshService tokenRefresh) {
    if (_authInterceptorAttached) return;
    _authInterceptorAttached = true;

    _dio.interceptors.add(
      AuthTokenInterceptor(
        tokenRefresh: tokenRefresh,
        dio: _dio,
        onSessionExpired: () => onSessionExpired?.call(),
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ));
    }
  }

  /// Attach (or clear with `null`) the bearer token for clients without the
  /// full auth interceptor (e.g. lightweight live API tests).
  void setAuthToken(String? token) => _authToken = token;

  // --- Verbs ---------------------------------------------------------------
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    JsonDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.get(path, queryParameters: query, cancelToken: cancelToken),
        decoder,
      );

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    JsonDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.post(path,
            data: body, queryParameters: query, cancelToken: cancelToken),
        decoder,
      );

  Future<T> put<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    JsonDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.put(path,
            data: body, queryParameters: query, cancelToken: cancelToken),
        decoder,
      );

  Future<T> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    JsonDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.patch(path,
            data: body, queryParameters: query, cancelToken: cancelToken),
        decoder,
      );

  Future<T> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    JsonDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.delete(path,
            data: body, queryParameters: query, cancelToken: cancelToken),
        decoder,
      );

  Future<T> _request<T>(
    Future<Response<dynamic>> Function() send,
    JsonDecoder<T>? decoder,
  ) async {
    try {
      final response = await send();
      final data = response.data;
      if (decoder != null) return decoder(data);
      return data as T;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
