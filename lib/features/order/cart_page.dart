import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'models/order_line_item.dart';
import 'order_controller.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider);

    ref.listen<String?>(
      orderProvider.select((state) => state.errorMessage),
      (previous, next) {
        if (next != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.cart),
        actions: [
          if (order.lines.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(orderProvider.notifier).clear(),
              child: Text(l10n.clearCart),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: order.lines.isEmpty
                ? _EmptyCartView(message: l10n.emptyCart)
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: order.lines.length,
                    separatorBuilder: (_, _) => const VGap(AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final line = order.lines[index];
                      return _CartLineCard(
                        line: line,
                        l10n: l10n,
                        onQuantityChanged: (quantity) => ref
                            .read(orderProvider.notifier)
                            .updateLineQuantity(line.id, quantity),
                        onNoteChanged: (note) => ref
                            .read(orderProvider.notifier)
                            .updateLineNote(line.id, note),
                        onRemove: () =>
                            ref.read(orderProvider.notifier).removeLine(line.id),
                      );
                    },
                  ),
          ),
          _CartFooter(
            itemCount: order.itemCount,
            grandTotal: order.grandTotal,
            itemCountLabel: l10n.itemCount(order.itemCount),
            grandTotalLabel: l10n.grandTotal,
            checkoutLabel: l10n.checkout,
            onCheckout:
                order.lines.isEmpty ? null : () => context.pushNamed(AppRoute.checkout.name),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: context.tokens.textSecondary,
            ),
            const VGap(AppSpacing.md),
            AppText.body(message, align: TextAlign.center, muted: true),
          ],
        ),
      ),
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({
    required this.line,
    required this.l10n,
    required this.onQuantityChanged,
    required this.onNoteChanged,
    required this.onRemove,
  });

  final OrderLineItem line;
  final AppLocalizations l10n;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onRemove;

  Future<void> _editNote(BuildContext context) async {
    final controller = TextEditingController(text: line.note);
    final updated = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(dialogL10n.editNote),
          content: AppTextField(
            controller: controller,
            hint: dialogL10n.noteHint,
            textInputAction: TextInputAction.done,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: Text(dialogL10n.confirm),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (updated != null) {
      onNoteChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = line.note.trim().isEmpty ? l10n.noNote : line.note.trim();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: AppText.title(line.title)),
              IconButton(
                tooltip: l10n.remove,
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, color: context.colors.error),
              ),
            ],
          ),
          const VGap(AppSpacing.sm),
          Row(
            children: [
              IconButton(
                onPressed: line.quantity > 1
                    ? () => onQuantityChanged(line.quantity - 1)
                    : () => onRemove(),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              AppText.title('${line.quantity}'),
              IconButton(
                onPressed: () => onQuantityChanged(line.quantity + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Spacer(),
              AppText.title(
                formatRupiah(line.lineTotal),
                color: context.colors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const VGap(AppSpacing.xs),
          InkWell(
            onTap: () => _editNote(context),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: AppText.body(
                      '${l10n.noteLabel}: $note',
                      muted: line.note.trim().isEmpty,
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: context.tokens.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartFooter extends StatelessWidget {
  const _CartFooter({
    required this.itemCount,
    required this.grandTotal,
    required this.itemCountLabel,
    required this.grandTotalLabel,
    required this.checkoutLabel,
    required this.onCheckout,
  });

  final int itemCount;
  final int grandTotal;
  final String itemCountLabel;
  final String grandTotalLabel;
  final String checkoutLabel;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: context.colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText.body(itemCountLabel, muted: true),
              const VGap(AppSpacing.sm),
              Row(
                children: [
                  Expanded(child: AppText.title(grandTotalLabel)),
                  AppText.title(
                    formatRupiah(grandTotal),
                    color: context.colors.primary,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              const VGap(AppSpacing.md),
              AppButton(
                checkoutLabel,
                onPressed: onCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
