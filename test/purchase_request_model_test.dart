import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/purchase/models/purchase_request.dart';

void main() {
  group('PurchaseRequestItem.fromJson', () {
    test('parses string unit_price', () {
      final item = PurchaseRequestItem.fromJson({
        'food_supply_id': 'fs-1',
        'quantity': '2',
        'unit_price': '50000',
      });

      expect(item.unitPrice, 50000);
    });

    test('parses numeric unit_price', () {
      final item = PurchaseRequestItem.fromJson({
        'food_supply_id': 'fs-1',
        'quantity': 2,
        'unit_price': 50000,
      });

      expect(item.unitPrice, 50000);
    });
  });

  group('PurchaseRequestDetail.fromJson', () {
    test('parses total_actual_amount and line_actual_amount', () {
      final detail = PurchaseRequestDetail.fromJson({
        'id': 'pr-1',
        'supplier_id': 'sup-1',
        'supplier_name': 'Supplier A',
        'status': 'REQUESTED',
        'total_estimated_amount': 100000,
        'total_actual_amount': '95000',
        'items': [
          {
            'food_supply_id': 'fs-1',
            'quantity': '1',
            'line_estimated_amount': 100000,
            'line_actual_amount': '95000',
            'unit_price': '50000',
          },
        ],
      });

      expect(detail.totalActualAmount, 95000);
      expect(detail.items.first.lineActualAmount, 95000);
      expect(detail.items.first.unitPrice, 50000);
    });
  });

  group('PurchaseRequestSummary.fromJson', () {
    test('parses total_actual_amount from string', () {
      final summary = PurchaseRequestSummary.fromJson({
        'id': 'pr-1',
        'supplier_name': 'Supplier A',
        'status': 'REQUESTED',
        'total_estimated_amount': 100000,
        'total_actual_amount': '135000',
        'item_count': 1,
      });

      expect(summary.totalActualAmount, 135000);
    });
  });
}
