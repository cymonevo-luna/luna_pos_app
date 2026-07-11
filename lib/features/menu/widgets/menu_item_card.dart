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
    required this.selected,
    required this.onTap,
  });

  final POSMenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final inStock = item.isInStock;
    final borderColor = selected
        ? colors.primary
        : (inStock ? Colors.transparent : tokens.border);

    return Opacity(
      opacity: inStock ? 1 : 0.55,
      child: AppCard(
        onTap: inStock ? onTap : null,
        elevated: !selected,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.brLg,
        color: selected ? colors.primaryContainer.withValues(alpha: 0.35) : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.brLg,
            border: Border.all(
              color: borderColor,
              width: selected ? 2 : 1,
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
