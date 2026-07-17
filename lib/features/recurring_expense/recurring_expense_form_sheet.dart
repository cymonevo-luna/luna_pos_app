import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/recurring_expense_repository.dart';
import 'models/recurring_expense.dart';
import 'recurring_expense_create_validator.dart';
import 'recurring_expense_list_controller.dart';

/// Shared create/edit form for recurring expenses.
class RecurringExpenseFormSheet extends ConsumerStatefulWidget {
  const RecurringExpenseFormSheet({
    super.key,
    this.existing,
    this.onSaved,
  });

  final RecurringExpense? existing;
  final VoidCallback? onSaved;

  static Future<bool?> show(
    BuildContext context, {
    RecurringExpense? existing,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: RecurringExpenseFormSheet(existing: existing),
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
        child: RecurringExpenseFormSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<RecurringExpenseFormSheet> createState() =>
      _RecurringExpenseFormSheetState();
}

class _RecurringExpenseFormSheetState
    extends ConsumerState<RecurringExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _valueController;
  late RecurringInterval _interval;
  late int _hour;
  late int _minute;
  late int _second;
  late bool _isActive;
  Map<String, String> _fieldErrors = const {};
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toString() : '',
    );
    _interval = existing?.recurring.interval ?? RecurringInterval.daily;
    _valueController = TextEditingController(
      text: existing?.recurring.value?.toString() ?? '',
    );
    _hour = existing?.recurring.time.hour ?? 9;
    _minute = existing?.recurring.time.minute ?? 0;
    _second = existing?.recurring.time.second ?? 0;
    _isActive = existing?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  RecurringExpenseValidationMessages _messages(AppLocalizations l10n) {
    return (
      titleRequired: l10n.fieldRequired,
      titleTooShort: l10n.recurringExpenseTitleTooShort,
      amountRequired: l10n.fieldRequired,
      amountInvalid: l10n.recurringExpenseAmountInvalid,
      valueRequired: l10n.fieldRequired,
      dayOfMonthInvalid: l10n.recurringExpenseDayOfMonthInvalid,
      weekdayInvalid: l10n.recurringExpenseWeekdayInvalid,
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final validation = validateRecurringExpenseCreate(
      title: _titleController.text,
      amountText: _amountController.text,
      interval: _interval,
      valueText: _interval == RecurringInterval.daily ? null : _valueController.text,
      messages: _messages(l10n),
    );

    setState(() => _fieldErrors = validation.fieldErrors);

    if (!validation.isValid) {
      _formKey.currentState?.validate();
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _fieldErrors = const {};
    });

    final schedule = RecurringSchedule(
      interval: _interval,
      value: _interval == RecurringInterval.daily
          ? null
          : int.parse(_valueController.text.trim()),
      time: RecurringScheduleTime(
        hour: _hour,
        minute: _minute,
        second: _second,
      ),
    );

    final request = RecurringExpenseRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: parseIdrAmount(_amountController.text),
      recurring: schedule,
      isActive: _isEditing ? _isActive : null,
    );

    try {
      if (_isEditing) {
        await ref
            .read(recurringExpenseListProvider.notifier)
            .updateExpense(widget.existing!.id, request);
      } else {
        await ref
            .read(recurringExpenseListProvider.notifier)
            .createExpense(request);
      }

      if (!mounted) return;
      widget.onSaved?.call();
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      final fieldErrors = parseApiFieldErrors(e.data);
      setState(() {
        _submitting = false;
        _fieldErrors = fieldErrors;
      });
      _formKey.currentState?.validate();
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title =
        _isEditing ? l10n.editRecurringExpense : l10n.createRecurringExpense;
    final showValueField = _interval != RecurringInterval.daily;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.title(title),
            const VGap(AppSpacing.lg),
            AppTextField(
              fieldKey: const Key('recurring_expense_title_field'),
              label: l10n.stockTitleLabel,
              controller: _titleController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['title'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                if (trimmed.length < 2) {
                  return l10n.recurringExpenseTitleTooShort;
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('recurring_expense_description_field'),
              label: l10n.stockDescriptionLabel,
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              validator: (value) => _fieldErrors['description'],
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('recurring_expense_amount_field'),
              label: l10n.recurringExpenseAmountLabel,
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [IdrWholeNumberInputFormatter()],
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['amount'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                final parsed = parseIdrAmount(trimmed);
                if (parsed <= 0) return l10n.recurringExpenseAmountInvalid;
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppText.label(l10n.recurringExpenseIntervalLabel),
            const VGap(AppSpacing.xs),
            DropdownButtonFormField<RecurringInterval>(
              key: const Key('recurring_expense_interval_field'),
              initialValue: _interval,
              decoration: const InputDecoration(),
              items: [
                DropdownMenuItem(
                  value: RecurringInterval.daily,
                  child: Text(l10n.intervalDaily),
                ),
                DropdownMenuItem(
                  value: RecurringInterval.day,
                  child: Text(l10n.intervalDay),
                ),
                DropdownMenuItem(
                  value: RecurringInterval.date,
                  child: Text(l10n.intervalDate),
                ),
              ],
              onChanged: _submitting
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() {
                        _interval = value;
                        if (value == RecurringInterval.daily) {
                          _valueController.clear();
                        }
                      });
                    },
            ),
            if (showValueField) ...[
              const VGap(AppSpacing.md),
              if (_interval == RecurringInterval.date)
                AppTextField(
                  key: const Key('recurring_expense_day_of_month_field'),
                  label: l10n.dayOfMonth,
                  controller: _valueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final apiError = _fieldErrors['value'];
                    if (apiError != null) return apiError;
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return l10n.fieldRequired;
                    final parsed = int.tryParse(trimmed);
                    if (parsed == null || parsed < 1 || parsed > 31) {
                      return l10n.recurringExpenseDayOfMonthInvalid;
                    }
                    return null;
                  },
                )
              else
                DropdownButtonFormField<int>(
                  key: const Key('recurring_expense_weekday_field'),
                  initialValue: int.tryParse(_valueController.text) ?? 1,
                  decoration: InputDecoration(labelText: l10n.weekday),
                  items: [
                    for (var day = 1; day <= 7; day++)
                      DropdownMenuItem(
                        value: day,
                        child: Text(_weekdayLabel(l10n, day)),
                      ),
                  ],
                  onChanged: _submitting
                      ? null
                      : (value) {
                          if (value == null) return;
                          setState(() => _valueController.text = value.toString());
                        },
                  validator: (_) => _fieldErrors['value'],
                ),
            ],
            const VGap(AppSpacing.md),
            AppText.label(l10n.recurringExpenseTimeLabel),
            const VGap(AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _TimeDropdown(
                    key: const Key('recurring_expense_hour_field'),
                    label: l10n.hourLabel,
                    value: _hour,
                    max: 23,
                    onChanged: _submitting
                        ? null
                        : (value) => setState(() => _hour = value),
                  ),
                ),
                const HGap(AppSpacing.sm),
                Expanded(
                  child: _TimeDropdown(
                    key: const Key('recurring_expense_minute_field'),
                    label: l10n.minuteLabel,
                    value: _minute,
                    max: 59,
                    onChanged: _submitting
                        ? null
                        : (value) => setState(() => _minute = value),
                  ),
                ),
                const HGap(AppSpacing.sm),
                Expanded(
                  child: _TimeDropdown(
                    key: const Key('recurring_expense_second_field'),
                    label: l10n.secondLabel,
                    value: _second,
                    max: 59,
                    onChanged: _submitting
                        ? null
                        : (value) => setState(() => _second = value),
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              const VGap(AppSpacing.md),
              SwitchListTile(
                key: const Key('recurring_expense_active_switch'),
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.active),
                subtitle: Text(_isActive ? l10n.active : l10n.inactive),
                value: _isActive,
                onChanged: _submitting
                    ? null
                    : (value) => setState(() => _isActive = value),
              ),
            ],
            const VGap(AppSpacing.xl),
            AppButton(
              l10n.save,
              key: const Key('recurring_expense_submit_button'),
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(AppLocalizations l10n, int value) => switch (value) {
        1 => l10n.weekdayMonday,
        2 => l10n.weekdayTuesday,
        3 => l10n.weekdayWednesday,
        4 => l10n.weekdayThursday,
        5 => l10n.weekdayFriday,
        6 => l10n.weekdaySaturday,
        7 => l10n.weekdaySunday,
        _ => value.toString(),
      };
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      items: [
        for (var i = 0; i <= max; i++)
          DropdownMenuItem(value: i, child: Text(i.toString().padLeft(2, '0'))),
      ],
      onChanged: onChanged == null ? null : (v) => onChanged!(v ?? value),
    );
  }
}

/// Routed full-screen wrapper for create/edit flows.
class RecurringExpenseFormPage extends ConsumerWidget {
  const RecurringExpenseFormPage({super.key, this.existing});

  final RecurringExpense? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          existing == null
              ? AppLocalizations.of(context).createRecurringExpense
              : AppLocalizations.of(context).editRecurringExpense,
        ),
      ),
      body: RecurringExpenseFormSheet(
        existing: existing,
        onSaved: () => Navigator.of(context).pop(true),
      ),
    );
  }
}

/// Loads a recurring expense by [id] for the edit route.
class RecurringExpenseEditPage extends ConsumerStatefulWidget {
  const RecurringExpenseEditPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<RecurringExpenseEditPage> createState() =>
      _RecurringExpenseEditPageState();
}

class _RecurringExpenseEditPageState
    extends ConsumerState<RecurringExpenseEditPage> {
  RecurringExpense? _expense;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final expense = await locator<RecurringExpenseRepository>()
          .fetchRecurringExpense(widget.id);
      if (!mounted) return;
      setState(() {
        _expense = expense;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load recurring expense';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editRecurringExpense)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _expense == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editRecurringExpense)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.body(_error ?? 'Not found', align: TextAlign.center),
                const VGap(AppSpacing.lg),
                AppButton(l10n.retry, onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _load();
                }),
              ],
            ),
          ),
        ),
      );
    }

    return RecurringExpenseFormPage(existing: _expense);
  }
}
