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
import '../stock/data/food_supply_repository.dart';
import '../stock/models/food_supply.dart';
import '../stock/models/food_supply_supplier_price.dart';
import 'data/purchase_request_repository.dart';
import 'models/smart_purchase_request.dart';
import 'purchase_list_controller.dart';
import 'smart_purchase_grouper.dart';
import 'widgets/food_supply_picker_sheet.dart';

class SmartPurchaseIngredientDraft {
  SmartPurchaseIngredientDraft({
    required this.foodSupply,
    this.quantity = 1,
  });

  final FoodSupply foodSupply;
  num quantity;
}

class SmartPurchaseRequestPage extends ConsumerStatefulWidget {
  const SmartPurchaseRequestPage({super.key});

  @override
  ConsumerState<SmartPurchaseRequestPage> createState() =>
      _SmartPurchaseRequestPageState();
}

class _SmartPurchaseRequestPageState
    extends ConsumerState<SmartPurchaseRequestPage> {
  static const _ingredientsStep = 0;
  static const _reviewStep = 1;
  static const _confirmStep = 2;

  final _notesController = TextEditingController();
  final List<SmartPurchaseIngredientDraft> _ingredients = [];
  List<SmartPurchaseReviewItem> _reviewItems = const [];
  List<SmartPurchaseSupplierGroupView> _groups = const [];
  int _step = _ingredientsStep;
  bool _loading = false;
  bool _submitting = false;
  String? _error;

  PurchaseRequestRepository get _repository =>
      locator<PurchaseRequestRepository>();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _grandTotal =>
      _groups.fold(0, (sum, group) => sum + group.groupTotal);

  bool get _canProceedFromIngredients =>
      _ingredients.isNotEmpty &&
      _ingredients.every((item) => item.quantity > 0);

  bool get _canSubmit =>
      _groups.isNotEmpty && allSmartPurchaseItemsMatched(_reviewItems);

  Future<void> _addIngredient() async {
    final selected = await FoodSupplyPickerSheet.show(context);
    if (selected == null || !mounted) return;

    if (_ingredients.any((item) => item.foodSupply.id == selected.id)) {
      _showError(AppLocalizations.of(context).purchaseDuplicateItemError);
      return;
    }

    setState(() {
      _ingredients.add(SmartPurchaseIngredientDraft(foodSupply: selected));
      _error = null;
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
      _error = null;
    });
  }

  void _updateIngredientQuantity(int index, num quantity) {
    setState(() {
      _ingredients[index].quantity = quantity;
      _error = null;
    });
  }

  Future<void> _loadReview() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _repository.suggest(
        items: _ingredients
            .map(
              (item) => SmartPurchaseSuggestInput(
                foodSupplyId: item.foodSupply.id,
                quantity: item.quantity,
              ),
            )
            .toList(),
      );

      if (!mounted) return;
      final reviewItems = reviewItemsFromSuggest(response);
      setState(() {
        _reviewItems = reviewItems;
        _groups = regroupSmartPurchaseItems(reviewItems);
        _step = _reviewStep;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = validationMessageFor(e) ?? e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).smartPurchaseSuggestFailed;
      });
    }
  }

  void _updateSupplierForItem(
    SmartPurchaseReviewItem item,
    SmartPurchaseSupplierQuote quote,
  ) {
    final updatedItem = item.withSupplierQuote(quote);
    _replaceReviewItem(item.foodSupplyId, updatedItem);
  }

  Future<void> _pickManualSupplier(SmartPurchaseReviewItem item) async {
    final prices = await locator<FoodSupplyRepository>()
        .fetchSupplierPrices(item.foodSupplyId);
    if (!mounted) return;

    if (prices.isEmpty) {
      _showError(AppLocalizations.of(context).smartPurchaseNoSupplierPrices);
      return;
    }

    final selected = await showModalBottomSheet<FoodSupplySupplierPrice>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ManualSupplierPriceSheet(
        foodSupplyTitle: item.foodSupplyTitle,
        prices: prices,
      ),
    );

    if (selected == null || !mounted) return;
    _replaceReviewItem(
      item.foodSupplyId,
      item.withManualSupplierPrice(selected),
    );
  }

  void _replaceReviewItem(String foodSupplyId, SmartPurchaseReviewItem updated) {
    setState(() {
      _reviewItems = [
        for (final item in _reviewItems)
          if (item.foodSupplyId == foodSupplyId) updated else item,
      ];
      _groups = regroupSmartPurchaseItems(_reviewItems);
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _repository.batchCreate(
        groups: buildBatchGroups(_groups),
        notes: _notesController.text,
      );

      if (!mounted) return;
      ref.read(purchaseListProvider.notifier).refresh();
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.smartPurchaseSubmitSuccess)),
      );
      context.goNamed(AppRoute.purchases.name);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = validationMessageFor(e) ?? e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = AppLocalizations.of(context).smartPurchaseSubmitFailed;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goBack() {
    if (_step == _reviewStep) {
      setState(() {
        _step = _ingredientsStep;
        _error = null;
      });
      return;
    }
    if (_step == _confirmStep) {
      setState(() {
        _step = _reviewStep;
        _error = null;
      });
    }
  }

  void _goNext() {
    if (_step == _ingredientsStep) {
      _loadReview();
      return;
    }
    if (_step == _reviewStep) {
      if (!allSmartPurchaseItemsMatched(_reviewItems)) {
        setState(() {
          _error = AppLocalizations.of(context).smartPurchaseUnmatchedBlocked;
        });
        return;
      }
      setState(() {
        _step = _confirmStep;
        _error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.smartPurchaseTitle),
      ),
      body: Column(
        children: [
          _SmartPurchaseStepIndicator(
            step: _step,
            ingredientsLabel: l10n.smartPurchaseStepIngredients,
            reviewLabel: l10n.smartPurchaseStepReview,
            confirmLabel: l10n.smartPurchaseStepConfirm,
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                _error!,
                style: TextStyle(color: context.colors.error),
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildStepContent(l10n),
          ),
          _SmartPurchaseFooter(
            step: _step,
            backLabel: l10n.smartPurchaseBack,
            nextLabel: l10n.smartPurchaseNext,
            reviewLabel: l10n.smartPurchaseReviewAction,
            submitLabel: l10n.purchaseSubmit,
            totalLabel: l10n.purchaseEstimatedTotal,
            totalAmount: _step == _confirmStep ? formatRupiah(_grandTotal) : null,
            canGoBack: _step > _ingredientsStep,
            canGoNext: _step == _ingredientsStep
                ? _canProceedFromIngredients
                : _step == _reviewStep,
            canSubmit: _canSubmit,
            submitting: _submitting,
            onBack: _goBack,
            onNext: _goNext,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(AppLocalizations l10n) {
    return switch (_step) {
      _ingredientsStep => _IngredientsStep(
          ingredients: _ingredients,
          onAdd: _addIngredient,
          onRemove: _removeIngredient,
          onQuantityChanged: _updateIngredientQuantity,
          l10n: l10n,
        ),
      _reviewStep => _ReviewStep(
          groups: _groups,
          reviewItems: _reviewItems,
          onSupplierChanged: _updateSupplierForItem,
          onManualSupplierPick: _pickManualSupplier,
          l10n: l10n,
        ),
      _ => _ConfirmStep(
          groups: _groups,
          notesController: _notesController,
          l10n: l10n,
        ),
    };
  }
}

class _SmartPurchaseStepIndicator extends StatelessWidget {
  const _SmartPurchaseStepIndicator({
    required this.step,
    required this.ingredientsLabel,
    required this.reviewLabel,
    required this.confirmLabel,
  });

  final int step;
  final String ingredientsLabel;
  final String reviewLabel;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final labels = [ingredientsLabel, reviewLabel, confirmLabel];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: index ~/ 2 < step
                    ? context.colors.primary
                    : context.colors.outlineVariant,
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final active = stepIndex <= step;
          return Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: active
                    ? context.colors.primary
                    : context.colors.surfaceContainerHighest,
                child: Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: active
                        ? context.colors.onPrimary
                        : context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const VGap(AppSpacing.xxs),
              Text(
                labels[stepIndex],
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _IngredientsStep extends StatelessWidget {
  const _IngredientsStep({
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.l10n,
  });

  final List<SmartPurchaseIngredientDraft> ingredients;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int index, num quantity) onQuantityChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: AppText.title(l10n.smartPurchaseIngredients)),
              TextButton.icon(
                key: const Key('smart_purchase_add_ingredient_button'),
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: Text(l10n.purchaseAddItem),
              ),
            ],
          ),
          if (ingredients.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: AppText.body(
                l10n.purchaseAtLeastOneItem,
                muted: true,
                align: TextAlign.center,
              ),
            ),
          ...List.generate(ingredients.length, (index) {
            final item = ingredients[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppText.title(item.foodSupply.title)),
                        IconButton(
                          onPressed: () => onRemove(index),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const VGap(AppSpacing.xs),
                    AppText.body(item.foodSupply.unit, muted: true),
                    const VGap(AppSpacing.sm),
                    AppText.label(l10n.quantityLabel),
                    const VGap(AppSpacing.xs),
                    _DecimalQuantityStepper(
                      key: Key(
                        'smart_purchase_ingredient_${item.foodSupply.id}_quantity',
                      ),
                      quantity: item.quantity,
                      onChanged: (value) => onQuantityChanged(index, value),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.groups,
    required this.reviewItems,
    required this.onSupplierChanged,
    required this.onManualSupplierPick,
    required this.l10n,
  });

  final List<SmartPurchaseSupplierGroupView> groups;
  final List<SmartPurchaseReviewItem> reviewItems;
  final void Function(
    SmartPurchaseReviewItem item,
    SmartPurchaseSupplierQuote quote,
  ) onSupplierChanged;
  final Future<void> Function(SmartPurchaseReviewItem item) onManualSupplierPick;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final unmatched = reviewItems.where((item) => !item.isMatched).toList();

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        if (unmatched.isNotEmpty) ...[
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: context.colors.error),
                const HGap(AppSpacing.sm),
                Expanded(
                  child: AppText.body(l10n.smartPurchaseUnmatchedWarning),
                ),
              ],
            ),
          ),
          const VGap(AppSpacing.md),
          AppText.title(l10n.smartPurchaseUnmatchedItems),
          const VGap(AppSpacing.sm),
          ...unmatched.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _UnmatchedReviewCard(
                item: item,
                onManualSupplierPick: () => onManualSupplierPick(item),
                l10n: l10n,
              ),
            ),
          ),
          const VGap(AppSpacing.md),
        ],
        AppText.title(l10n.smartPurchaseGroupedBySupplier),
        const VGap(AppSpacing.sm),
        if (groups.isEmpty)
          AppText.body(l10n.smartPurchaseNoGroups, muted: true)
        else
          ...groups.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _SupplierGroupCard(
                group: group,
                onSupplierChanged: onSupplierChanged,
                l10n: l10n,
              ),
            ),
          ),
      ],
    );
  }
}

class _UnmatchedReviewCard extends StatelessWidget {
  const _UnmatchedReviewCard({
    required this.item,
    required this.onManualSupplierPick,
    required this.l10n,
  });

  final SmartPurchaseReviewItem item;
  final VoidCallback onManualSupplierPick;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(item.foodSupplyTitle),
          const VGap(AppSpacing.xs),
          AppText.body(
            formatMeasurementQuantity(item.quantity, item.unit),
            muted: true,
          ),
          const VGap(AppSpacing.sm),
          AppButton(
            l10n.smartPurchaseSelectSupplierManually,
            key: Key('smart_purchase_manual_supplier_${item.foodSupplyId}'),
            onPressed: onManualSupplierPick,
          ),
        ],
      ),
    );
  }
}

class _SupplierGroupCard extends StatelessWidget {
  const _SupplierGroupCard({
    required this.group,
    required this.onSupplierChanged,
    required this.l10n,
  });

  final SmartPurchaseSupplierGroupView group;
  final void Function(
    SmartPurchaseReviewItem item,
    SmartPurchaseSupplierQuote quote,
  ) onSupplierChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: AppText.title(group.supplierName)),
              AppText.title(
                formatRupiah(group.groupTotal),
                color: context.colors.primary,
              ),
            ],
          ),
          const VGap(AppSpacing.sm),
          ...group.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ReviewLineCard(
                item: item,
                onSupplierChanged: onSupplierChanged,
                l10n: l10n,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewLineCard extends StatelessWidget {
  const _ReviewLineCard({
    required this.item,
    required this.onSupplierChanged,
    required this.l10n,
  });

  final SmartPurchaseReviewItem item;
  final void Function(
    SmartPurchaseReviewItem item,
    SmartPurchaseSupplierQuote quote,
  ) onSupplierChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final quotes = item.allSupplierQuotes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: AppText.body(item.foodSupplyTitle)),
            AppText.body(formatRupiah(item.lineTotal)),
          ],
        ),
        const VGap(AppSpacing.xs),
        AppText.body(
          formatMeasurementQuantity(item.quantity, item.unit),
          muted: true,
        ),
        if (quotes.length > 1) ...[
          const VGap(AppSpacing.xs),
          DropdownButtonFormField<String>(
            key: Key(
              'smart_purchase_supplier_${item.foodSupplyId}_${item.selectedSupplierId}',
            ),
            initialValue: item.selectedSupplierId,
            decoration: InputDecoration(
              labelText: l10n.purchaseSupplierLabel,
              isDense: true,
            ),
            items: quotes
                .map(
                  (quote) => DropdownMenuItem(
                    value: quote.supplierId,
                    child: Text(
                      '${quote.supplierName} · ${formatRupiah(quote.unitPrice.round())}',
                    ),
                  ),
                )
                .toList(),
            onChanged: (supplierId) {
              if (supplierId == null) return;
              final quote = quotes.firstWhere(
                (entry) => entry.supplierId == supplierId,
              );
              onSupplierChanged(item, quote);
            },
          ),
        ],
      ],
    );
  }
}

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    required this.groups,
    required this.notesController,
    required this.l10n,
  });

  final List<SmartPurchaseSupplierGroupView> groups;
  final TextEditingController notesController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.title(l10n.smartPurchaseConfirmSummary),
          const VGap(AppSpacing.md),
          ...groups.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppText.title(group.supplierName)),
                        AppText.title(formatRupiah(group.groupTotal)),
                      ],
                    ),
                    const VGap(AppSpacing.sm),
                    ...group.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Row(
                          children: [
                            Expanded(child: AppText.body(item.foodSupplyTitle)),
                            AppText.body(formatRupiah(item.lineTotal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppTextField(
            fieldKey: const Key('smart_purchase_notes_field'),
            label: l10n.noteLabel,
            hint: l10n.purchaseNotesHint,
            controller: notesController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2000),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmartPurchaseFooter extends StatelessWidget {
  const _SmartPurchaseFooter({
    required this.step,
    required this.backLabel,
    required this.nextLabel,
    required this.reviewLabel,
    required this.submitLabel,
    required this.totalLabel,
    required this.totalAmount,
    required this.canGoBack,
    required this.canGoNext,
    required this.canSubmit,
    required this.submitting,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final int step;
  final String backLabel;
  final String nextLabel;
  final String reviewLabel;
  final String submitLabel;
  final String totalLabel;
  final String? totalAmount;
  final bool canGoBack;
  final bool canGoNext;
  final bool canSubmit;
  final bool submitting;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isConfirm = step == 2;

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
              if (totalAmount != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.title(totalLabel),
                    AppText.title(totalAmount!),
                  ],
                ),
                const VGap(AppSpacing.md),
              ],
              Row(
                children: [
                  if (canGoBack) ...[
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('smart_purchase_back_button'),
                        onPressed: submitting ? null : onBack,
                        child: Text(backLabel),
                      ),
                    ),
                    const HGap(AppSpacing.sm),
                  ],
                  Expanded(
                    flex: canGoBack ? 1 : 1,
                    child: isConfirm
                        ? AppButton(
                            submitLabel,
                            key: const Key('smart_purchase_submit_button'),
                            loading: submitting,
                            onPressed: canSubmit && !submitting ? onSubmit : null,
                          )
                        : AppButton(
                            step == 0 ? nextLabel : reviewLabel,
                            key: const Key('smart_purchase_next_button'),
                            onPressed: canGoNext ? onNext : null,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualSupplierPriceSheet extends StatelessWidget {
  const _ManualSupplierPriceSheet({
    required this.foodSupplyTitle,
    required this.prices,
  });

  final String foodSupplyTitle;
  final List<FoodSupplySupplierPrice> prices;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText.title(l10n.smartPurchaseSelectSupplierManually),
                  const VGap(AppSpacing.xs),
                  AppText.body(foodSupplyTitle, muted: true),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: prices.length,
                itemBuilder: (context, index) {
                  final price = prices[index];
                  return ListTile(
                    key: Key(
                      'smart_purchase_manual_price_${price.supplierId}',
                    ),
                    title: Text(price.supplierName),
                    subtitle: Text(
                      '${formatMeasurementQuantity(price.priceQuantity, price.unit)} · ${formatRupiah(price.priceAmount)}',
                    ),
                    onTap: () => Navigator.of(context).pop(price),
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
          icon: Icons.add,
          onPressed: () => _apply(widget.quantity + 1),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
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
