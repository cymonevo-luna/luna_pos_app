import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/pos_menu.dart';
import 'menu_photo.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onTap,
    this.onIncrement,
    this.onDecrement,
  });

  final POSMenuItem item;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final inStock = item.isInStock;
    final inCart = quantity > 0;
    final borderColor = inCart
        ? colors.primary
        : (inStock ? Colors.transparent : tokens.border);

    return Opacity(
      opacity: inStock ? 1 : 0.55,
      child: AppCard(
        onTap: inStock ? onTap : null,
        elevated: !inCart,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.brLg,
        color: inCart ? colors.primaryContainer.withValues(alpha: 0.35) : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.brLg,
            border: Border.all(
              color: borderColor,
              width: inCart ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: MenuPhoto(photoUrl: item.photoUrl),
                    ),
                  ),
                  if (!inStock)
                    const Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: _OutOfStockBadge(),
                    ),
                  if (inCart)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _QuantityBadge(quantity: quantity),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const VGap(AppSpacing.xs),
                    AppText.label(
                      formatRupiah(item.sellPrice),
                      color: colors.primary,
                    ),
                    const VGap(AppSpacing.xs),
                    AppText.body(
                      inStock
                          ? 'Stock: ${item.availableStock}'
                          : 'Out of stock',
                      muted: true,
                    ),
                    if (inStock && inCart && onIncrement != null) ...[
                      const VGap(AppSpacing.sm),
                      _QuantityControls(
                        quantity: quantity,
                        onIncrement: onIncrement!,
                        onDecrement: onDecrement,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  const _QuantityBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: AppRadius.brSm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: AppText.label(
          '$quantity',
          color: colors.onPrimary,
        ),
      ),
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantity,
    required this.onIncrement,
    this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityButton(
          icon: Icons.remove,
          onPressed: onDecrement,
        ),
        Expanded(
          child: Center(
            child: AppText.label('$quantity'),
          ),
        ),
        _QuantityButton(
          icon: Icons.add,
          onPressed: onIncrement,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
      ),
    );
  }
}

class _OutOfStockBadge extends StatelessWidget {
  const _OutOfStockBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: AppRadius.brSm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: AppText.label(
          'Out of stock',
          color: colors.onErrorContainer,
        ),
      ),
    );
  }
}
