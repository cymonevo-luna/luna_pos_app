import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _manifestPath = 'android/app/src/main/AndroidManifest.xml';

void main() {
  late String manifest;

  setUp(() {
    manifest = File(_manifestPath).readAsStringSync();
  });

  test('BLUETOOTH_SCAN is declared with neverForLocation', () {
    final scanLines = manifest
        .split('\n')
        .where((line) => line.contains('BLUETOOTH_SCAN'))
        .toList();

    expect(scanLines, hasLength(1), reason: 'BLUETOOTH_SCAN should appear once');
    expect(
      scanLines.single,
      contains('usesPermissionFlags="neverForLocation"'),
    );
  });

  test('BLUETOOTH_CONNECT is declared', () {
    expect(manifest, contains('android.permission.BLUETOOTH_CONNECT'));
  });

  test('ACCESS_FINE_LOCATION is not declared', () {
    expect(manifest, isNot(contains('ACCESS_FINE_LOCATION')));
  });

  test('legacy Bluetooth permissions are preserved with maxSdkVersion 30', () {
    expect(
      manifest,
      contains(
        'android.permission.BLUETOOTH" android:maxSdkVersion="30"',
      ),
    );
    expect(
      manifest,
      contains(
        'android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30"',
      ),
    );
  });
}
