import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/navigation_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import '../menu/menu_controller.dart';
import '../menu/models/pos_menu.dart';
import 'dispose_food_controller.dart';

class DisposeFoodPage extends ConsumerStatefulWidget {
  const DisposeFoodPage({super.key});

  @override
  ConsumerState<DisposeFoodPage> createState() => _DisposeFoodPageState();
}

class _DisposeFoodPageState extends ConsumerState<DisposeFoodPage> {
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _noteController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _syncQuantityField(int quantity) {
    final text = quantity.toString();
    if (_quantityController.text != text) {
      _quantityController.text = text;
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final response = await ref.read(disposeFoodProvider.notifier).submit();
    if (!mounted) return;

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.disposeFoodSuccess(
              response.menuTitle,
              response.quantity,
              formatRupiah(response.lossAmount),
            ),
          ),
        ),
      );
      ref.read(disposeFoodProvider.notifier).clearSelection();
      _noteController.clear();
      _quantityController.text = '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final menuState = ref.watch(menuProvider);
    final disposeState = ref.watch(disposeFoodProvider);

    ref.listen<DisposeFoodState>(disposeFoodProvider, (previous, next) {
      if (next.selectedMenu?.id != previous?.selectedMenu?.id) {
        _noteController.text = next.note;
        _syncQuantityField(next.quantity);
      }
    });

    return LazyShellTabLoader(
      branch: ShellBranch.disposeFood,
      onVisible: (ref) => ref.read(menuProvider.notifier).loadIfNeeded(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.disposeFoodTitle),
          actions: [
            if (disposeState.selectedMenu != null)
              IconButton(
                key: const Key('dispose_food_clear_selection'),
                tooltip: l10n.disposeFoodChangeMenu,
                onPressed: disposeState.submitting
                    ? null
                    : () {
                        ref.read(disposeFoodProvider.notifier).clearSelection();
                        _noteController.clear();
                        _quantityController.text = '1';
                      },
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: disposeState.selectedMenu == null
                  ? _MenuSelectionBody(
                      menuState: menuState,
                      onSelect: (item) {
                        ref.read(disposeFoodProvider.notifier).selectMenu(item);
                        _noteController.clear();
                        _quantityController.text = '1';
                      },
                      onRetry: () => ref.read(menuProvider.notifier).retry(),
                      onRefresh: () => ref.read(menuProvider.notifier).refresh(),
                      emptyLabel: l10n.noMenuItemsAvailable,
                      retryLabel: l10n.retry,
                    )
                  : _DisposeFormBody(
                      menu: disposeState.selectedMenu!,
                      disposeState: disposeState,
                      noteController: _noteController,
                      quantityController: _quantityController,
                      onQuantityChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null) {
                          ref
                              .read(disposeFoodProvider.notifier)
                              .setQuantity(parsed);
                        }
                      },
                      onNoteChanged: ref
                          .read(disposeFoodProvider.notifier)
                          .setNote,
                      onSubmit: _submit,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSelectionBody extends StatelessWidget {
  const _MenuSelectionBody({
    required this.menuState,
    required this.onSelect,
    required this.onRetry,
    required this.onRefresh,
    required this.emptyLabel,
    required this.retryLabel,
  });

  final MenuState menuState;
  final void Function(POSMenuItem item) onSelect;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final String emptyLabel;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (menuState.error != null && menuState.data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.error),
              const VGap(AppSpacing.md),
              AppText.body(menuState.error!, align: TextAlign.center),
              const VGap(AppSpacing.lg),
              AppButton(retryLabel, onPressed: onRetry),
            ],
          ),
        ),
      );
    }

    if (menuState.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (menuState.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Center(
                child: AppText.body(emptyLabel, align: TextAlign.center, muted: true),
              ),
            ),
          ],
        ),
      );
    }

    final data = menuState.filteredData ?? menuState.data!;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        children: [
          AppText.body(l10n.disposeFoodSelectMenu, muted: true),
          const VGap(AppSpacing.md),
          for (final category in data.categories)
            if (category.menus.isNotEmpty) ...[
              AppSectionHeader(title: category.name),
              const VGap(AppSpacing.sm),
              for (final item in category.menus)
                _SelectableMenuRow(
                  item: item,
                  onTap: item.availableStock > 0 ? () => onSelect(item) : null,
                ),
              const VGap(AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _SelectableMenuRow extends StatelessWidget {
  const _SelectableMenuRow({required this.item, required this.onTap});

  final POSMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      key: Key('dispose_menu_row_${item.id}'),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(item.title),
                const VGap(AppSpacing.xs),
                AppText.body(
                  '${l10n.availableStock}: ${item.availableStock}',
                  muted: true,
                ),
              ],
            ),
          ),
          AppText.body(
            formatRupiah(item.sellPrice),
            color: context.colors.primary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _DisposeFormBody extends ConsumerWidget {
  const _DisposeFormBody({
    required this.menu,
    required this.disposeState,
    required this.noteController,
    required this.quantityController,
    required this.onQuantityChanged,
    required this.onNoteChanged,
    required this.onSubmit,
  });

  final POSMenuItem menu;
  final DisposeFoodState disposeState;
  final TextEditingController noteController;
  final TextEditingController quantityController;
  final void Function(String value) onQuantityChanged;
  final void Function(String note) onNoteChanged;
  final Future<void> Function() onSubmit;

  void _adjustQuantity(int delta, WidgetRef ref) {
    final next = (disposeState.quantity + delta).clamp(1, menu.availableStock);
    ref.read(disposeFoodProvider.notifier).setQuantity(next);
    quantityController.text = next.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final estimatedLoss = menu.sellPrice * disposeState.quantity;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(menu.title),
              const VGap(AppSpacing.xs),
              AppText.body(
                '${l10n.availableStock}: ${menu.availableStock}',
                muted: true,
              ),
            ],
          ),
        ),
        const VGap(AppSpacing.lg),
        AppText.title(l10n.disposeFoodQuantity),
        const VGap(AppSpacing.sm),
        Row(
          children: [
            IconButton(
              key: const Key('dispose_food_decrement'),
              onPressed: disposeState.submitting || disposeState.quantity <= 1
                  ? null
                  : () => _adjustQuantity(-1, ref),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Expanded(
              child: TextField(
                key: const Key('dispose_food_quantity_field'),
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                enabled: !disposeState.submitting,
                decoration: InputDecoration(
                  errorText: disposeState.quantityError,
                ),
                onChanged: onQuantityChanged,
              ),
            ),
            IconButton(
              key: const Key('dispose_food_increment'),
              onPressed: disposeState.submitting ||
                      disposeState.quantity >= menu.availableStock
                  ? null
                  : () => _adjustQuantity(1, ref),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const VGap(AppSpacing.lg),
        AppText.title(l10n.noteLabel),
        const VGap(AppSpacing.sm),
        TextField(
          key: const Key('dispose_food_note_field'),
          controller: noteController,
          maxLength: 500,
          maxLines: 3,
          enabled: !disposeState.submitting,
          decoration: InputDecoration(
            hintText: l10n.disposeFoodNoteHint,
          ),
          onChanged: onNoteChanged,
        ),
        const VGap(AppSpacing.lg),
        AppCard(
          key: const Key('dispose_food_summary'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(l10n.disposeFoodSummary),
              const VGap(AppSpacing.sm),
              _SummaryRow(label: l10n.menu, value: menu.title),
              _SummaryRow(
                label: l10n.disposeFoodQuantity,
                value: '${disposeState.quantity}',
              ),
              _SummaryRow(
                label: l10n.disposeFoodEstimatedLoss,
                value: formatRupiah(estimatedLoss),
                subtitle: l10n.disposeFoodLossCalculatedOnSubmit,
              ),
            ],
          ),
        ),
        if (disposeState.error != null) ...[
          const VGap(AppSpacing.md),
          AppText.body(
            disposeState.error!,
            color: context.colors.error,
            align: TextAlign.center,
          ),
        ],
        const VGap(AppSpacing.lg),
        AppButton(
          l10n.disposeFoodConfirm,
          key: const Key('dispose_food_submit'),
          loading: disposeState.submitting,
          onPressed: disposeState.canSubmit ? onSubmit : null,
        ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppText.body(label, muted: true)),
              AppText.body(value, weight: FontWeight.w600),
            ],
          ),
          if (subtitle != null) ...[
            const VGap(AppSpacing.xs),
            AppText.body(subtitle!, muted: true),
          ],
        ],
      ),
    );
  }
}
