import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/core/config/app_config.dart';

import 'package:flutter_template/core/utils/photo_url_resolver.dart';

void main() {
  setUpAll(() async {
    await AppConfig.load();
  });

  test('resolvePhotoUrl keeps absolute URLs unchanged', () {
    expect(
      resolvePhotoUrl('https://cdn.example.com/food.png'),
      'https://cdn.example.com/food.png',
    );
  });

  test('resolvePhotoUrl prefixes relative paths with API base URL', () {
    expect(
      resolvePhotoUrl('/static/default-food.png'),
      contains('/static/default-food.png'),
    );
  });

  test('resolvePhotoUrl returns empty for null or blank values', () {
    expect(resolvePhotoUrl(null), '');
    expect(resolvePhotoUrl(''), '');
    expect(resolvePhotoUrl('   '), '');
  });
}
