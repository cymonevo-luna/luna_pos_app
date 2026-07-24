import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/auth/token_refresh_service.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/network/resource_cache.dart';
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
({ApiClient client, DioAdapter adapter, TokenRefreshService? tokenRefresh})
    buildMockedApiClient({
  SessionGuard? sessionGuard,
  FakeSecureStorage? secure,
  bool withAuthInterceptor = false,
}) {
  final guard = sessionGuard ?? SessionGuard();
  final client = ApiClient(
    baseUrl: 'https://api.test',
    onSessionExpired: () => guard.notifyExpired(),
  );
  final adapter = DioAdapter(dio: client.raw);

  TokenRefreshService? tokenRefresh;
  if (withAuthInterceptor) {
    final storage = secure ?? FakeSecureStorage();
    tokenRefresh = TokenRefreshService(
      secureStorage: storage,
      dio: client.raw,
      onSessionExpired: () => guard.notifyExpired(),
    );
    client.attachAuthInterceptor(tokenRefresh);
  }

  return (client: client, adapter: adapter, tokenRefresh: tokenRefresh);
}

/// Shared in-memory API response cache for repository tests.
ResourceCache registerTestResourceCache() {
  if (locator.isRegistered<ResourceCache>()) {
    return locator<ResourceCache>();
  }
  final cache = ResourceCache();
  locator.registerSingleton<ResourceCache>(cache);
  return cache;
}

ResourceCache testResourceCache() {
  return locator.isRegistered<ResourceCache>()
      ? locator<ResourceCache>()
      : ResourceCache();
}

/// Registers the common auth stack used by controller/interceptor tests.
TestAuthStack registerAuthTestServices({
  required FakeSecureStorage secure,
  required ApiClient client,
  SessionGuard? sessionGuard,
  bool withAuthInterceptor = true,
  bool registerInLocator = true,
}) {
  final guard = sessionGuard ?? SessionGuard();
  TokenRefreshService? tokenRefresh;

  if (withAuthInterceptor) {
    tokenRefresh = TokenRefreshService(
      secureStorage: secure,
      dio: client.raw,
      onSessionExpired: () => guard.notifyExpired(),
    );
    client.attachAuthInterceptor(tokenRefresh);
  }

  if (registerInLocator) {
    locator
      ..registerSingleton<SessionGuard>(guard)
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(client);
    if (tokenRefresh != null) {
      locator.registerSingleton<TokenRefreshService>(tokenRefresh);
    }
  }

  return TestAuthStack(
    secure: secure,
    sessionGuard: guard,
    client: client,
    tokenRefresh: tokenRefresh,
  );
}

class TestAuthStack {
  const TestAuthStack({
    required this.secure,
    required this.sessionGuard,
    required this.client,
    required this.tokenRefresh,
  });

  final FakeSecureStorage secure;
  final SessionGuard sessionGuard;
  final ApiClient client;
  final TokenRefreshService? tokenRefresh;
}

/// Full locator reset + auth stack for widget/controller tests.
Future<TestAuthStack> setupTestAuthStack() async {
  await locator.reset();
  final secure = FakeSecureStorage();
  final mocked = buildMockedApiClient();
  final stack = registerAuthTestServices(secure: secure, client: mocked.client);
  return TestAuthStack(
    secure: secure,
    sessionGuard: stack.sessionGuard,
    client: mocked.client,
    tokenRefresh: stack.tokenRefresh,
  );
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
      'features': TestAccounts.apiFeaturesFor(
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

const kTestOrderOptionTakeAwayId = 'opt-takeaway';
const kTestOrderOptionDineInId = 'opt-dinein';
const kTestOrderOptionBoxId = 'opt-box';

/// Stubs `GET /api/v1/pos/order-options` with default Take Away / Dine In options.
void stubOrderOptions(DioAdapter adapter) {
  adapter.onGet(
    '/api/v1/pos/order-options',
    (server) => server.reply(200, {
      'success': true,
      'data': {
        'options': [
          {
            'id': kTestOrderOptionTakeAwayId,
            'name': 'Take Away',
            'priority': 10,
            'additional_price': 0,
          },
          {
            'id': kTestOrderOptionDineInId,
            'name': 'Dine In',
            'priority': 5,
            'additional_price': 0,
          },
          {
            'id': kTestOrderOptionBoxId,
            'name': 'Box',
            'priority': 1,
            'additional_price': 3000,
          },
        ],
      },
    }),
  );
}

/// Stubs `GET /api/v1/pos/order-options` with an empty options list.
void stubEmptyOrderOptions(DioAdapter adapter) {
  adapter.onGet(
    '/api/v1/pos/order-options',
    (server) => server.reply(200, {
      'success': true,
      'data': {'options': <Map<String, dynamic>>[]},
    }),
  );
}

