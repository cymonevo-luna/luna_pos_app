import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// In-memory [SecureStorageService] for tests: overrides the primitive
/// read/write/delete so no platform channel (Keychain / EncryptedSharedPrefs)
/// is touched. The convenience token helpers reuse these overrides.
class FakeSecureStorage extends SecureStorageService {
  final Map<String, String> store = <String, String>{};

  @override
  Future<String?> read(String key) async => store[key];

  @override
  Future<void> write(String key, String value) async => store[key] = value;

  @override
  Future<void> delete(String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}

/// Builds an [ApiClient] whose underlying Dio is backed by a mock adapter so
/// requests can be stubbed without a live backend.
({ApiClient client, DioAdapter adapter}) buildMockedApiClient() {
  final client = ApiClient(baseUrl: 'https://api.test');
  final adapter = DioAdapter(dio: client.raw);
  return (client: client, adapter: adapter);
}

Map<String, dynamic> _loginUserPayload(
  TestAccountRole role, {
  required String userId,
  required String email,
  List<String> additionalRoles = const [],
}) =>
    {
      'id': userId,
      'email': email,
      'name': _displayNameFor(role),
      'merchant_id': TestAccounts.testMerchantId,
      'roles': TestAccounts.apiRolesFor(
        role,
        additionalRoles: additionalRoles,
      ),
    };

Map<String, dynamic> _merchantPayload() => {
      'id': TestAccounts.testMerchantId,
      'name': TestAccounts.testMerchantName,
    };

/// Stubs `POST /api/v1/auth/login` for a dedicated [role] test account.
void stubDedicatedAccountLogin(
  DioAdapter adapter,
  TestAccountRole role, {
  String? userId,
  String accessToken = 'acc',
  String refreshToken = 'ref',
  int expiresIn = 900,
  int refreshExpiresIn = 604800,
  List<String> additionalRoles = const [],
}) {
  final email = TestAccounts.emailFor(role);
  final resolvedUserId = userId ?? TestAccounts.userIdFor(role);
  adapter.onPost(
    '/api/v1/auth/login',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'tokens': {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'expires_in': expiresIn,
          'refresh_expires_in': refreshExpiresIn,
        },
        'user': _loginUserPayload(
          role,
          userId: resolvedUserId,
          email: email,
          additionalRoles: additionalRoles,
        ),
        'merchant': _merchantPayload(),
      },
    }),
    data: {'email': email, 'password': TestAccounts.password},
  );
}

/// Stubs `POST /api/v1/auth/refresh` with rotated tokens.
void stubTokenRefresh(
  DioAdapter adapter, {
  String refreshToken = 'ref',
  String accessToken = 'acc-new',
  String newRefreshToken = 'ref-new',
  int expiresIn = 900,
  int refreshExpiresIn = 604800,
}) {
  adapter.onPost(
    '/api/v1/auth/refresh',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'tokens': {
          'access_token': accessToken,
          'refresh_token': newRefreshToken,
          'expires_in': expiresIn,
          'refresh_expires_in': refreshExpiresIn,
        },
      },
    }),
    data: {'refresh_token': refreshToken},
  );
}

/// Minimum secure-storage fields for cold-start session restore in tests.
void seedRestorableSecureTokens(
  FakeSecureStorage secure, {
  String userId = 'u1',
  String accessToken = 'acc',
  String refreshToken = 'ref',
  DateTime? refreshExpiresAt,
}) {
  final expiresAt =
      refreshExpiresAt ?? DateTime.now().add(const Duration(days: 7));

  secure.store[SecureKeys.authToken] = accessToken;
  secure.store[SecureKeys.refreshToken] = refreshToken;
  secure.store[SecureKeys.userId] = userId;
  secure.store[SecureKeys.refreshExpiresAt] =
      '${expiresAt.millisecondsSinceEpoch}';
}

/// Stubs refresh + profile endpoints used during session restore.
void stubSessionRestoreApis(
  DioAdapter adapter, {
  required String userId,
  required Map<String, dynamic> userData,
  String refreshToken = 'ref',
}) {
  stubTokenRefresh(adapter, refreshToken: refreshToken);
  adapter.onGet(
    '/api/v1/users/$userId',
    (server) => server.reply(200, {
      'success': true,
      'data': userData,
    }),
  );
}

/// Seeds secure storage and stubs the profile + refresh endpoints for [role].
void seedAuthenticatedTestAccount(
  FakeSecureStorage secure,
  DioAdapter adapter,
  TestAccountRole role, {
  String? userId,
  String accessToken = 'acc',
  String refreshToken = 'ref',
  List<String> additionalRoles = const [],
  DateTime? refreshExpiresAt,
}) {
  final resolvedUserId = userId ?? TestAccounts.userIdFor(role);
  final expiresAt =
      refreshExpiresAt ?? DateTime.now().add(const Duration(days: 7));

  secure.store[SecureKeys.authToken] = accessToken;
  secure.store[SecureKeys.refreshToken] = refreshToken;
  secure.store[SecureKeys.userId] = resolvedUserId;
  secure.store[SecureKeys.refreshExpiresAt] =
      '${expiresAt.millisecondsSinceEpoch}';

  stubTokenRefresh(
    adapter,
    refreshToken: refreshToken,
  );

  adapter.onGet(
    '/api/v1/users/$resolvedUserId',
    (server) => server.reply(200, {
      'success': true,
      'data': _loginUserPayload(
        role,
        userId: resolvedUserId,
        email: TestAccounts.emailFor(role),
        additionalRoles: additionalRoles,
      ),
    }),
  );
}

String _displayNameFor(TestAccountRole role) => switch (role) {
      TestAccountRole.admin => 'Admin Test',
      TestAccountRole.manager => 'Manager Test',
      TestAccountRole.cashier => 'Cashier Test',
      TestAccountRole.operational => 'Operational Test',
    };
