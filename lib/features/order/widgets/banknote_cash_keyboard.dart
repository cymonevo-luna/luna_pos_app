import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_text.dart';
import '../models/cash_denominations.dart';

/// Cashier-style banknote input panel with per-denomination quantity steppers.
class BanknoteCashKeyboard extends StatelessWidget {
  const BanknoteCashKeyboard({
    super.key,
    required this.counts,
    required this.onCountsChanged,
    this.enabled = true,
  });

  final Map<int, int> counts;
  final ValueChanged<Map<int, int>> onCountsChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: const Key('cash_tendered_field'),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < supportedCashDenominations.length; index++) ...[
              if (index > 0) const VGap(AppSpacing.sm),
              _BanknoteDenominationRow(
                denomination: supportedCashDenominations[index],
                quantity: counts[supportedCashDenominations[index]] ?? 0,
                enabled: enabled,
                onIncrement: () => onCountsChanged(
                  incrementDenominationCount(
                    counts,
                    supportedCashDenominations[index],
                  ),
                ),
                onDecrement: () => onCountsChanged(
                  decrementDenominationCount(
                    counts,
                    supportedCashDenominations[index],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BanknoteDenominationRow extends StatelessWidget {
  const _BanknoteDenominationRow({
    required this.denomination,
    required this.quantity,
    required this.enabled,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int denomination;
  final int quantity;
  final bool enabled;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final canDecrement = enabled && quantity > 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(denominationShortLabel(denomination)),
              AppText.caption(
                formatRupiah(denomination),
                muted: true,
              ),
            ],
          ),
        ),
        IconButton(
          key: Key('banknote_${denomination}_decrement'),
          onPressed: canDecrement ? onDecrement : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        AppText.title(
          '$quantity',
          key: Key('banknote_${denomination}_qty'),
        ),
        IconButton(
          key: Key('banknote_${denomination}_increment'),
          onPressed: enabled ? onIncrement : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
