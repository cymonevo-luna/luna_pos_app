import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/utils/text_formatting.dart';

void main() {
  test('toTitleCaseWords capitalizes each word', () {
    expect(toTitleCaseWords('nasi goreng'), 'Nasi Goreng');
    expect(toTitleCaseWords('  es teh manis '), 'Es Teh Manis');
    expect(toTitleCaseWords(''), '');
  });
}
