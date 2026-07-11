import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import '../menu/menu_controller.dart';
import '../menu/models/cart_line.dart';
import 'checkout_calculations.dart';
import 'checkout_controller.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _cashController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  int get _cashTendered => int.tryParse(_cashController.text.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final menu = ref.watch(menuProvider);
    final checkout = ref.watch(checkoutProvider);
    final cart = menu.cart;
    final total = cartSubtotal(cart);
    final changeAmount = computeChangeAmount(
      cashTendered: _cashTendered,
      total: total,
    );
    final canComplete = isPaymentSufficient(
      cashTendered: _cashTendered,
      total: total,
    );

    ref.listen(checkoutProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    if (cart.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppSectionHeader(title: l10n.orderSummary),
          const VGap(AppSpacing.sm),
          for (final line in cart.values) ...[
            _CheckoutLineTile(
              line: line,
              onIncrement: () {
                final menuItem = _findMenuItem(line.menuId);
                if (menuItem == null) return;
                ref.read(menuProvider.notifier).updateCartQuantity(
                      line.menuId,
                      line.quantity + 1,
                    );
              },
              onDecrement: () {
                if (line.quantity <= 1) {
                  ref.read(menuProvider.notifier).removeFromCart(line.menuId);
                } else {
                  ref.read(menuProvider.notifier).updateCartQuantity(
                        line.menuId,
                        line.quantity - 1,
                      );
                }
              },
              onRemove: () =>
                  ref.read(menuProvider.notifier).removeFromCart(line.menuId),
            ),
            const VGap(AppSpacing.sm),
          ],
          const VGap(AppSpacing.md),
          _SummaryRow(
            label: l10n.total,
            value: formatRupiah(total),
            emphasized: true,
          ),
          const VGap(AppSpacing.lg),
          AppTextField(
            key: const Key('cash_tendered_field'),
            label: l10n.cashTendered,
            hint: '0',
            controller: _cashController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const VGap(AppSpacing.md),
          Row(
            children: [
              Expanded(child: AppText.label(l10n.changeAmount)),
              AppText.title(formatRupiah(changeAmount)),
            ],
          ),
          const VGap(AppSpacing.xl),
          AppButton(
            l10n.completeSale,
            loading: checkout.submitting,
            onPressed: canComplete && !checkout.submitting
                ? () => _completeSale(cart, total, changeAmount, l10n)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _completeSale(
    Map<String, CartLine> cart,
    int total,
    int changeAmount,
    AppLocalizations l10n,
  ) async {
    final success = await ref.read(checkoutProvider.notifier).completeOfflineSale(
          cart: cart,
          cashTendered: _cashTendered,
        );

    if (!mounted || !success) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.saleComplete),
        content: Text(l10n.saleCompleteMessage(formatRupiah(changeAmount))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );

    if (!mounted) return;
    context.goNamed(AppRoute.home.name);
  }

  dynamic _findMenuItem(String menuId) {
    final data = ref.read(menuProvider).data;
    if (data == null) return null;

    for (final category in data.categories) {
      for (final menu in category.menus) {
        if (menu.id == menuId) return menu;
      }
    }
    return null;
  }
}

class _CheckoutLineTile extends StatelessWidget {
  const _CheckoutLineTile({
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartLine line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppText.title(line.title)),
              IconButton(
                tooltip: 'Remove',
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          const VGap(AppSpacing.xs),
          AppText.body(
            '${formatRupiah(line.sellPrice)} x ${line.quantity}',
            muted: true,
          ),
          const VGap(AppSpacing.sm),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              AppText.label('${line.quantity}'),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Spacer(),
              Flexible(
                child: AppText.title(
                  formatRupiah(line.lineTotal),
                  align: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: emphasized
              ? AppText.title(label)
              : AppText.body(label),
        ),
        emphasized ? AppText.title(value) : AppText.body(value),
      ],
    );
  }
}
