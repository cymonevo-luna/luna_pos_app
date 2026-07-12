import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/food_supply_repository.dart';
import 'models/food_supply.dart';
import 'stock_controller.dart';

/// Shared create/edit form for food supplies.
class StockFormSheet extends ConsumerStatefulWidget {
  const StockFormSheet({
    super.key,
    this.existing,
    this.onSaved,
  });

  final FoodSupply? existing;
  final VoidCallback? onSaved;

  static Future<bool?> show(
    BuildContext context, {
    FoodSupply? existing,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: StockFormSheet(existing: existing),
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
        child: StockFormSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<StockFormSheet> createState() => _StockFormSheetState();
}

class _StockFormSheetState extends ConsumerState<StockFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late String _unit;
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
    _quantityController = TextEditingController(
      text: existing != null ? existing.stockQuantity.toString() : '',
    );
    _unit = existing?.unit ?? 'gr';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _fieldErrors = const {};
    });

    final request = FoodSupplyRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      stockQuantity: num.parse(_quantityController.text.trim()),
      unit: _unit,
    );

    try {
      if (_isEditing) {
        await ref
            .read(stockProvider.notifier)
            .updateSupply(widget.existing!.id, request);
      } else {
        await ref.read(stockProvider.notifier).createSupply(request);
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
    final title = _isEditing ? l10n.stockEdit : l10n.stockNew;

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
              fieldKey: const Key('stock_title_field'),
              label: l10n.stockTitleLabel,
              controller: _titleController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['title'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                if (trimmed.length < 2) return l10n.stockTitleTooShort;
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('stock_description_field'),
              label: l10n.stockDescriptionLabel,
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              validator: (value) => _fieldErrors['description'],
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('stock_quantity_field'),
              label: l10n.stockQuantityLabel,
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textInputAction: TextInputAction.done,
              validator: (value) {
                final apiError = _fieldErrors['stock_quantity'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                final parsed = num.tryParse(trimmed);
                if (parsed == null || parsed < 0) {
                  return l10n.stockQuantityInvalid;
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppText.label(l10n.stockUnitLabel),
            const VGap(AppSpacing.xs),
            DropdownButtonFormField<String>(
              key: const Key('stock_unit_field'),
              initialValue: _unit,
              decoration: const InputDecoration(),
              items: const [
                DropdownMenuItem(value: 'gr', child: Text('Grams (gr)')),
                DropdownMenuItem(value: 'ml', child: Text('Milliliters (ml)')),
                DropdownMenuItem(value: 'piece', child: Text('Pieces')),
              ],
              onChanged: _submitting
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() => _unit = value);
                    },
            ),
            if (_fieldErrors['unit'] != null) ...[
              const VGap(AppSpacing.xs),
              AppText.body(_fieldErrors['unit']!, color: context.colors.error),
            ],
            const VGap(AppSpacing.xl),
            AppButton(
              l10n.save,
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
class StockFormPage extends ConsumerWidget {
  const StockFormPage({super.key, this.existing});

  final FoodSupply? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          existing == null
              ? AppLocalizations.of(context).stockNew
              : AppLocalizations.of(context).stockEdit,
        ),
      ),
      body: StockFormSheet(
        existing: existing,
        onSaved: () => Navigator.of(context).pop(true),
      ),
    );
  }
}

/// Loads a supply by [id] for the edit route.
class StockEditPage extends ConsumerStatefulWidget {
  const StockEditPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<StockEditPage> createState() => _StockEditPageState();
}

class _StockEditPageState extends ConsumerState<StockEditPage> {
  FoodSupply? _supply;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final supply =
          await locator<FoodSupplyRepository>().fetchFoodSupply(widget.id);
      if (!mounted) return;
      setState(() {
        _supply = supply;
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
        _error = 'Failed to load supply';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.stockEdit)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _supply == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.stockEdit)),
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

    return StockFormPage(existing: _supply);
  }
}
