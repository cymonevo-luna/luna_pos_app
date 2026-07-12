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
