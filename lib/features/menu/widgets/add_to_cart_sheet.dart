import 'package:flutter/material.dart';

import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/pos_menu.dart';

/// Bottom sheet for choosing quantity and an optional note before adding to cart.
Future<void> showAddToCartSheet({
  required BuildContext context,
  required POSMenuItem item,
  required void Function(int quantity, String note) onAdd,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _AddToCartSheet(
        item: item,
        onAdd: (quantity, note) {
          Navigator.of(sheetContext).pop();
          onAdd(quantity, note);
        },
      );
    },
  );
}

class _AddToCartSheet extends StatefulWidget {
  const _AddToCartSheet({required this.item, required this.onAdd});

  final POSMenuItem item;
  final void Function(int quantity, String note) onAdd;

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  int _quantity = 1;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _increment() {
    if (_quantity < widget.item.availableStock) {
      setState(() => _quantity++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(widget.item.title),
          const VGap(AppSpacing.xs),
          AppText.body(
            formatRupiah(widget.item.sellPrice),
            color: Theme.of(context).colorScheme.primary,
          ),
          const VGap(AppSpacing.lg),
          AppText.label(l10n.quantityLabel),
          const VGap(AppSpacing.xs),
          _QuantityStepper(
            quantity: _quantity,
            onDecrement: _decrement,
            onIncrement: _increment,
          ),
          const VGap(AppSpacing.md),
          AppTextField(
            label: l10n.noteLabel,
            hint: l10n.noteHint,
            controller: _noteController,
            textInputAction: TextInputAction.done,
          ),
          const VGap(AppSpacing.lg),
          AppButton(
            l10n.add,
            onPressed: () => widget.onAdd(_quantity, _noteController.text),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: quantity > 1 ? onDecrement : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        AppText.title('$quantity'),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
