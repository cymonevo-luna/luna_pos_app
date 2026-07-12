import 'package:image_picker/image_picker.dart';

import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:luna_pos/features/purchase/data/purchase_proof_upload.dart';

class FakePurchaseImagePicker implements PurchaseImagePicker {
  XFile? cameraResult;
  XFile? galleryResult;

  @override
  Future<XFile?> pickFromCamera() async => cameraResult;

  @override
  Future<XFile?> pickFromGallery() async => galleryResult;
}

class FakePurchaseProofUpload extends PurchaseProofUpload {
  FakePurchaseProofUpload() : super(_FakeApiClient());

  String? lastUploadedPath;
  String uploadedUrl = '/uploads/proof.jpg';

  @override
  Future<String> upload(XFile file) async {
    lastUploadedPath = file.path;
    return uploadedUrl;
  }
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(baseUrl: 'https://api.test');
}
