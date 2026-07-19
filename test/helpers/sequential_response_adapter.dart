import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/auth/token_refresh_service.dart';
import 'package:luna_pos/core/network/api_client.dart';

import 'auth_harness.dart';

/// Returns a fixed sequence of HTTP responses for each outbound request.
class SequentialResponseAdapter implements HttpClientAdapter {
  SequentialResponseAdapter({required this.responses});

  final List<SequentialResponse> responses;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final index =
        callCount < responses.length ? callCount : responses.length - 1;
    final response = responses[index];
    callCount++;

    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.statusCode,
      headers: response.headers,
    );
  }

  @override
  void close({bool force = false}) {}
}

class SequentialResponse {
  const SequentialResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  });

  final int statusCode;
  final Map<String, dynamic> body;
  final Map<String, List<String>> headers;
}

({ApiClient client, SequentialResponseAdapter adapter, FakeSecureStorage secure})
    buildSequentialApiClient({
  required List<SequentialResponse> responses,
  bool withAuthInterceptor = false,
  FakeSecureStorage? secure,
}) {
  final storage = secure ?? FakeSecureStorage();
  final guard = SessionGuard();
  final client = ApiClient(
    baseUrl: 'https://api.test',
    onSessionExpired: () => guard.notifyExpired(),
  );
  final sequential = SequentialResponseAdapter(responses: responses);
  client.raw.httpClientAdapter = sequential;

  if (withAuthInterceptor) {
    final tokenRefresh = TokenRefreshService(
      secureStorage: storage,
      dio: client.raw,
      onSessionExpired: () => guard.notifyExpired(),
    );
    client.attachAuthInterceptor(tokenRefresh);
  }

  return (client: client, adapter: sequential, secure: storage);
}
