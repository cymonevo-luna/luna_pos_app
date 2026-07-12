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

/// Stubs `POST /api/v1/auth/login` for a dedicated [role] test account.
void stubDedicatedAccountLogin(
  DioAdapter adapter,
  TestAccountRole role, {
  String userId = 'test-user',
  String accessToken = 'acc',
  String refreshToken = 'ref',
}) {
  final email = TestAccounts.emailFor(role);
  adapter.onPost(
    '/api/v1/auth/login',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'tokens': {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'expires_in': 900,
        },
        'user': {
          'id': userId,
          'email': email,
          'name': _displayNameFor(role),
          'role': TestAccounts.apiRoleFor(role),
        },
      },
    }),
    data: {'email': email, 'password': TestAccounts.password},
  );
}

/// Seeds secure storage and stubs the profile endpoint for [role].
void seedAuthenticatedTestAccount(
  FakeSecureStorage secure,
  DioAdapter adapter,
  TestAccountRole role, {
  String userId = 'test-user',
  String accessToken = 'acc',
}) {
  secure.store[SecureKeys.authToken] = accessToken;
  secure.store[SecureKeys.userId] = userId;

  adapter.onGet(
    '/api/v1/users/$userId',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'id': userId,
        'email': TestAccounts.emailFor(role),
        'name': _displayNameFor(role),
        'role': TestAccounts.apiRoleFor(role),
      },
    }),
  );
}

String _displayNameFor(TestAccountRole role) => switch (role) {
      TestAccountRole.admin => 'Admin Test',
      TestAccountRole.manager => 'Manager Test',
      TestAccountRole.cashier => 'Cashier Test',
      TestAccountRole.operational => 'Operational Test',
    };
