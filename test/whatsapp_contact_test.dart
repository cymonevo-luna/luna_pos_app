import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/purchase/models/purchase_request.dart';
import 'package:luna_pos/features/purchase/utils/whatsapp_contact.dart';

void main() {
  test('extractWhatsAppPhone normalizes Indonesian numbers', () {
    expect(extractWhatsAppPhone('081234567890'), '6281234567890');
    expect(extractWhatsAppPhone('+62 812-3456-7890'), '6281234567890');
    expect(extractWhatsAppPhone(''), isNull);
  });

  test('buildPurchaseWhatsAppMessage includes supplier and request id', () {
    const detail = PurchaseRequestDetail(
      id: 'pr-1',
      supplierId: 'sup-1',
      supplierName: 'Supplier A',
      status: PurchaseRequestStatus.requested,
      totalEstimatedAmount: 100000,
    );

    final message = buildPurchaseWhatsAppMessage(detail);
    expect(message, contains('Supplier A'));
    expect(message, contains('pr-1'));
  });
}
