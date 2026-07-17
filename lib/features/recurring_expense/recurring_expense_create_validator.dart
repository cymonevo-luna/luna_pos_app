import 'models/recurring_expense.dart';

class RecurringExpenseValidationResult {
  const RecurringExpenseValidationResult({
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;

  bool get isValid => fieldErrors.isEmpty;

  String? messageForField(String key) => fieldErrors[key];
}

typedef RecurringExpenseValidationMessages = ({
  String titleRequired,
  String titleTooShort,
  String amountRequired,
  String amountInvalid,
  String valueRequired,
  String dayOfMonthInvalid,
  String weekdayInvalid,
});

RecurringExpenseValidationResult validateRecurringExpenseCreate({
  required String title,
  required String amountText,
  required RecurringInterval interval,
  required String? valueText,
  required RecurringExpenseValidationMessages messages,
}) {
  final fieldErrors = <String, String>{};

  final trimmedTitle = title.trim();
  if (trimmedTitle.isEmpty) {
    fieldErrors['title'] = messages.titleRequired;
  } else if (trimmedTitle.length < 2) {
    fieldErrors['title'] = messages.titleTooShort;
  }

  final trimmedAmount = amountText.trim();
  if (trimmedAmount.isEmpty) {
    fieldErrors['amount'] = messages.amountRequired;
  } else {
    final parsed = int.tryParse(trimmedAmount.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed == null || parsed <= 0) {
      fieldErrors['amount'] = messages.amountInvalid;
    }
  }

  if (interval != RecurringInterval.daily) {
    final trimmedValue = valueText?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      fieldErrors['value'] = messages.valueRequired;
    } else {
      final parsed = int.tryParse(trimmedValue);
      if (parsed == null) {
        fieldErrors['value'] = messages.valueRequired;
      } else if (interval == RecurringInterval.date &&
          (parsed < 1 || parsed > 31)) {
        fieldErrors['value'] = messages.dayOfMonthInvalid;
      } else if (interval == RecurringInterval.day &&
          (parsed < 1 || parsed > 7)) {
        fieldErrors['value'] = messages.weekdayInvalid;
      }
    }
  }

  return RecurringExpenseValidationResult(fieldErrors: fieldErrors);
}
