/// Unwraps the standard `{ "success": ..., "data": ... }` API envelope.
Map<String, dynamic> unwrapApiEnvelope(dynamic raw) {
  final map = (raw as Map).cast<String, dynamic>();
  return (map['data'] as Map).cast<String, dynamic>();
}
