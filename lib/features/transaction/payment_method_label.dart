import '../../l10n/app_localizations.dart';
import '../order/models/payment_method.dart';

String paymentMethodLabel(AppLocalizations l10n, String? method) {
  if (method == null) return '—';
  return switch (PaymentMethod.fromApiValue(method)) {
    PaymentMethod.cash => l10n.paymentMethodCash,
    PaymentMethod.qris => l10n.paymentMethodQris,
    null => method,
  };
}
