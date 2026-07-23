import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_text.dart';

/// Single banknote denomination row with decrement / quantity / increment controls.
class BanknoteQuantityRow extends StatelessWidget {
  const BanknoteQuantityRow({
    super.key,
    required this.denomination,
    required this.label,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int denomination;
  final String label;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  static const double _minTapSize = 48;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: Key('banknote_row_$denomination'),
      child: Row(
        children: [
          Expanded(
            child: AppText.title(label),
          ),
          const HGap(AppSpacing.sm),
          _StepperButton(
            key: Key('banknote_decrement_$denomination'),
            icon: Icons.remove_circle_outline,
            onPressed: quantity > 0 ? onDecrement : null,
          ),
          SizedBox(
            width: _minTapSize,
            child: Center(
              child: AppText.title(
                '$quantity',
                key: Key('banknote_qty_$denomination'),
              ),
            ),
          ),
          _StepperButton(
            key: Key('banknote_increment_$denomination'),
            icon: Icons.add_circle_outline,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BanknoteQuantityRow._minTapSize,
      height: BanknoteQuantityRow._minTapSize,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
