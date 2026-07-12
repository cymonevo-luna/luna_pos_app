import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'checkout_controller.dart';
import 'models/order_line_item.dart';
import 'models/payment_method.dart';
import 'order_controller.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _discountController = TextEditingController(text: '0');
  final _cashController = TextEditingController();
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _discountController.dispose();
    _cashController.dispose();
    super.dispose();
  }

  int get _discountAmount => parseIdrAmount(_discountController.text);
  int get _cashTendered => parseIdrAmount(_cashController.text);
  bool get _isCashPayment => _paymentMethod == PaymentMethod.cash;

  String _paymentMethodLabel(AppLocalizations l10n, PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => l10n.paymentMethodCash,
      PaymentMethod.qris => l10n.paymentMethodQris,
    };
  }

  Future<void> _confirmAndPrint(AppLocalizations l10n) async {
    final result = await ref.read(checkoutProvider.notifier).confirmAndPrint(
          discountAmount: _discountAmount,
          paymentMethod: _paymentMethod,
          cashTendered: _isCashPayment ? _cashTendered : null,
        );

    if (!mounted || result == null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(dialogL10n.saleComplete),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dialogL10n.transactionIdLabel(result.transactionId)),
              const VGap(AppSpacing.sm),
              Text(
                result.paymentMethod == PaymentMethod.cash
                    ? dialogL10n.saleCompleteMessage(
                        formatRupiah(result.changeAmount),
                      )
                    : dialogL10n.saleCompleteQrisMessage,
              ),
              if (!result.printSucceeded) ...[
                const VGap(AppSpacing.sm),
                Text(
                  result.printError ?? dialogL10n.printFailedWarning,
                  style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
                ),
              ],
            ],
          ),
          actions: [
            if (!result.printSucceeded)
              TextButton(
                onPressed: () async {
                  final printed =
                      await ref.read(checkoutProvider.notifier).retryPrint();
                  if (!dialogContext.mounted) return;
                  if (printed) {
                    Navigator.of(dialogContext).pop();
                  } else {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text(dialogL10n.printFailedWarning)),
                    );
                  }
                },
                child: Text(dialogL10n.printAgain),
              ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dialogL10n.ok),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    context.goNamed(AppRoute.home.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider);
    final checkout = ref.watch(checkoutProvider);
    final subtotalAmount = order.grandTotal;
    final discountValid = isDiscountValid(
      discountAmount: _discountAmount,
      subtotalAmount: subtotalAmount,
    );
    final totalAmount = calculateCheckoutTotal(
      subtotalAmount: subtotalAmount,
      discountAmount: _discountAmount,
    );
    final sufficient = !_isCashPayment ||
        isPaymentSufficient(
          cashReceived: _cashTendered,
          grandTotal: totalAmount,
        );
    final changeAmount = calculatePaymentChange(
      cashReceived: _cashTendered,
      grandTotal: totalAmount,
    );
    final canConfirm = order.lines.isNotEmpty &&
        discountValid &&
        sufficient &&
        !checkout.submitting;

    ref.listen(checkoutProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.checkout),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                ...order.lines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CheckoutLineCard(line: line, l10n: l10n),
                  ),
                ),
                const VGap(AppSpacing.md),
                _SummaryRow(
                  label: l10n.subtotal,
                  value: formatRupiah(subtotalAmount),
                ),
                const VGap(AppSpacing.md),
                AppTextField(
                  fieldKey: const Key('discount_field'),
                  label: l10n.discount,
                  hint: '0',
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [IdrWholeNumberInputFormatter()],
                  onChanged: (_) => setState(() {}),
                ),
                if (_discountAmount > 0 && !discountValid) ...[
                  const VGap(AppSpacing.xs),
                  AppText.body(
                    l10n.invalidDiscount,
                    color: context.colors.error,
                  ),
                ],
                const VGap(AppSpacing.md),
                _SummaryRow(
                  label: l10n.total,
                  value: formatRupiah(totalAmount),
                  emphasized: true,
                ),
                if (_isCashPayment) ...[
                  const VGap(AppSpacing.lg),
                  AppTextField(
                    fieldKey: const Key('cash_tendered_field'),
                    label: l10n.cashReceived,
                    hint: '0',
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [IdrWholeNumberInputFormatter()],
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_cashTendered > 0) ...[
                    const VGap(AppSpacing.sm),
                    AppText.body(
                      formatRupiah(_cashTendered),
                      muted: true,
                      align: TextAlign.end,
                    ),
                  ],
                  const VGap(AppSpacing.md),
                  if (_cashTendered > 0 && !sufficient)
                    AppText.body(
                      l10n.insufficientPayment,
                      color: context.colors.error,
                      align: TextAlign.center,
                    )
                  else if (_cashTendered >= totalAmount)
                    _SummaryRow(
                      label: l10n.change,
                      value: formatRupiah(changeAmount),
                      emphasized: true,
                    ),
                ],
              ],
            ),
          ),
          Material(
            elevation: 8,
            color: context.colors.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.paymentMethod,
                        border: const OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PaymentMethod>(
                          key: const Key('payment_method_dropdown'),
                          isExpanded: true,
                          value: _paymentMethod,
                          items: PaymentMethod.values
                              .map(
                                (method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(_paymentMethodLabel(l10n, method)),
                                ),
                              )
                              .toList(),
                          onChanged: (method) {
                            if (method == null) return;
                            setState(() => _paymentMethod = method);
                          },
                        ),
                      ),
                    ),
                    const VGap(AppSpacing.md),
                    AppButton(
                      l10n.confirmAndPrint,
                      loading: checkout.submitting,
                      onPressed: canConfirm ? () => _confirmAndPrint(l10n) : null,
                    ),
                  ],
                ),
              ),
            ),
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
          child: AppText.title(
            label,
            weight: emphasized ? FontWeight.w700 : null,
          ),
        ),
        AppText.title(
          value,
          color: emphasized ? context.colors.primary : null,
          weight: emphasized ? FontWeight.w700 : null,
        ),
      ],
    );
  }
}
