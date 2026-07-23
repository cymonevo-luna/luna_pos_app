import 'models/supplier.dart';

/// Rounds [value] to the nearest integer using half-up tie-breaking.
int roundHalfUp(num value) {
  if (value.isNegative) {
    return -roundHalfUp(-value);
  }
  return (value + 0.5).floor();
}

num unitPriceForQuote(PriceQuote quote) => quote.resolvedUnitPrice;

/// Estimated line total: `round_half_up(quantity × unit_price)`.
int estimateLineTotal({
  required num quantity,
  required int priceAmount,
  required num priceQuantity,
}) {
  final unitPrice = priceAmount / priceQuantity;
  return roundHalfUp(quantity * unitPrice);
}

int estimateLineTotalForQuote({
  required num quantity,
  required PriceQuote quote,
}) =>
    estimateLineTotal(
      quantity: quantity,
      priceAmount: quote.priceAmount,
      priceQuantity: quote.priceQuantity,
    );

int estimateGrandTotal(
  Iterable<({PriceQuote quote, num quantity})> lines,
) =>
    lines.fold(
      0,
      (sum, line) =>
          sum +
          estimateLineTotalForQuote(
            quantity: line.quantity,
            quote: line.quote,
          ),
    );

/// Resolves a line total using [lineActualAmount] when provided, otherwise
/// falls back to the catalog estimate (COALESCE semantics).
int resolvedLineTotal({
  required num quantity,
  required PriceQuote quote,
  int? lineActualAmount,
}) =>
    lineActualAmount ??
    estimateLineTotalForQuote(quantity: quantity, quote: quote);

int resolvedGrandTotal(
  Iterable<({
    PriceQuote quote,
    num quantity,
    int? lineActualAmount,
  })> lines,
) =>
    lines.fold(
      0,
      (sum, line) =>
          sum +
          resolvedLineTotal(
            quantity: line.quantity,
            quote: line.quote,
            lineActualAmount: line.lineActualAmount,
          ),
    );

bool hasAnyActualAmount(
  Iterable<({int? lineActualAmount})> lines,
) =>
    lines.any((line) => line.lineActualAmount != null);
