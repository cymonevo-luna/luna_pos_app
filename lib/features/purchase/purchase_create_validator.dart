class PurchaseLineInput {
  const PurchaseLineInput({
    required this.foodSupplyId,
    required this.quantity,
  });

  final String foodSupplyId;
  final num quantity;
}

class PurchaseCreateValidationResult {
  const PurchaseCreateValidationResult({
    this.fieldErrors = const {},
    this.formError,
  });

  final Map<String, String> fieldErrors;
  final String? formError;

  bool get isValid => fieldErrors.isEmpty && formError == null;

  String? messageForField(String key) => fieldErrors[key];
}

typedef PurchaseCreateValidationMessages = ({
  String supplierRequired,
  String atLeastOneItem,
  String duplicateItem,
  String quantityRequired,
});

PurchaseCreateValidationResult validatePurchaseCreate({
  required String? supplierId,
  required List<PurchaseLineInput> items,
  required PurchaseCreateValidationMessages messages,
}) {
  final fieldErrors = <String, String>{};
  String? formError;

  if (supplierId == null || supplierId.isEmpty) {
    formError = messages.supplierRequired;
  }

  if (items.isEmpty) {
    formError ??= messages.atLeastOneItem;
  }

  final seen = <String>{};
  for (var index = 0; index < items.length; index++) {
    final item = items[index];
    if (!seen.add(item.foodSupplyId)) {
      fieldErrors['items'] = messages.duplicateItem;
    }
    if (item.quantity <= 0) {
      fieldErrors['items[$index].quantity'] = messages.quantityRequired;
    }
  }

  return PurchaseCreateValidationResult(
    fieldErrors: fieldErrors,
    formError: formError,
  );
}
