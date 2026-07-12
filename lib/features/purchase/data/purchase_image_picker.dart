import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Abstraction over [ImagePicker] so widget tests can inject fakes.
abstract class PurchaseImagePicker {
  Future<XFile?> pickFromCamera();
  Future<XFile?> pickFromGallery();
}

class RealPurchaseImagePicker implements PurchaseImagePicker {
  RealPurchaseImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  @override
  Future<XFile?> pickFromGallery() => _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2048,
        maxHeight: 2048,
      );
}
