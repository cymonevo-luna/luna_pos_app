import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'cashier_balance_controller.dart';
import 'models/cashier_balance.dart';

class CashierBalanceAdjustSheet extends ConsumerStatefulWidget {
  const CashierBalanceAdjustSheet({
    super.key,
    required this.type,
  });

  final CashierBalanceAdjustmentType type;

  static Future<bool?> show(
    BuildContext context, {
    required CashierBalanceAdjustmentType type,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: CashierBalanceAdjustSheet(type: type),
          ),
        ),
      );
    }

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: CashierBalanceAdjustSheet(type: type),
      ),
    );
  }

  @override
  ConsumerState<CashierBalanceAdjustSheet> createState() =>
      _CashierBalanceAdjustSheetState();
}

class _CashierBalanceAdjustSheetState
    extends ConsumerState<CashierBalanceAdjustSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  String _title(AppLocalizations l10n) => switch (widget.type) {
        CashierBalanceAdjustmentType.add => l10n.cashierBalanceAdd,
        CashierBalanceAdjustmentType.deduct => l10n.cashierBalanceDeduct,
      };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = parseIdrAmount(_amountController.text);
    final purpose = _purposeController.text.trim();
    if (amount <= 0 || purpose.isEmpty) return;

    setState(() => _submitting = true);
    final l10n = AppLocalizations.of(context);

    try {
      await ref.read(cashierBalanceController.notifier).adjustBalance(
            CashierBalanceAdjustmentRequest(
              amount: amount,
              purpose: purpose,
              type: widget.type,
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cashierBalanceAdjustSuccess)),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationMessageFor(error) ?? error.message),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cashierBalanceAdjustFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.title(_title(l10n)),
            const VGap(AppSpacing.lg),
            TextFormField(
              key: const Key('cashier_balance_adjust_amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [IdrWholeNumberInputFormatter()],
              decoration: InputDecoration(
                labelText: l10n.cashierBalanceAmountLabel,
              ),
              validator: (value) {
                final amount = parseIdrAmount(value ?? '');
                if (amount <= 0) {
                  return l10n.cashierBalanceAmountInvalid;
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            TextFormField(
              key: const Key('cashier_balance_adjust_purpose'),
              controller: _purposeController,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.cashierBalancePurposeLabel,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fieldRequired;
                }
                return null;
              },
            ),
            const VGap(AppSpacing.lg),
            AppButton(
              l10n.save,
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
            const VGap(AppSpacing.sm),
            TextButton(
              onPressed: _submitting ? null : () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
