import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
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

  void _completePayment(AppLocalizations l10n) {
    final messenger = ScaffoldMessenger.of(context);
    ref.read(orderProvider.notifier).clear();
    context.goNamed(AppRoute.home.name);
    messenger.showSnackBar(SnackBar(content: Text(l10n.paymentSuccess)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grandTotal = ref.watch(orderProvider.select((order) => order.grandTotal));
    final cashReceived = parseIdrAmount(_cashController.text);
    final sufficient = isPaymentSufficient(
      cashReceived: cashReceived,
      grandTotal: grandTotal,
    );
    final change = calculatePaymentChange(
      cashReceived: cashReceived,
      grandTotal: grandTotal,
    );

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
              onPressed: sufficient ? () => _completePayment(l10n) : null,
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
