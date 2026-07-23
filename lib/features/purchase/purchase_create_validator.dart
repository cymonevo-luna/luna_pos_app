class PurchaseLineInput {
  const PurchaseLineInput({
    required this.foodSupplyId,
    required this.quantity,
    this.lineActualAmount,
    this.updateCatalogPrice = false,
    this.catalogPriceAmount,
    this.catalogPriceQuantity,
  });

  final String foodSupplyId;
  final num quantity;
  final int? lineActualAmount;
  final bool updateCatalogPrice;
  final int? catalogPriceAmount;
  final num? catalogPriceQuantity;
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
  String actualPriceRequired,
  String catalogPriceAmountRequired,
  String catalogPriceQuantityRequired,
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
    if (item.lineActualAmount != null && item.lineActualAmount! <= 0) {
      fieldErrors['items[$index].line_actual_amount'] =
          messages.actualPriceRequired;
    }
    if (item.updateCatalogPrice) {
      if (item.catalogPriceAmount == null || item.catalogPriceAmount! <= 0) {
        fieldErrors['items[$index].supplier_price_update.price_amount'] =
            messages.catalogPriceAmountRequired;
      }
      if (item.catalogPriceQuantity == null ||
          item.catalogPriceQuantity! <= 0) {
        fieldErrors['items[$index].supplier_price_update.price_quantity'] =
            messages.catalogPriceQuantityRequired;
      }
    }
  }

  return PurchaseCreateValidationResult(
    fieldErrors: fieldErrors,
    formError: formError,
  );
}
