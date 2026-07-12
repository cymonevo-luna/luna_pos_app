import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/api_exception.dart';

const purchaseProofMaxBytes = 5 * 1024 * 1024;

const _allowedExtensions = {'.jpg', '.jpeg', '.png', '.webp'};

/// Validates and uploads a purchase proof image.
class PurchaseProofUpload {
  PurchaseProofUpload(this._api);

  final ApiClient _api;

  static const uploadPath = '/api/admin/uploads/purchase-proof';

  /// Client-side validation mirroring dashboard menu upload rules.
  static void validate(XFile file, {required int byteLength}) {
    final name = file.name.toLowerCase();
    final hasAllowedExtension = _allowedExtensions.any(name.endsWith);
    if (!hasAllowedExtension) {
      throw const PurchaseProofValidationException(
        'Proof must be a JPEG, PNG, or WebP image.',
      );
    }
    if (byteLength > purchaseProofMaxBytes) {
      throw const PurchaseProofValidationException(
        'Proof image must be 5 MB or smaller.',
      );
    }
  }

  Future<String> upload(XFile file) async {
    final bytes = await file.readAsBytes();
    validate(file, byteLength: bytes.length);

    final mime = _mimeTypeFor(file.name);
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: DioMediaType.parse(mime),
        ),
      });

      final response = await _api.raw.post<dynamic>(
        uploadPath,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = unwrapApiEnvelope(response.data);
      final url = data['url'] as String?;
      if (url == null || url.trim().isEmpty) {
        throw const ApiException(
          type: ApiErrorType.unknown,
          message: 'Upload did not return a URL.',
        );
      }
      return url;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static String _mimeTypeFor(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}

class PurchaseProofValidationException implements Exception {
  const PurchaseProofValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
