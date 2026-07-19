import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/network/resource_cache.dart';

void main() {
  test('returns cached value within TTL', () async {
    final cache = ResourceCache(ttl: const Duration(seconds: 60));
    var calls = 0;

    final first = await cache.get('menu', () async {
      calls++;
      return 'data';
    });
    final second = await cache.get('menu', () async {
      calls++;
      return 'other';
    });

    expect(first, 'data');
    expect(second, 'data');
    expect(calls, 1);
  });

  test('deduplicates concurrent in-flight requests', () async {
    final cache = ResourceCache();
    var calls = 0;

    final results = await Future.wait([
      cache.get('menu', () async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return 'shared';
      }),
      cache.get('menu', () async {
        calls++;
        return 'other';
      }),
    ]);

    expect(results, ['shared', 'shared']);
    expect(calls, 1);
  });

  test('forceRefresh bypasses cache', () async {
    final cache = ResourceCache(ttl: const Duration(seconds: 60));
    var calls = 0;

    await cache.get('menu', () async {
      calls++;
      return 'first';
    });
    final refreshed = await cache.get(
      'menu',
      () async {
        calls++;
        return 'second';
      },
      forceRefresh: true,
    );

    expect(refreshed, 'second');
    expect(calls, 2);
  });

  test('invalidate removes cached entry', () async {
    final cache = ResourceCache(ttl: const Duration(seconds: 60));
    var calls = 0;

    await cache.get('menu', () async {
      calls++;
      return 'first';
    });
    cache.invalidate('menu');
    final second = await cache.get('menu', () async {
      calls++;
      return 'second';
    });

    expect(second, 'second');
    expect(calls, 2);
  });

  test('resourceCacheKey sorts query parameters', () {
    expect(
      resourceCacheKey('GET', '/api/v1/pos/transactions', {
        'per_page': 20,
        'page': 1,
      }),
      resourceCacheKey('GET', '/api/v1/pos/transactions', {
        'page': 1,
        'per_page': 20,
      }),
    );
  });
}
