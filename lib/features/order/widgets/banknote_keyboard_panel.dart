import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../models/idr_banknote.dart';
import 'banknote_quantity_row.dart';

/// Cashier-style banknote input panel: one row per IDR denomination.
class BanknoteKeyboardPanel extends StatelessWidget {
  const BanknoteKeyboardPanel({
    super.key,
    required this.counts,
    required this.onCountsChanged,
  });

  final Map<int, int> counts;
  final ValueChanged<Map<int, int>> onCountsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const Key('banknote_clear_all'),
            onPressed: () => onCountsChanged(clearBanknoteCounts()),
            child: Text(l10n.clearBanknotes),
          ),
        ),
        for (var i = 0; i < idrBanknoteDenominations.length; i++) ...[
          if (i > 0) const VGap(AppSpacing.sm),
          BanknoteQuantityRow(
            denomination: idrBanknoteDenominations[i],
            label: idrBanknoteDisplayLabel(idrBanknoteDenominations[i]),
            quantity: counts[idrBanknoteDenominations[i]] ?? 0,
            onIncrement: () => onCountsChanged(
              incrementBanknoteCount(counts, idrBanknoteDenominations[i]),
            ),
            onDecrement: () => onCountsChanged(
              decrementBanknoteCount(counts, idrBanknoteDenominations[i]),
            ),
          ),
        ],
      ],
    );
  }
}
