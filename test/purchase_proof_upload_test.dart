import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:luna_pos/features/purchase/data/purchase_proof_upload.dart';

void main() {
  test('validate rejects unsupported file types', () {
    expect(
      () => PurchaseProofUpload.validate(
        XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'proof.gif'),
        byteLength: 3,
      ),
      throwsA(isA<PurchaseProofValidationException>()),
    );
  });

  test('validate rejects files larger than 5 MB', () {
    expect(
      () => PurchaseProofUpload.validate(
        XFile.fromData(Uint8List(0), name: 'proof.jpg'),
        byteLength: purchaseProofMaxBytes + 1,
      ),
      throwsA(isA<PurchaseProofValidationException>()),
    );
  });

  test('validate accepts jpeg png and webp', () async {
    for (final name in ['proof.jpg', 'proof.png', 'proof.webp']) {
      final file = File('${Directory.systemTemp.path}/$name');
      await file.writeAsBytes(const [0xFF, 0xD8, 0xFF, 0xD9]);
      expect(
        () => PurchaseProofUpload.validate(
          XFile(file.path, name: name),
          byteLength: 4,
        ),
        returnsNormally,
      );
    }
  });
}
