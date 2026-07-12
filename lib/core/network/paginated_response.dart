/// Decodes a paginated `{ "data": [...], "meta": { page, per_page, total } }`
/// envelope into a typed page.
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
  });

  final List<T> items;
  final int page;
  final int perPage;
  final int total;

  bool get hasMore => page * perPage < total;
}

PaginatedResponse<T> decodePaginatedEnvelope<T>(
  dynamic raw,
  T Function(Map<String, dynamic> json) itemDecoder,
) {
  final map = (raw as Map).cast<String, dynamic>();
  final items = (map['data'] as List<dynamic>)
      .map((entry) => itemDecoder((entry as Map).cast<String, dynamic>()))
      .toList();
  final meta = (map['meta'] as Map).cast<String, dynamic>();
  return PaginatedResponse<T>(
    items: items,
    page: (meta['page'] as num).toInt(),
    perPage: (meta['per_page'] as num).toInt(),
    total: (meta['total'] as num).toInt(),
  );
}
