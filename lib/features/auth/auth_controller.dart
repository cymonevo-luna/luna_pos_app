import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session_guard.dart';
import '../../core/auth/token_refresh_service.dart';
import '../../core/di/locator.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_envelope.dart';
import '../../core/network/api_exception.dart';
import '../../core/storage/secure_storage_service.dart';
import '../merchant/models/merchant.dart';
import '../user/models/user.dart';

/// Authentication status the rest of the app can react to (e.g. the router's
/// splash gate and logout actions).
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Shown when a saved session is cleared after a 401/403 from any API call.
const kSessionExpiredMessage =
    'Your session has expired. Please sign in again.';

/// Returned when login succeeds but the account lacks POS or operational access.
const kPosAccessDeniedMessage =
    'This account does not have POS or operational access';

/// Backward-compatible alias for access-denied messaging in tests and UI.
const kCashierAccessDeniedMessage = kPosAccessDeniedMessage;

/// Snapshot of the current auth session.
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.merchant,
    this.busy = false,
    this.error,
  });

  final AuthStatus status;
  final User? user;
  final Merchant? merchant;

  /// True while a login/register request is in flight.
  final bool busy;
  final String? error;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Merchant? merchant,
    bool? busy,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      merchant: merchant ?? this.merchant,
      busy: busy ?? this.busy,
      error: error,
    );
  }
}

class _PosAccessDenied implements Exception {
  const _PosAccessDenied();
}

/// Owns the auth session against the go_template backend
/// (`/api/v1/auth/*` + `/api/v1/users/{id}`). Restores any saved session on
/// startup and exposes login / register / logout actions.
///
/// Only users with the `cashier` or `operational` role may establish a session.
class AuthController extends Notifier<AuthState> {
  SecureStorageService get _secure => locator<SecureStorageService>();
  ApiClient get _api => locator<ApiClient>();
  SessionGuard get _sessionGuard => locator<SessionGuard>();
  TokenRefreshService get _tokenRefresh => locator<TokenRefreshService>();

  @override
  AuthState build() {
    _sessionGuard.onExpired = _handleSessionExpired;
    _restore();
    return const AuthState();
  }

  /// Restores a previously saved session by refreshing tokens when the refresh
  /// token is still valid, then re-fetching the user profile. Any failure
  /// resolves to an unauthenticated state so the splash gate never blocks.
  Future<void> _restore() async {
    try {
      final refresh = await _secure.readRefreshToken();
      final userId = await _secure.readUserId();
      if (refresh == null || userId == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      final refreshExpiresAt = await _secure.readRefreshExpiresAt();
      if (refreshExpiresAt != null &&
          refreshExpiresAt.isBefore(DateTime.now())) {
        await _clearSession();
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      if (!await _tokenRefresh.refresh()) {
        await _clearSession();
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      final storedMerchant = await _secure.readMerchant();
      final user = await _fetchUser(userId);
      if (!user.canAccessPosApp) {
        await _clearSession();
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      await _secure.writeUser(user);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        merchant: storedMerchant,
      );
    } catch (_) {
      await _clearSession();
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(busy: true, error: null);
    try {
      final result = await _loginRequest(email: email, password: password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        merchant: result.merchant,
        busy: false,
      );
      return true;
    } on _PosAccessDenied {
      state = state.copyWith(
        busy: false,
        error: kPosAccessDeniedMessage,
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(busy: false, error: _messageFor(e));
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(busy: true, error: null);
    try {
      // The backend register endpoint returns the created user but no tokens,
      // so we immediately log in to establish a session.
      await _api.post<void>(
        '/api/v1/auth/register',
        body: {'name': name, 'email': email, 'password': password},
        decoder: (_) {},
      );
      final result = await _loginRequest(email: email, password: password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        merchant: result.merchant,
        busy: false,
      );
      return true;
    } on _PosAccessDenied {
      state = state.copyWith(
        busy: false,
        error: kPosAccessDeniedMessage,
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(busy: false, error: _messageFor(e));
      return false;
    }
  }

  Future<void> logout() async {
    await _clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _handleSessionExpired() async {
    await _clearSession();
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      error: kSessionExpiredMessage,
    );
  }

  Future<({User user, Merchant merchant})> _loginRequest({
    required String email,
    required String password,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      body: {'email': email, 'password': password},
      decoder: unwrapApiEnvelope,
    );
    final tokens = (data['tokens'] as Map).cast<String, dynamic>();
    final user = User.fromJson((data['user'] as Map).cast<String, dynamic>());
    final merchant =
        Merchant.fromJson((data['merchant'] as Map).cast<String, dynamic>());

    if (!user.canAccessPosApp) {
      throw const _PosAccessDenied();
    }

    await _persistSession(
      tokens: tokens,
      user: user,
      merchant: merchant,
    );
    return (user: user, merchant: merchant);
  }

  Future<User> _fetchUser(String id) {
    return _api.get<User>(
      '/api/v1/users/$id',
      decoder: (raw) => User.fromJson(unwrapApiEnvelope(raw)),
    );
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
    _api.setAuthToken(access);
  }

  Future<void> _persistSession({
    required Map<String, dynamic> tokens,
    required User user,
    required Merchant merchant,
  }) async {
    await _persistTokens(tokens);
    await _secure.writeUserId(user.id);
    await _secure.writeUser(user);
    await _secure.writeMerchant(merchant);
  }

  Future<void> _clearSession() async {
    _api.setAuthToken(null);
    await _secure.deleteToken();
    await _secure.deleteRefreshToken();
    await _secure.deleteAccessExpiresAt();
    await _secure.deleteRefreshExpiresAt();
    await _secure.deleteUserId();
    await _secure.deleteUser();
    await _secure.deleteMerchant();
  }

  /// Prefers the server-provided error message from the envelope, falling back
  /// to the generic [ApiException] message.
  String _messageFor(ApiException e) {
    final data = e.data;
    if (data is Map && data['error'] is Map) {
      final msg = (data['error'] as Map)['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return e.message;
  }
}

final authProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
