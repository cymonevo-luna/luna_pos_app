import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/units.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/purchase_request_repository.dart';
import 'data/supplier_repository.dart';
import 'models/supplier.dart';
import 'purchase_create_validator.dart';
import 'purchase_request_estimator.dart';

class PurchaseLineDraft {
  PurchaseLineDraft({
    required this.quote,
    this.quantity = 1,
    this.lineActualAmount,
    this.updateCatalogPrice = false,
    int? catalogPriceAmount,
    num? catalogPriceQuantity,
  })  : catalogPriceAmount = catalogPriceAmount ?? quote.priceAmount,
        catalogPriceQuantity = catalogPriceQuantity ?? quote.priceQuantity;

  final PriceQuote quote;
  num quantity;
  int? lineActualAmount;
  bool updateCatalogPrice;
  int catalogPriceAmount;
  num catalogPriceQuantity;
}

class PurchaseCreatePage extends ConsumerStatefulWidget {
  const PurchaseCreatePage({super.key});

  @override
  ConsumerState<PurchaseCreatePage> createState() => _PurchaseCreatePageState();
}

class _PurchaseCreatePageState extends ConsumerState<PurchaseCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  SupplierSummary? _selectedSupplier;
  Supplier? _supplierDetail;
  final List<PurchaseLineDraft> _lines = [];
  bool _loadingSupplier = false;
  bool _submitting = false;
  String? _formError;
  Map<String, String> _fieldErrors = const {};

  SupplierRepository get _supplierRepository => locator<SupplierRepository>();
  PurchaseRequestRepository get _purchaseRepository =>
      locator<PurchaseRequestRepository>();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  PurchaseCreateValidationMessages _validationMessages(AppLocalizations l10n) =>
      (
        supplierRequired: l10n.purchaseSupplierRequired,
        atLeastOneItem: l10n.purchaseAtLeastOneItem,
        duplicateItem: l10n.purchaseDuplicateItemError,
        quantityRequired: l10n.purchaseQuantityRequired,
        actualPriceRequired: l10n.purchaseActualPriceRequired,
        catalogPriceAmountRequired: l10n.purchaseCatalogPriceAmountRequired,
        catalogPriceQuantityRequired: l10n.purchaseCatalogPriceQuantityRequired,
      );

  int get _estimatedGrandTotal => estimateGrandTotal(
        _lines.map((line) => (quote: line.quote, quantity: line.quantity)),
      );

  int get _actualGrandTotal => resolvedGrandTotal(
        _lines.map(
          (line) => (
            quote: line.quote,
            quantity: line.quantity,
            lineActualAmount: line.lineActualAmount,
          ),
        ),
      );

  bool get _showActualTotal => hasAnyActualAmount(
        _lines.map((line) => (lineActualAmount: line.lineActualAmount)),
      );

  Future<void> _selectSupplier() async {
    final selected = await SupplierPickerSheet.show(context);
    if (selected == null || !mounted) return;

    setState(() {
      _selectedSupplier = selected;
      _supplierDetail = null;
      _lines.clear();
      _loadingSupplier = true;
      _formError = null;
      _fieldErrors = const {};
    });

    try {
      final detail = await _supplierRepository.get(selected.id);
      if (!mounted) return;
      setState(() {
        _supplierDetail = detail;
        _loadingSupplier = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSupplier = false);
    }
  }

  Future<void> _addLineItem() async {
    final catalog = _supplierDetail?.priceQuotes ?? const <PriceQuote>[];
    if (catalog.isEmpty) return;

    final quote = await CatalogItemPickerSheet.show(
      context,
      quotes: catalog,
    );
    if (quote == null || !mounted) return;

    setState(() {
      _lines.add(PurchaseLineDraft(quote: quote));
      _formError = null;
      _fieldErrors = const {};
    });
  }

  void _removeLine(int index) {
    setState(() {
      _lines.removeAt(index);
      _fieldErrors = const {};
      _formError = null;
    });
  }

  void _updateQuantity(int index, num quantity) {
    setState(() {
      _lines[index].quantity = quantity;
      _fieldErrors = const {};
    });
  }

  void _updateLineActualAmount(int index, int? amount) {
    setState(() {
      _lines[index].lineActualAmount = amount;
      _fieldErrors = const {};
    });
  }

  void _updateCatalogPriceEnabled(int index, bool enabled) {
    setState(() {
      final line = _lines[index];
      line.updateCatalogPrice = enabled;
      if (enabled) {
        line.catalogPriceAmount = line.quote.priceAmount;
        line.catalogPriceQuantity = line.quote.priceQuantity;
      }
      _fieldErrors = const {};
    });
  }

  void _updateCatalogPriceAmount(int index, int amount) {
    setState(() {
      _lines[index].catalogPriceAmount = amount;
      _fieldErrors = const {};
    });
  }

  void _updateCatalogPriceQuantity(int index, num quantity) {
    setState(() {
      _lines[index].catalogPriceQuantity = quantity;
      _fieldErrors = const {};
    });
  }

  bool _validateForm(AppLocalizations l10n) {
    final result = validatePurchaseCreate(
      supplierId: _selectedSupplier?.id,
      items: _lines
          .map(
            (line) => PurchaseLineInput(
              foodSupplyId: line.quote.foodSupplyId,
              quantity: line.quantity,
              lineActualAmount: line.lineActualAmount,
              updateCatalogPrice: line.updateCatalogPrice,
              catalogPriceAmount:
                  line.updateCatalogPrice ? line.catalogPriceAmount : null,
              catalogPriceQuantity:
                  line.updateCatalogPrice ? line.catalogPriceQuantity : null,
            ),
          )
          .toList(),
      messages: _validationMessages(l10n),
    );

    setState(() {
      _fieldErrors = result.fieldErrors;
      _formError = result.formError;
    });

    return result.isValid && _formKey.currentState!.validate();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_validateForm(l10n)) return;

    setState(() {
      _submitting = true;
      _fieldErrors = const {};
      _formError = null;
    });

    try {
      final created = await _purchaseRepository.create(
        supplierId: _selectedSupplier!.id,
        items: _lines
            .map(
              (line) => PurchaseLineCreateInput(
                foodSupplyId: line.quote.foodSupplyId,
                quantity: line.quantity,
                lineActualAmount: line.lineActualAmount,
                supplierPriceUpdate: line.updateCatalogPrice
                    ? SupplierPriceUpdateInput(
                        priceAmount: line.catalogPriceAmount,
                        priceQuantity: line.catalogPriceQuantity,
                      )
                    : null,
              ),
            )
            .toList(),
        notes: _notesController.text,
      );

      if (!mounted) return;
      context.goNamed(
        AppRoute.purchaseDetail.name,
        pathParameters: {'id': created.id},
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      final fieldErrors = parseApiFieldErrors(e.data);
      setState(() {
        _submitting = false;
        _fieldErrors = fieldErrors;
        _formError = validationMessageFor(e);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = _supplierDetail?.priceQuotes ?? const <PriceQuote>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.purchasesNew),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.label(l10n.purchaseSupplierLabel),
                    const VGap(AppSpacing.xs),
                    _SupplierSelectorTile(
                      key: const Key('purchase_supplier_selector'),
                      supplierName: _selectedSupplier?.name,
                      placeholder: l10n.purchaseSelectSupplier,
                      loading: _loadingSupplier,
                      onTap: _selectSupplier,
                    ),
                    if (_formError != null &&
                        _fieldErrors.isEmpty &&
                        _selectedSupplier == null) ...[
                      const VGap(AppSpacing.xs),
                      Text(
                        _formError!,
                        style: TextStyle(color: context.colors.error),
                      ),
                    ],
                    const VGap(AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(child: AppText.title(l10n.purchaseLineItems)),
                        TextButton.icon(
                          key: const Key('purchase_add_item_button'),
                          onPressed: _selectedSupplier == null ||
                                  _loadingSupplier ||
                                  catalog.isEmpty
                              ? null
                              : _addLineItem,
                          icon: const Icon(Icons.add),
                          label: Text(l10n.purchaseAddItem),
                        ),
                      ],
                    ),
                    if (_selectedSupplier != null &&
                        !_loadingSupplier &&
                        catalog.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: AppText.body(l10n.purchaseEmptyCatalog, muted: true),
                      ),
                    if (_fieldErrors['items'] != null) ...[
                      const VGap(AppSpacing.xs),
                      Text(
                        _fieldErrors['items']!,
                        key: const Key('purchase_duplicate_error'),
                        style: TextStyle(color: context.colors.error),
                      ),
                    ],
                    ...List.generate(_lines.length, (index) {
                      final line = _lines[index];
                      final lineTotal = estimateLineTotalForQuote(
                        quantity: line.quantity,
                        quote: line.quote,
                      );
                      final fieldKey = 'items[$index].food_supply_id';
                      final itemError = _fieldErrors[fieldKey] ??
                          _fieldErrors['items[$index].quantity'] ??
                          _fieldErrors['items[$index].line_actual_amount'] ??
                          _fieldErrors[
                              'items[$index].supplier_price_update.price_amount'] ??
                          _fieldErrors[
                              'items[$index].supplier_price_update.price_quantity'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.title(
                                          line.quote.foodSupplyTitle,
                                        ),
                                        const VGap(AppSpacing.xxs),
                                        AppText.body(
                                          '${formatMeasurementQuantity(1, line.quote.unit)} · ${formatRupiah(line.quote.priceAmount)} / ${formatMeasurementQuantity(line.quote.priceQuantity, line.quote.unit)}',
                                          muted: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeLine(index),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              const VGap(AppSpacing.sm),
                              AppText.label(l10n.quantityLabel),
                              const VGap(AppSpacing.xs),
                              _DecimalQuantityStepper(
                                key: Key(
                                  'purchase_line_item_${line.quote.foodSupplyId}_quantity',
                                ),
                                quantity: line.quantity,
                                onChanged: (value) =>
                                    _updateQuantity(index, value),
                              ),
                              const VGap(AppSpacing.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.body(l10n.purchaseLineTotal, muted: true),
                                  AppText.title(formatRupiah(lineTotal)),
                                ],
                              ),
                              const VGap(AppSpacing.sm),
                              AppTextField(
                                fieldKey: Key(
                                  'purchase_line_item_${line.quote.foodSupplyId}_actual_price',
                                ),
                                label: l10n.purchaseActualPriceLabel,
                                hint: l10n.purchaseActualPriceLabel,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  final trimmed = value.trim();
                                  _updateLineActualAmount(
                                    index,
                                    trimmed.isEmpty ? null : int.tryParse(trimmed),
                                  );
                                },
                              ),
                              const VGap(AppSpacing.sm),
                              SwitchListTile.adaptive(
                                key: Key(
                                  'purchase_line_item_${line.quote.foodSupplyId}_update_catalog',
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: AppText.body(
                                  l10n.purchaseUpdateCatalogPrice,
                                ),
                                value: line.updateCatalogPrice,
                                onChanged: (value) =>
                                    _updateCatalogPriceEnabled(index, value),
                              ),
                              if (line.updateCatalogPrice) ...[
                                const VGap(AppSpacing.sm),
                                _CatalogPriceUpdateFields(
                                  foodSupplyId: line.quote.foodSupplyId,
                                  initialPriceAmount: line.catalogPriceAmount,
                                  initialPriceQuantity: line.catalogPriceQuantity,
                                  onPriceAmountChanged: (value) =>
                                      _updateCatalogPriceAmount(index, value),
                                  onPriceQuantityChanged: (value) =>
                                      _updateCatalogPriceQuantity(index, value),
                                ),
                              ],
                              if (itemError != null) ...[
                                const VGap(AppSpacing.xs),
                                Text(
                                  itemError,
                                  style:
                                      TextStyle(color: context.colors.error),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    const VGap(AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('purchase_notes_field'),
                      label: l10n.noteLabel,
                      hint: l10n.purchaseNotesHint,
                      controller: _notesController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2000),
                      ],
                    ),
                    if (_formError != null &&
                        (_fieldErrors.isNotEmpty ||
                            _selectedSupplier != null)) ...[
                      const VGap(AppSpacing.sm),
                      Text(
                        _formError!,
                        style: TextStyle(color: context.colors.error),
                      ),
                    ],
                    const VGap(AppSpacing.xxl),
                  ],
                ),
              ),
            ),
            _PurchaseSummaryFooter(
              estimatedLabel: l10n.purchaseEstimatedTotal,
              estimatedAmount: formatRupiah(_estimatedGrandTotal),
              actualLabel: l10n.purchaseActualTotal,
              actualAmount: formatRupiah(_actualGrandTotal),
              showActualTotal: _showActualTotal,
              submitLabel: l10n.purchaseSubmit,
              submitting: _submitting,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplierSelectorTile extends StatelessWidget {
  const _SupplierSelectorTile({
    super.key,
    required this.supplierName,
    required this.placeholder,
    required this.loading,
    required this.onTap,
  });

  final String? supplierName;
  final String placeholder;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(Icons.store_outlined, color: context.tokens.textSecondary),
              const HGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  supplierName ?? placeholder,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: supplierName == null
                            ? context.tokens.textSecondary
                            : null,
                      ),
                ),
              ),
              if (loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.chevron_right, color: context.tokens.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecimalQuantityStepper extends StatefulWidget {
  const _DecimalQuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final num quantity;
  final ValueChanged<num> onChanged;

  @override
  State<_DecimalQuantityStepper> createState() =>
      _DecimalQuantityStepperState();
}

class _DecimalQuantityStepperState extends State<_DecimalQuantityStepper> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.quantity));
  }

  @override
  void didUpdateWidget(covariant _DecimalQuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = _format(widget.quantity);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(num value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toString();
  }

  void _apply(num value) {
    widget.onChanged(value);
    _controller.text = _format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(
          key: const Key('purchase_quantity_decrement'),
          icon: Icons.remove,
          onPressed: widget.quantity > 1
              ? () => _apply(widget.quantity - 1)
              : null,
        ),
        Expanded(
          child: TextFormField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
            ),
            onChanged: (value) {
              final parsed = num.tryParse(value);
              if (parsed != null) {
                widget.onChanged(parsed);
              }
            },
          ),
        ),
        _StepperButton(
          key: const Key('purchase_quantity_increment'),
          icon: Icons.add,
          onPressed: () => _apply(widget.quantity + 1),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _CatalogPriceUpdateFields extends StatefulWidget {
  const _CatalogPriceUpdateFields({
    required this.foodSupplyId,
    required this.initialPriceAmount,
    required this.initialPriceQuantity,
    required this.onPriceAmountChanged,
    required this.onPriceQuantityChanged,
  });

  final String foodSupplyId;
  final int initialPriceAmount;
  final num initialPriceQuantity;
  final ValueChanged<int> onPriceAmountChanged;
  final ValueChanged<num> onPriceQuantityChanged;

  @override
  State<_CatalogPriceUpdateFields> createState() =>
      _CatalogPriceUpdateFieldsState();
}

class _CatalogPriceUpdateFieldsState extends State<_CatalogPriceUpdateFields> {
  late final TextEditingController _amountController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.initialPriceAmount.toString());
    _quantityController =
        TextEditingController(text: widget.initialPriceQuantity.toString());
  }

  @override
  void didUpdateWidget(covariant _CatalogPriceUpdateFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPriceAmount != widget.initialPriceAmount) {
      _amountController.text = widget.initialPriceAmount.toString();
    }
    if (oldWidget.initialPriceQuantity != widget.initialPriceQuantity) {
      _quantityController.text = widget.initialPriceQuantity.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          fieldKey: Key(
            'purchase_line_item_${widget.foodSupplyId}_catalog_price_amount',
          ),
          label: l10n.purchaseCatalogPriceAmount,
          hint: l10n.purchaseCatalogPriceAmount,
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            final parsed = int.tryParse(value.trim());
            if (parsed != null) {
              widget.onPriceAmountChanged(parsed);
            }
          },
        ),
        const VGap(AppSpacing.sm),
        AppTextField(
          fieldKey: Key(
            'purchase_line_item_${widget.foodSupplyId}_catalog_price_quantity',
          ),
          label: l10n.purchaseCatalogPriceQuantity,
          hint: l10n.purchaseCatalogPriceQuantity,
          controller: _quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onChanged: (value) {
            final parsed = num.tryParse(value.trim());
            if (parsed != null) {
              widget.onPriceQuantityChanged(parsed);
            }
          },
        ),
      ],
    );
  }
}

class _PurchaseSummaryFooter extends StatelessWidget {
  const _PurchaseSummaryFooter({
    required this.estimatedLabel,
    required this.estimatedAmount,
    required this.actualLabel,
    required this.actualAmount,
    required this.showActualTotal,
    required this.submitLabel,
    required this.submitting,
    required this.onSubmit,
  });

  final String estimatedLabel;
  final String estimatedAmount;
  final String actualLabel;
  final String actualAmount;
  final bool showActualTotal;
  final String submitLabel;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.title(estimatedLabel),
                  AppText.title(estimatedAmount),
                ],
              ),
              if (showActualTotal) ...[
                const VGap(AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.title(actualLabel),
                    AppText.title(actualAmount),
                  ],
                ),
              ],
              const VGap(AppSpacing.md),
              AppButton(
                submitLabel,
                key: const Key('purchase_submit_button'),
                loading: submitting,
                onPressed: submitting ? null : onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierPickerSheet extends StatefulWidget {
  const SupplierPickerSheet({super.key});

  static Future<SupplierSummary?> show(BuildContext context) {
    return showModalBottomSheet<SupplierSummary>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const SupplierPickerSheet(),
    );
  }

  @override
  State<SupplierPickerSheet> createState() => _SupplierPickerSheetState();
}

class _SupplierPickerSheetState extends State<SupplierPickerSheet> {
  final _searchController = TextEditingController();
  final _supplierRepository = locator<SupplierRepository>();
  List<SupplierSummary> _suppliers = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers({String? search}) async {
    setState(() => _loading = true);
    try {
      final response = await _supplierRepository.list(search: search);
      if (!mounted) return;
      setState(() {
        _suppliers = response.items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged() {
    _loadSuppliers(search: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.title(l10n.purchaseSelectSupplier),
                    const VGap(AppSpacing.md),
                    AppTextField(
                      fieldKey: const Key('purchase_supplier_search'),
                      hint: l10n.purchaseSearchSuppliers,
                      controller: _searchController,
                      prefixIcon: Icons.search,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _suppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = _suppliers[index];
                          return ListTile(
                            key: Key('purchase_supplier_option_${supplier.id}'),
                            title: Text(supplier.name),
                            onTap: () => Navigator.of(context).pop(supplier),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CatalogItemPickerSheet extends StatelessWidget {
  const CatalogItemPickerSheet({
    super.key,
    required this.quotes,
  });

  final List<PriceQuote> quotes;

  static Future<PriceQuote?> show(
    BuildContext context, {
    required List<PriceQuote> quotes,
  }) {
    return showModalBottomSheet<PriceQuote>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CatalogItemPickerSheet(quotes: quotes),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: AppText.title(l10n.purchaseSelectCatalogItem),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return ListTile(
                    key: Key(
                      'purchase_catalog_option_${quote.foodSupplyId}',
                    ),
                    title: Text(quote.foodSupplyTitle),
                    subtitle: Text(
                      '${formatMeasurementQuantity(quote.priceQuantity, quote.unit)} · ${formatRupiah(quote.priceAmount)}',
                    ),
                    onTap: () => Navigator.of(context).pop(quote),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
