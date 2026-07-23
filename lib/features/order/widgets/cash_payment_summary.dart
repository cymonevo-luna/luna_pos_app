import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text.dart';

/// Prominent cash payment summary for checkout: total due, cash received, and
/// change (or insufficient-payment feedback).
class CashPaymentSummary extends StatelessWidget {
  const CashPaymentSummary({
    super.key,
    required this.totalAmount,
    required this.cashReceived,
  });

  final int totalAmount;
  final int cashReceived;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final tokens = context.tokens;
    final sufficient = isPaymentSufficient(
      cashReceived: cashReceived,
      grandTotal: totalAmount,
    );
    final changeAmount = calculatePaymentChange(
      cashReceived: cashReceived,
      grandTotal: totalAmount,
    );
    final cashReceivedFormatted = formatRupiah(cashReceived);
    final emphasizeCashReceived = cashReceived > 0;

    return Column(
      key: const Key('cash_payment_summary'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryRow(
          label: l10n.total,
          value: formatRupiah(totalAmount),
        ),
        const VGap(AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: emphasizeCashReceived
                  ? AppText.title(
                      l10n.cashReceived,
                      weight: FontWeight.w700,
                    )
                  : AppText.title(l10n.cashReceived),
            ),
            emphasizeCashReceived
                ? AppText.heading(
                    cashReceivedFormatted,
                    key: const Key('cash_received_amount'),
                    color: colors.primary,
                    weight: FontWeight.w700,
                  )
                : AppText.body(
                    cashReceivedFormatted,
                    key: const Key('cash_received_amount'),
                    muted: true,
                    align: TextAlign.end,
                  ),
          ],
        ),
        if (cashReceived > 0) ...[
          const VGap(AppSpacing.md),
          if (sufficient)
            AppCard(
              color: tokens.success.withValues(alpha: 0.14),
              elevated: false,
              child: Row(
                children: [
                  Expanded(
                    child: AppText.title(
                      l10n.change,
                      weight: FontWeight.w700,
                      color: tokens.success,
                    ),
                  ),
                  AppText.display(
                    formatRupiah(changeAmount),
                    key: const Key('change_amount_display'),
                    color: tokens.success,
                    weight: FontWeight.w800,
                  ),
                ],
              ),
            )
          else
            AppText.body(
              l10n.insufficientPayment,
              key: const Key('insufficient_payment_message'),
              color: colors.error,
              align: TextAlign.center,
              weight: FontWeight.w600,
            ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: AppText.title(label)),
        AppText.title(value),
      ],
    );
  }
}
