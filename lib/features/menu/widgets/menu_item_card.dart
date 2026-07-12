import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/pos_menu.dart';
import 'menu_photo.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item, required this.onAdd});

  final POSMenuItem item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final inStock = item.isInStock;
    final borderColor = inStock ? Colors.transparent : tokens.border;

    return Opacity(
      opacity: inStock ? 1 : 0.55,
      child: AppCard(
        elevated: true,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.brLg,
        onTap: inStock ? onAdd : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.brLg,
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                      child: SizedBox.expand(
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
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.title(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const VGap(AppSpacing.xxs),
                        AppText.label(
                          formatRupiah(item.sellPrice),
                          color: colors.primary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const VGap(AppSpacing.xxs),
                        AppText.body(
                          inStock
                              ? 'Stock: ${item.availableStock}'
                              : 'Out of stock',
                          muted: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
        child: AppText.label('Out of stock', color: colors.onErrorContainer),
      ),
    );
  }
}
