import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:luna_pos/features/menu_management/data/menu_photo_upload.dart';

void main() {
  test('validate rejects unsupported file types', () {
    expect(
      () => MenuPhotoUpload.validate(
        XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'menu.gif'),
        byteLength: 3,
      ),
      throwsA(isA<MenuPhotoValidationException>()),
    );
  });

  test('validate rejects files larger than 5 MB', () {
    expect(
      () => MenuPhotoUpload.validate(
        XFile.fromData(Uint8List(0), name: 'menu.jpg'),
        byteLength: menuPhotoMaxBytes + 1,
      ),
      throwsA(isA<MenuPhotoValidationException>()),
    );
  });

  test('validate accepts jpeg png and webp', () async {
    for (final name in ['menu.jpg', 'menu.png', 'menu.webp']) {
      final file = File('${Directory.systemTemp.path}/$name');
      await file.writeAsBytes(const [0xFF, 0xD8, 0xFF, 0xD9]);
      expect(
        () => MenuPhotoUpload.validate(
          XFile(file.path, name: name),
          byteLength: 4,
        ),
        returnsNormally,
      );
    }
  });
}
