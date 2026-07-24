import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/router/pos_features.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/user/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/expense_repository.dart';
import 'expense_create_validator.dart';
import 'expense_list_controller.dart';
import 'models/expense.dart';

/// Shared create/edit form for expenses.
class ExpenseFormSheet extends ConsumerStatefulWidget {
  const ExpenseFormSheet({
    super.key,
    this.existing,
    this.onSaved,
  });

  final Expense? existing;
  final VoidCallback? onSaved;

  static Future<bool?> show(
    BuildContext context, {
    Expense? existing,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ExpenseFormSheet(existing: existing),
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
        child: ExpenseFormSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends ConsumerState<ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late ExpenseSourceOfFund _sourceOfFund;
  late DateTime _recordDate;
  late DateTime _initialRecordDate;
  Map<String, String> _fieldErrors = const {};
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  bool get _canEditRecordDate {
    final user = ref.read(authProvider).user;
    return _isEditing && (user?.hasFeature(PosFeatures.recordsEditDate) ?? false);
  }

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
    _sourceOfFund = existing?.sourceOfFund ?? ExpenseSourceOfFund.personalMoney;
    final initialDate = existing?.createdAt?.toLocal() ?? DateTime.now();
    _recordDate = DateTime(initialDate.year, initialDate.month, initialDate.day);
    _initialRecordDate = _recordDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  ExpenseValidationMessages _messages(AppLocalizations l10n) {
    return (
      titleRequired: l10n.fieldRequired,
      titleTooShort: l10n.expenseTitleTooShort,
      amountRequired: l10n.fieldRequired,
      amountInvalid: l10n.expenseAmountInvalid,
    );
  }

  Future<void> _pickRecordDate() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _recordDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: l10n.expenseReportingDateLabel,
      locale: locale,
    );
    if (!mounted || picked == null) return;
    setState(() => _recordDate = picked);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final validation = validateExpenseCreate(
      title: _titleController.text,
      amountText: _amountController.text,
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

    final request = ExpenseRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: parseIdrAmount(_amountController.text),
      sourceOfFund: _sourceOfFund,
    );

    final recordDateChanged =
        _canEditRecordDate && !isSameReportingDate(_recordDate, _initialRecordDate);

    try {
      if (_isEditing) {
        await ref.read(expenseListProvider.notifier).updateExpense(
              widget.existing!.id,
              request,
              recordDate: _recordDate,
              recordDateChanged: recordDateChanged,
            );
      } else {
        await ref.read(expenseListProvider.notifier).createExpense(request);
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
      if (recordDateChanged && fieldErrors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseSaveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _isEditing ? l10n.editExpense : l10n.createExpense;
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString());

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
              fieldKey: const Key('expense_title_field'),
              label: l10n.stockTitleLabel,
              controller: _titleController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['title'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                if (trimmed.length < 2) return l10n.expenseTitleTooShort;
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('expense_description_field'),
              label: l10n.stockDescriptionLabel,
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              validator: (value) => _fieldErrors['description'],
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('expense_amount_field'),
              label: l10n.expenseAmountLabel,
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
                if (parsed <= 0) return l10n.expenseAmountInvalid;
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppText.label(l10n.expenseSourceOfFundLabel),
            const VGap(AppSpacing.xs),
            DropdownButtonFormField<ExpenseSourceOfFund>(
              key: const Key('expense_source_of_fund_field'),
              initialValue: _sourceOfFund,
              decoration: const InputDecoration(),
              items: [
                DropdownMenuItem(
                  value: ExpenseSourceOfFund.personalMoney,
                  child: Text(l10n.expenseSourcePersonalMoney),
                ),
                DropdownMenuItem(
                  value: ExpenseSourceOfFund.cashier,
                  child: Text(l10n.expenseSourceCashier),
                ),
              ],
              onChanged: _submitting
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() => _sourceOfFund = value);
                    },
            ),
            if (_canEditRecordDate) ...[
              const VGap(AppSpacing.md),
              AppText.label(l10n.expenseReportingDateLabel),
              const VGap(AppSpacing.xs),
              ListTile(
                key: const Key('expense_reporting_date_field'),
                contentPadding: EdgeInsets.zero,
                title: Text(dateFormat.format(_recordDate)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _submitting ? null : _pickRecordDate,
              ),
            ],
            const VGap(AppSpacing.xl),
            AppButton(
              l10n.save,
              key: const Key('expense_submit_button'),
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Routed full-screen wrapper for create/edit flows.
class ExpenseFormPage extends ConsumerWidget {
  const ExpenseFormPage({super.key, this.existing});

  final Expense? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          existing == null
              ? AppLocalizations.of(context).createExpense
              : AppLocalizations.of(context).editExpense,
        ),
      ),
      body: ExpenseFormSheet(
        existing: existing,
        onSaved: () => Navigator.of(context).pop(true),
      ),
    );
  }
}

/// Loads an expense by [id] for the edit route.
class ExpenseEditPage extends ConsumerStatefulWidget {
  const ExpenseEditPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ExpenseEditPage> createState() => _ExpenseEditPageState();
}

class _ExpenseEditPageState extends ConsumerState<ExpenseEditPage> {
  Expense? _expense;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final expense =
          await locator<ExpenseRepository>().fetchExpense(widget.id);
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
        _error = 'Failed to load expense';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editExpense)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _expense == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editExpense)),
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

    return ExpenseFormPage(existing: _expense);
  }
}
