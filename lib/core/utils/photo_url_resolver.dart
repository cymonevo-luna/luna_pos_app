import '../config/app_config.dart';

/// Resolves a menu photo URL against the API base URL when relative.
String resolvePhotoUrl(String? photoUrl) {
  final value = photoUrl?.trim();
  if (value == null || value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
  final path = value.startsWith('/') ? value : '/$value';
  return '$base$path';
}
