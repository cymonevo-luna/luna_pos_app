import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/merchant/models/merchant.dart';
import '../../features/user/models/user.dart';

/// Encrypted storage for sensitive values (auth tokens, refresh tokens, etc.),
/// backed by Keychain (iOS) / EncryptedSharedPreferences (Android).
///
/// Resolve from the locator: `locator<SecureStorageService>()`.
class SecureStorageService {
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> clear() => _storage.deleteAll();

  // Convenience helpers for the common auth-token case.
  Future<String?> readToken() => read(SecureKeys.authToken);
  Future<void> writeToken(String token) => write(SecureKeys.authToken, token);
  Future<void> deleteToken() => delete(SecureKeys.authToken);

  // Refresh token (exchanged for a new access token when it expires).
  Future<String?> readRefreshToken() => read(SecureKeys.refreshToken);
  Future<void> writeRefreshToken(String token) =>
      write(SecureKeys.refreshToken, token);
  Future<void> deleteRefreshToken() => delete(SecureKeys.refreshToken);

  // Authenticated user id (used to re-fetch the profile on startup).
  Future<String?> readUserId() => read(SecureKeys.userId);
  Future<void> writeUserId(String id) => write(SecureKeys.userId, id);
  Future<void> deleteUserId() => delete(SecureKeys.userId);

  Future<User?> readUser() async {
    final raw = await read(SecureKeys.userJson);
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writeUser(User user) =>
      write(SecureKeys.userJson, jsonEncode(user.toJson()));

  Future<void> deleteUser() => delete(SecureKeys.userJson);

  Future<Merchant?> readMerchant() async {
    final raw = await read(SecureKeys.merchantJson);
    if (raw == null) return null;
    return Merchant.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writeMerchant(Merchant merchant) =>
      write(SecureKeys.merchantJson, jsonEncode(merchant.toJson()));

  Future<void> deleteMerchant() => delete(SecureKeys.merchantJson);
}

/// Central registry of secure storage keys.
abstract final class SecureKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userJson = 'user_json';
  static const String merchantJson = 'merchant_json';
}
