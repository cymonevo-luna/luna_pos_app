import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';

class PurchasePaidDateSheet extends StatefulWidget {
  const PurchasePaidDateSheet({
    super.key,
    required this.initialDate,
  });

  final DateTime initialDate;

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<DateTime>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: PurchasePaidDateSheet(initialDate: initialDate),
          ),
        ),
      );
    }

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: PurchasePaidDateSheet(initialDate: initialDate),
      ),
    );
  }

  @override
  State<PurchasePaidDateSheet> createState() => _PurchasePaidDateSheetState();
}

class _PurchasePaidDateSheetState extends State<PurchasePaidDateSheet> {
  late DateTime _selectedLocal;

  @override
  void initState() {
    super.initState();
    _selectedLocal = widget.initialDate.toLocal();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedLocal,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: AppLocalizations.of(context).purchaseEditPaidDate,
      locale: Localizations.localeOf(context),
    );
    if (!mounted || picked == null) return;

    setState(() {
      _selectedLocal = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedLocal.hour,
        _selectedLocal.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedLocal),
      helpText: AppLocalizations.of(context).purchaseEditPaidDate,
    );
    if (!mounted || picked == null) return;

    setState(() {
      _selectedLocal = DateTime(
        _selectedLocal.year,
        _selectedLocal.month,
        _selectedLocal.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  void _save() {
    Navigator.of(context).pop(_selectedLocal.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();
    final dateLabel = dateFormat.format(_selectedLocal);
    final timeLabel = DateFormat.jm(locale.toString()).format(_selectedLocal);

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(l10n.purchaseEditPaidDate),
          const VGap(AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  key: const Key('purchase_paid_date_picker_date'),
                  contentPadding: EdgeInsets.zero,
                  title: AppText.body(l10n.purchasePaidDate),
                  subtitle: AppText.title(dateLabel),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDate,
                ),
                const Divider(),
                ListTile(
                  key: const Key('purchase_paid_date_picker_time'),
                  contentPadding: EdgeInsets.zero,
                  title: AppText.body(l10n.purchasePaidDateTime),
                  subtitle: AppText.title(timeLabel),
                  trailing: const Icon(Icons.access_time_outlined),
                  onTap: _pickTime,
                ),
              ],
            ),
          ),
          const VGap(AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  l10n.cancel,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const HGap(AppSpacing.sm),
              Expanded(
                child: AppButton(
                  l10n.save,
                  key: const Key('purchase_paid_date_save'),
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
