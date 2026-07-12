import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session_guard.dart';
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

/// Returned when login succeeds but the account lacks POS cashier access.
const kCashierAccessDeniedMessage =
    'This account does not have POS cashier access';

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

class _CashierAccessDenied implements Exception {
  const _CashierAccessDenied();
}

/// Owns the auth session against the go_template backend
/// (`/api/v1/auth/*` + `/api/v1/users/{id}`). Restores any saved session on
/// startup and exposes login / register / logout actions.
///
/// Only users with the `cashier` role may establish a POS session.
class AuthController extends Notifier<AuthState> {
  SecureStorageService get _secure => locator<SecureStorageService>();
  ApiClient get _api => locator<ApiClient>();
  SessionGuard get _sessionGuard => locator<SessionGuard>();

  @override
  AuthState build() {
    _sessionGuard.onExpired = _handleSessionExpired;
    _restore();
    return const AuthState();
  }

  /// Restores a previously saved session: re-fetches the profile with the saved
  /// access token, transparently refreshing it once on a 401 before giving up.
  /// Any unexpected failure resolves to an unauthenticated state so the splash
  /// gate never blocks.
  Future<void> _restore() async {
    try {
      final token = await _secure.readToken();
      final userId = await _secure.readUserId();
      if (token == null || userId == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      _api.setAuthToken(token);
      final storedMerchant = await _secure.readMerchant();

      try {
        final user = await _fetchUser(userId);
        if (!user.hasCashierAccess) {
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
        return;
      } on ApiException catch (e) {
        if (e.type == ApiErrorType.unauthorized && await _tryRefresh()) {
          final user = await _fetchUser(userId);
          if (!user.hasCashierAccess) {
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
          return;
        }
      }

      await _clearSession();
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (_) {
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
    } on _CashierAccessDenied {
      state = state.copyWith(
        busy: false,
        error: kCashierAccessDeniedMessage,
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
    } on _CashierAccessDenied {
      state = state.copyWith(
        busy: false,
        error: kCashierAccessDeniedMessage,
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

    if (!user.hasCashierAccess) {
      throw const _CashierAccessDenied();
    }

    await _persistSession(
      access: tokens['access_token'] as String,
      refresh: tokens['refresh_token'] as String?,
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

  Future<bool> _tryRefresh() async {
    final refresh = await _secure.readRefreshToken();
    if (refresh == null) return false;
    try {
      final data = await _api.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        body: {'refresh_token': refresh},
        decoder: unwrapApiEnvelope,
      );
      final tokens = (data['tokens'] as Map).cast<String, dynamic>();
      await _secure.writeToken(tokens['access_token'] as String);
      final newRefresh = tokens['refresh_token'] as String?;
      if (newRefresh != null) await _secure.writeRefreshToken(newRefresh);
      _api.setAuthToken(tokens['access_token'] as String);
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<void> _persistSession({
    required String access,
    String? refresh,
    required User user,
    required Merchant merchant,
  }) async {
    await _secure.writeToken(access);
    if (refresh != null) await _secure.writeRefreshToken(refresh);
    await _secure.writeUserId(user.id);
    await _secure.writeUser(user);
    await _secure.writeMerchant(merchant);
    _api.setAuthToken(access);
  }

  Future<void> _clearSession() async {
    _api.setAuthToken(null);
    await _secure.deleteToken();
    await _secure.deleteRefreshToken();
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
