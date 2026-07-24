typedef ExpenseValidationMessages = ({
  String titleRequired,
  String titleTooShort,
  String amountRequired,
  String amountInvalid,
});

class ExpenseCreateValidationResult {
  const ExpenseCreateValidationResult({
    required this.fieldErrors,
    required this.isValid,
  });

  final Map<String, String> fieldErrors;
  final bool isValid;
}

ExpenseCreateValidationResult validateExpenseCreate({
  required String title,
  required String amountText,
  required ExpenseValidationMessages messages,
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

  return ExpenseCreateValidationResult(
    fieldErrors: fieldErrors,
    isValid: fieldErrors.isEmpty,
  );
}
