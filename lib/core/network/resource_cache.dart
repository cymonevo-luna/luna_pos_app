/// In-memory cache for read-heavy API responses with TTL and in-flight
/// request deduplication.
class ResourceCache {
  ResourceCache({this.ttl = cacheTtl});

  static const cacheTtl = Duration(seconds: 60);

  final Duration ttl;
  final Map<String, _CacheEntry> _entries = {};
  final Map<String, Future<dynamic>> _inFlight = {};

  Future<T> get<T>(
    String key,
    Future<T> Function() fetch, {
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _entries[key];
      if (cached != null && !cached.isExpired) {
        return cached.value as T;
      }

      final inFlight = _inFlight[key];
      if (inFlight != null) {
        return await inFlight as T;
      }
    } else {
      _entries.remove(key);
    }

    final future = fetch().then((value) {
      _entries[key] = _CacheEntry(
        value,
        DateTime.now().add(ttl ?? this.ttl),
      );
      return value;
    });

    _inFlight[key] = future;
    try {
      return await future;
    } finally {
      if (identical(_inFlight[key], future)) {
        _inFlight.remove(key);
      }
    }
  }

  void invalidate(String key) {
    _entries.remove(key);
    _inFlight.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _entries.removeWhere((key, _) => key.startsWith(prefix));
    _inFlight.removeWhere((key, _) => key.startsWith(prefix));
  }

  void invalidateAll() {
    _entries.clear();
    _inFlight.clear();
  }
}

class _CacheEntry {
  _CacheEntry(this.value, this.expiresAt);

  final Object? value;
  final DateTime expiresAt;

  bool get isExpired => !expiresAt.isAfter(DateTime.now());
}

String resourceCacheKey(String method, String path, [Map<String, dynamic>? query]) {
  if (query == null || query.isEmpty) {
    return '$method:$path';
  }

  final sortedKeys = query.keys.toList()..sort();
  final queryString = sortedKeys
      .map((key) => '$key=${query[key]}')
      .join('&');
  return '$method:$path?$queryString';
}
