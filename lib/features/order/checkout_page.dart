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

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.checkout),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: order.lines.length,
              separatorBuilder: (_, _) => const VGap(AppSpacing.sm),
              itemBuilder: (context, index) {
                return _CheckoutLineCard(
                  line: order.lines[index],
                  l10n: l10n,
                );
              },
            ),
          ),
          _CheckoutFooter(
            grandTotal: order.grandTotal,
            confirmLabel: l10n.confirm,
            grandTotalLabel: l10n.grandTotal,
            onConfirm: () => context.pushNamed(AppRoute.payment.name),
          ),
        ],
      ),
    );
  }
}

class _CheckoutLineCard extends StatelessWidget {
  const _CheckoutLineCard({
    required this.line,
    required this.l10n,
  });

  final OrderLineItem line;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final note = line.note.trim().isEmpty ? l10n.noNote : line.note.trim();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(line.title),
          const VGap(AppSpacing.sm),
          _LineDetailRow(label: l10n.quantityLabel, value: '${line.quantity}'),
          const VGap(AppSpacing.xs),
          _LineDetailRow(label: l10n.noteLabel, value: note),
          const VGap(AppSpacing.xs),
          _LineDetailRow(
            label: l10n.unitPrice,
            value: formatRupiah(line.sellPrice),
          ),
          const VGap(AppSpacing.xs),
          _LineDetailRow(
            label: l10n.lineTotal,
            value: formatRupiah(line.lineTotal),
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _LineDetailRow extends StatelessWidget {
  const _LineDetailRow({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppText.body(label, muted: true),
        ),
        Expanded(
          flex: 3,
          child: AppText.body(
            value,
            weight: emphasized ? FontWeight.w600 : null,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter({
    required this.grandTotal,
    required this.grandTotalLabel,
    required this.confirmLabel,
    required this.onConfirm,
  });

  final int grandTotal;
  final String grandTotalLabel;
  final String confirmLabel;
  final VoidCallback onConfirm;

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
              AppButton(confirmLabel, onPressed: onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
