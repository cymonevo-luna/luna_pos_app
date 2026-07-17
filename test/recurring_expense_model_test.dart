import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/features/recurring_expense/models/recurring_expense.dart';

void main() {
  const recurringJson = {
    'interval': 'DAILY',
    'time': {'hour': 9, 'minute': 0, 'second': 0},
  };

  test('fromJson deserializes staff_id to staffId', () {
    final expense = RecurringExpense.fromJson({
      'id': 're-staff',
      'title': 'Staff payout',
      'description': '',
      'amount': 5000000,
      'is_active': true,
      'staff_id': 'staff-42',
      'recurring': recurringJson,
    });

    expect(expense.staffId, 'staff-42');
    expect(expense.isStaffManaged, isTrue);
  });

  test('fromJson leaves staffId null when staff_id is absent', () {
    final expense = RecurringExpense.fromJson({
      'id': 're-regular',
      'title': 'Rent',
      'description': '',
      'amount': 2500000,
      'is_active': true,
      'recurring': recurringJson,
    });

    expect(expense.staffId, isNull);
    expect(expense.isStaffManaged, isFalse);
  });
}
