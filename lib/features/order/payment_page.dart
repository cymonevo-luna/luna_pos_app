import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import '../transaction/payment_controller.dart';
import 'order_controller.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _cashController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  Future<void> _completePayment(AppLocalizations l10n) async {
    final cashReceived = parseIdrAmount(_cashController.text);
    final changeAmount = await ref
        .read(paymentProvider.notifier)
        .completeOfflineSale(cashReceived: cashReceived);

    if (!mounted || changeAmount == null) return;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grandTotal = ref.watch(orderProvider.select((order) => order.grandTotal));
    final payment = ref.watch(paymentProvider);
    final cashReceived = parseIdrAmount(_cashController.text);
    final sufficient = isPaymentSufficient(
      cashReceived: cashReceived,
      grandTotal: grandTotal,
    );
    final change = calculatePaymentChange(
      cashReceived: cashReceived,
      grandTotal: grandTotal,
    );

    ref.listen(paymentProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.payment),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText.label(l10n.amountDue, muted: true),
                  const VGap(AppSpacing.xs),
                  AppText.display(
                    formatRupiah(grandTotal),
                    color: context.colors.primary,
                    weight: FontWeight.w700,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
            const VGap(AppSpacing.lg),
            AppTextField(
              key: const Key('cash_tendered_field'),
              label: l10n.cashReceived,
              hint: '0',
              controller: _cashController,
              keyboardType: TextInputType.number,
              inputFormatters: [IdrWholeNumberInputFormatter()],
              onChanged: (_) => setState(() {}),
            ),
            if (cashReceived > 0) ...[
              const VGap(AppSpacing.sm),
              AppText.body(
                formatRupiah(cashReceived),
                muted: true,
                align: TextAlign.end,
              ),
            ],
            const VGap(AppSpacing.lg),
            if (cashReceived > 0 && !sufficient)
              AppText.body(
                l10n.insufficientPayment,
                color: context.colors.error,
                align: TextAlign.center,
              )
            else if (cashReceived >= grandTotal)
              _ChangeSummary(
                label: l10n.change,
                amount: formatRupiah(change),
              ),
            const Spacer(),
            AppButton(
              l10n.complete,
              loading: payment.submitting,
              onPressed: sufficient && !payment.submitting
                  ? () => _completePayment(l10n)
                  : null,
            ),
            const VGap(AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _ChangeSummary extends StatelessWidget {
  const _ChangeSummary({
    required this.label,
    required this.amount,
  });

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      child: Row(
        children: [
          Expanded(child: AppText.title(label)),
          AppText.title(amount, weight: FontWeight.w700),
        ],
      ),
    );
  }
}
