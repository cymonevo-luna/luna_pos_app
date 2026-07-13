import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/api_envelope.dart';
import '../storage/secure_storage_service.dart';

/// Keeps the POS session alive by refreshing tokens before they expire and on
/// cashier activity. A single in-flight [refresh] future prevents refresh
/// storms during rapid API calls or tapping.
class TokenRefreshService {
  TokenRefreshService({
    required SecureStorageService secureStorage,
    required this._dio,
    required this._onSessionExpired,
  }) : _secure = secureStorage;

  static const accessExpiryBuffer = Duration(minutes: 2);
  static const activityRefreshDebounce = Duration(minutes: 5);
  static const periodicCheckInterval = Duration(minutes: 1);
  static const authPathPrefix = '/api/v1/auth';

  final SecureStorageService _secure;
  final Dio _dio;
  final void Function() _onSessionExpired;

  Future<bool>? _inFlightRefresh;
  DateTime? _lastActivityRefreshAt;
  Timer? _periodicTimer;

  static bool isAuthEndpoint(String path) => path.startsWith(authPathPrefix);

  Future<bool> get isRefreshTokenValid async {
    final refresh = await _secure.readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    final expiresAt = await _secure.readRefreshExpiresAt();
    if (expiresAt != null && !expiresAt.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  Future<bool> get isAccessExpiringSoon async {
    final expiresAt = await _secure.readAccessExpiresAt();
    if (expiresAt == null) return false;
    return !expiresAt.isAfter(DateTime.now().add(accessExpiryBuffer));
  }

  Future<String?> readAccessToken() => _secure.readToken();

  /// Refreshes tokens when the refresh token is still valid. Concurrent callers
  /// share the same in-flight future.
  Future<bool> refresh() async {
    if (_inFlightRefresh != null) {
      return _inFlightRefresh!;
    }

    final future = _performRefresh();
    _inFlightRefresh = future;
    try {
      return await future;
    } finally {
      if (identical(_inFlightRefresh, future)) {
        _inFlightRefresh = null;
      }
    }
  }

  Future<bool> _performRefresh() async {
    if (!await isRefreshTokenValid) return false;

    final refresh = await _secure.readRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refresh},
      );
      final data = unwrapApiEnvelope(response.data);
      final tokens = (data['tokens'] as Map).cast<String, dynamic>();
      await _persistTokens(tokens);
      if (kDebugMode) {
        debugPrint('[TokenRefreshService] tokens refreshed');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[TokenRefreshService] refresh failed: $e');
      }
      return false;
    }
  }

  /// Slides the 7-day refresh window on meaningful cashier activity.
  Future<void> refreshOnActivity() async {
    if (!await isRefreshTokenValid) return;

    final now = DateTime.now();
    if (_lastActivityRefreshAt != null &&
        now.difference(_lastActivityRefreshAt!) < activityRefreshDebounce) {
      return;
    }
    _lastActivityRefreshAt = now;
    await refresh();
  }

  /// Slides the refresh window when the cashier returns to the app.
  Future<void> refreshOnResume() async {
    if (!await isRefreshTokenValid) return;
    await refresh();
  }

  void startPeriodicRefreshCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(periodicCheckInterval, (_) async {
      if (await isAccessExpiringSoon && await isRefreshTokenValid) {
        await refresh();
      }
    });
  }

  void stopPeriodicRefreshCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  void dispose() => stopPeriodicRefreshCheck();

  Future<void> handleUnauthorized() async {
    if (!await isRefreshTokenValid) {
      _onSessionExpired();
    }
  }

  Future<void> _persistTokens(Map<String, dynamic> tokens) async {
    final access = tokens['access_token'] as String;
    final refresh = tokens['refresh_token'] as String?;
    final expiresIn = tokens['expires_in'];
    final refreshExpiresIn = tokens['refresh_expires_in'];
    final now = DateTime.now();

    await _secure.writeToken(access);
    if (refresh != null) await _secure.writeRefreshToken(refresh);
    if (expiresIn is num) {
      await _secure.writeAccessExpiresAt(
        now.add(Duration(seconds: expiresIn.round())),
      );
    }
    if (refreshExpiresIn is num) {
      await _secure.writeRefreshExpiresAt(
        now.add(Duration(seconds: refreshExpiresIn.round())),
      );
    }
  }
}
