import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/pos_menu.dart';

/// Compact single-line menu row for list layout mode: title, price, and inline
/// cart actions (decrement, quantity, increment, add note).
class MenuItemListRow extends StatelessWidget {
  const MenuItemListRow({
    super.key,
    required this.item,
    required this.cartQuantity,
    this.onIncrement,
    this.onDecrement,
    this.onAddNote,
  });

  static const double rowHeight = 52;

  final POSMenuItem item;
  final int cartQuantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onAddNote;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final inStock = item.isInStock;
    final menuId = item.id;

    return Opacity(
      opacity: inStock ? 1 : 0.55,
      child: SizedBox(
        key: Key('menu_list_row_$menuId'),
        height: rowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AppText.title(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        muted: !inStock,
                      ),
                    ),
                    if (!inStock) ...[
                      const HGap(AppSpacing.xs),
                      const Flexible(
                        child: AppText.caption(
                          'Out of stock',
                          muted: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const HGap(AppSpacing.xs),
              AppText.label(
                formatRupiah(item.sellPrice),
                color: inStock ? colors.primary : null,
                muted: !inStock,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              _CompactIconButton(
                key: Key('menu_list_dec_$menuId'),
                icon: Icons.remove,
                tooltip: 'Decrease quantity',
                onPressed: inStock ? onDecrement : null,
              ),
              SizedBox(
                key: Key('menu_list_qty_$menuId'),
                width: 28,
                child: Center(
                  child: AppText.label(
                    '$cartQuantity',
                    maxLines: 1,
                    muted: !inStock,
                  ),
                ),
              ),
              _CompactIconButton(
                key: Key('menu_list_inc_$menuId'),
                icon: Icons.add,
                tooltip: 'Increase quantity',
                onPressed: inStock ? onIncrement : null,
              ),
              _CompactIconButton(
                key: Key('menu_list_note_$menuId'),
                icon: Icons.note_add_outlined,
                tooltip: 'Add note',
                onPressed: inStock ? onAddNote : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactIconButton extends StatelessWidget {
  const _CompactIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
