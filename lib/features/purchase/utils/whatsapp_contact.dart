import '../models/purchase_request.dart';

/// Extracts a WhatsApp-ready phone number from free-form supplier contact text.
String? extractWhatsAppPhone(String? contactInfo) {
  final raw = contactInfo?.trim();
  if (raw == null || raw.isEmpty) return null;

  final digitsOnly = raw.replaceAll(RegExp(r'[^\d]'), '');
  if (digitsOnly.isEmpty) return null;

  if (digitsOnly.startsWith('62')) return digitsOnly;
  if (digitsOnly.startsWith('0')) return '62${digitsOnly.substring(1)}';
  return digitsOnly;
}

String buildPurchaseWhatsAppMessage(PurchaseRequestDetail detail) {
  final buffer = StringBuffer('Hello ${detail.supplierName}, ');
  buffer.write('regarding purchase request #${detail.id}');
  if (detail.totalEstimatedAmount != null) {
    buffer.write(' (estimated total: ${detail.totalEstimatedAmount})');
  }
  buffer.write('.');
  return buffer.toString();
}

String buildWhatsAppUrl(String phone, String message) {
  final encoded = Uri.encodeComponent(message);
  return 'https://wa.me/$phone?text=$encoded';
}
