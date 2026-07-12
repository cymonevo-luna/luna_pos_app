import 'api_exception.dart';

/// Extracts per-field validation messages from a 422 API response body.
Map<String, String> parseApiFieldErrors(dynamic data) {
  if (data is! Map) return const {};

  final error = data['error'];
  if (error is! Map) return const {};

  final fields = error['fields'];
  if (fields is! Map) return const {};

  return fields.map(
    (key, value) => MapEntry(key.toString(), _messageForField(value)),
  );
}

String? validationMessageFor(ApiException exception) {
  if (exception.statusCode != 422) return null;
  final fields = parseApiFieldErrors(exception.data);
  if (fields.isEmpty) return exception.message;
  return fields.values.first;
}

String _messageForField(dynamic value) {
  if (value is String) return value;
  if (value is List && value.isNotEmpty) return value.first.toString();
  return value?.toString() ?? 'Invalid value';
}
