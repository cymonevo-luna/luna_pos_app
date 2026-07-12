import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _assetPath = 'assets/marketing/pos-app-mockup.png';

void main() {
  test('marketing asset file exists and is a valid PNG', () {
    final file = File(_assetPath);
    expect(file.existsSync(), isTrue, reason: '$_assetPath must be committed');

    final bytes = file.readAsBytesSync();
    expect(bytes.length, greaterThan(8));
    // PNG magic: 137 80 78 71 13 10 26 10
    expect(bytes[0], 0x89);
    expect(bytes[1], 0x50); // P
    expect(bytes[2], 0x4E); // N
    expect(bytes[3], 0x47); // G
  });

  test('marketing asset dimensions are portrait phone size', () {
    final dimensions = _readPngDimensions(_assetPath);
    expect(dimensions.width, inInclusiveRange(400, 1200));
    expect(dimensions.height, greaterThan(dimensions.width));
  });

  test('marketing asset is optimized under 500KB', () {
    final size = File(_assetPath).lengthSync();
    expect(size, lessThan(500 * 1024));
  });
}

({int width, int height}) _readPngDimensions(String path) {
  final bytes = File(path).readAsBytesSync();
  if (bytes.length < 24) {
    throw StateError('PNG too small: $path');
  }
  final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
  final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
  return (width: width, height: height);
}
