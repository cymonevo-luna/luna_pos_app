import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/api_envelope.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/testing/test_accounts.dart';

/// Authenticated session returned by [loginAsTestRole].
class AuthSession {
  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String? refreshToken;
  final User user;
}

/// Logs in with a dedicated seeded test account via `POST /api/v1/auth/login`,
/// persists tokens the same way production login does, and returns the session.
///
/// Use for integration tests and Tester Agent setup against a migrated API.
/// Never calls the registration endpoint.
Future<AuthSession> loginAsTestRole(
  ApiClient api,
  SecureStorageService secure,
  TestAccountRole role,
) async {
  final data = await api.post<Map<String, dynamic>>(
    '/api/v1/auth/login',
    body: {
      'email': TestAccounts.emailFor(role),
      'password': TestAccounts.password,
    },
    decoder: unwrapApiEnvelope,
  );

  final tokens = (data['tokens'] as Map).cast<String, dynamic>();
  final user = User.fromJson((data['user'] as Map).cast<String, dynamic>());
  final accessToken = tokens['access_token'] as String;
  final refreshToken = tokens['refresh_token'] as String?;
  final expiresIn = tokens['expires_in'];
  final refreshExpiresIn = tokens['refresh_expires_in'];
  final now = DateTime.now();

  await secure.writeToken(accessToken);
  if (refreshToken != null) {
    await secure.writeRefreshToken(refreshToken);
  }
  if (expiresIn is num) {
    await secure.writeAccessExpiresAt(
      now.add(Duration(seconds: expiresIn.round())),
    );
  }
  if (refreshExpiresIn is num) {
    await secure.writeRefreshExpiresAt(
      now.add(Duration(seconds: refreshExpiresIn.round())),
    );
  }
  await secure.writeUserId(user.id);
  api.setAuthToken(accessToken);

  return AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user,
  );
}
