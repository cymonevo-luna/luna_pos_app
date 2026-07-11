import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/widgets.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.checkoutLabel,
    required this.onCheckout,
  });

  final int itemCount;
  final int subtotal;
  final String checkoutLabel;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      elevation: 8,
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.label('$itemCount items'),
                    const VGap(AppSpacing.xxs),
                    AppText.title(formatRupiah(subtotal)),
                  ],
                ),
              ),
              const HGap(AppSpacing.md),
              AppButton(
                checkoutLabel,
                expand: false,
                size: AppButtonSize.medium,
                onPressed: onCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
