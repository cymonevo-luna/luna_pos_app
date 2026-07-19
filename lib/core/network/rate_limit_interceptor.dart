import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Retries transient `429 rate_limited` responses for safe HTTP methods.
///
/// Honors the `Retry-After` header (seconds) with exponential backoff:
/// `Retry-After * 2^attempt`, capped at 30 seconds. Mutating requests are not
/// retried unless [idempotentExtraKey] is set to `true` on the request.
class RateLimitInterceptor extends Interceptor {
  RateLimitInterceptor(this._dio);

  final Dio _dio;

  static const idempotentExtraKey = 'idempotent';
  static const _attemptKey = 'rate_limit_attempt';

  static const maxAttempts = 3;
  static const defaultRetryAfterSeconds = 2;
  static const maxBackoffSeconds = 30;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isRateLimited(err)) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    if (!_isRetriable(options)) {
      handler.next(err);
      return;
    }

    final attempt = (options.extra[_attemptKey] as int?) ?? 1;
    if (attempt >= maxAttempts) {
      handler.next(err);
      return;
    }

    final retryAfterSeconds = _parseRetryAfter(err.response?.headers);
    final delay = _backoffDuration(retryAfterSeconds, attempt);

    try {
      await _waitWithCancellation(delay, options);
    } on DioException catch (cancelError) {
      handler.next(cancelError);
      return;
    }

    try {
      final response = await _dio.fetch<dynamic>(
        options.copyWith(
          extra: {...options.extra, _attemptKey: attempt + 1},
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  static bool isRateLimitedResponse(DioException err) => _isRateLimited(err);

  static bool _isRateLimited(DioException err) {
    if (err.response?.statusCode != 429) return false;

    final data = err.response?.data;
    if (data is! Map) return false;

    final error = data['error'];
    if (error is! Map) return false;

    return error['code'] == 'rate_limited';
  }

  static bool _isRetriable(RequestOptions options) {
    final method = options.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD') return true;
    return options.extra[idempotentExtraKey] == true;
  }

  static int _parseRetryAfter(Headers? headers) {
    final value = headers?.value('retry-after');
    if (value == null) return defaultRetryAfterSeconds;

    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0) return defaultRetryAfterSeconds;
    return parsed;
  }

  static Duration _backoffDuration(int retryAfterSeconds, int attempt) {
    final seconds = math.min(
      retryAfterSeconds * math.pow(2, attempt - 1),
      maxBackoffSeconds,
    );
    return Duration(milliseconds: (seconds * 1000).round());
  }

  static Future<void> _waitWithCancellation(
    Duration delay,
    RequestOptions options,
  ) async {
    final cancelToken = options.cancelToken;
    if (cancelToken == null) {
      await Future<void>.delayed(delay);
      return;
    }

    if (cancelToken.isCancelled) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        message: 'Request cancelled during rate-limit backoff.',
      );
    }

    await Future.any<void>([
      Future<void>.delayed(delay),
      cancelToken.whenCancel.then(
        (_) => throw DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'Request cancelled during rate-limit backoff.',
        ),
      ),
    ]);
  }
}
