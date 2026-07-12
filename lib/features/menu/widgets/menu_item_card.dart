import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/pos_menu.dart';
import 'menu_photo.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.onAdd,
  });

  final POSMenuItem item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final inStock = item.isInStock;
    final borderColor = inStock ? Colors.transparent : tokens.border;

    return Opacity(
      opacity: inStock ? 1 : 0.55,
      child: AppCard(
        elevated: true,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.brLg,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.brLg,
            border: Border.all(color: borderColor),
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
                    const VGap(AppSpacing.sm),
                    AppButton(
                      l10n.addToCart,
                      size: AppButtonSize.small,
                      onPressed: inStock ? onAdd : null,
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
