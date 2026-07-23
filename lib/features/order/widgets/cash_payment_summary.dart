import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text.dart';

/// Prominent cash payment summary for checkout: received cash, insufficient
/// payment warning, and change (kembalian).
class CashPaymentSummary extends StatelessWidget {
  const CashPaymentSummary({
    super.key,
    required this.cashTendered,
    required this.grandTotal,
    required this.l10n,
  });

  final int cashTendered;
  final int grandTotal;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final changeAmount = calculatePaymentChange(
      cashReceived: cashTendered,
      grandTotal: grandTotal,
    );
    final showInsufficient = cashTendered > 0 &&
        !isPaymentSufficient(
          cashReceived: cashTendered,
          grandTotal: grandTotal,
        );
    final showChange = cashTendered >= grandTotal && grandTotal > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: AppText.title(l10n.cashReceived)),
            AppText.title(
              formatRupiah(cashTendered),
              key: const Key('cash_received_summary'),
            ),
          ],
        ),
        if (showInsufficient) ...[
          const VGap(AppSpacing.sm),
          AppText.body(
            l10n.insufficientPayment,
            key: const Key('insufficient_payment_message'),
            color: colors.error,
            align: TextAlign.center,
          ),
        ],
        if (showChange) ...[
          const VGap(AppSpacing.md),
          AppCard(
            color: colors.errorContainer,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText.title(
                    l10n.change,
                    weight: FontWeight.w700,
                  ),
                ),
                AppText.title(
                  '-${formatRupiah(changeAmount)}',
                  key: const Key('change_summary'),
                  color: colors.error,
                  weight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
