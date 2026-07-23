import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/router/navigation_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/order/order_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import 'menu_controller.dart';
import 'menu_layout_provider.dart';
import 'models/pos_menu.dart';
import 'widgets/add_to_cart_sheet.dart';
import 'widgets/menu_item_card.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardAuth());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _guardAuth() {
    final authed = ref.read(authProvider).isAuthenticated;
    if (!authed && mounted) {
      context.goNamed(AppRoute.login.name);
    }
  }

  void _addToCart(POSMenuItem item) {
    showAddToCartSheet(
      context: context,
      item: item,
      onAdd: (quantity, note) {
        ref
            .read(orderProvider.notifier)
            .addLine(item, quantity: quantity, note: note);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider.select((s) => s.isAuthenticated), (previous, next) {
      if (!next && mounted) context.goNamed(AppRoute.login.name);
    });

    ref.listen<String?>(orderProvider.select((state) => state.errorMessage), (
      previous,
      next,
    ) {
      if (next != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next)));
      }
    });

    final l10n = AppLocalizations.of(context);
    final menu = ref.watch(menuProvider);
    final order = ref.watch(orderProvider);
    final layout = ref.watch(menuLayoutProvider);

    return LazyShellTabLoader(
      branch: ShellBranch.home,
      onVisible: (ref) => ref.read(menuProvider.notifier).loadIfNeeded(),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.menu),
        actions: [
          IconButton(
            tooltip: l10n.cart,
            onPressed: () => context.pushNamed(AppRoute.cart.name),
            icon: Badge(
              isLabelVisible: order.itemCount > 0,
              label: Text('${order.itemCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          PopupMenuButton<MenuLayout>(
            key: const Key('menu_layout_toggle'),
            tooltip: l10n.menuLayout,
            icon: Icon(
              layout == MenuLayout.grid ? Icons.grid_view : Icons.view_list,
            ),
            onSelected: ref.read(menuLayoutProvider.notifier).setLayout,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuLayout.grid,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: layout == MenuLayout.grid
                          ? const Icon(Icons.check, size: 20)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(l10n.menuLayoutGrid),
                  ],
                ),
              ),
              PopupMenuItem(
                value: MenuLayout.list,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: layout == MenuLayout.list
                          ? const Icon(Icons.check, size: 20)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(l10n.menuLayoutList),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: l10n.refreshMenu,
            onPressed: menu.loading || menu.refreshing
                ? null
                : () => ref.read(menuProvider.notifier).refresh(),
            icon: menu.refreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding.copyWith(bottom: 0),
            child: TextField(
              key: const Key('menu_search_field'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchMenu,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: menu.search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(menuProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: ref.read(menuProvider.notifier).setSearch,
            ),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _MenuBody(
              state: menu,
              onRetry: () => ref.read(menuProvider.notifier).retry(),
              onRefresh: () => ref.read(menuProvider.notifier).refresh(),
              onAdd: _addToCart,
              emptyLabel: l10n.noMenuItemsAvailable,
              noSearchResultsLabel: l10n.noMenuSearchResults,
              retryLabel: l10n.retry,
            ),
          ),
          _MenuOrderBar(
            itemCountLabel: l10n.itemCount(order.itemCount),
            orderTotalLabel: l10n.orderTotal,
            grandTotal: order.grandTotal,
            checkoutLabel: l10n.checkout,
            onCheckout: order.lines.isEmpty
                ? null
                : () => context.pushNamed(AppRoute.checkout.name),
          ),
        ],
      ),
      ),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.state,
    required this.onRetry,
    required this.onRefresh,
    required this.onAdd,
    required this.emptyLabel,
    required this.noSearchResultsLabel,
    required this.retryLabel,
  });

  final MenuState state;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final void Function(POSMenuItem item) onAdd;
  final String emptyLabel;
  final String noSearchResultsLabel;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    if (state.error != null && state.data == null) {
      return _MenuErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    if (state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return _MenuEmptyView(message: emptyLabel, onRefresh: onRefresh);
    }

    if (state.hasNoSearchResults) {
      return _MenuEmptyView(
        message: noSearchResultsLabel,
        onRefresh: onRefresh,
      );
    }

    final data = state.filteredData!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900
              ? 4
              : width >= 600
              ? 3
              : 2;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              for (final category in data.categories) ...[
                if (category.menus.isNotEmpty) ...[
                  AppSectionHeader(title: category.name),
                  const VGap(AppSpacing.sm),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.menus.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppSpacing.xs,
                      crossAxisSpacing: AppSpacing.xs,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (context, index) {
                      final item = category.menus[index];
                      return MenuItemCard(item: item, onAdd: () => onAdd(item));
                    },
                  ),
                  const VGap(AppSpacing.lg),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MenuErrorView extends StatelessWidget {
  const _MenuErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const VGap(AppSpacing.md),
            AppText.body(message, align: TextAlign.center),
            const VGap(AppSpacing.lg),
            AppButton(retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _MenuEmptyView extends StatelessWidget {
  const _MenuEmptyView({required this.message, required this.onRefresh});

  final String message;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppText.body(
                  message,
                  align: TextAlign.center,
                  muted: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuOrderBar extends StatelessWidget {
  const _MenuOrderBar({
    required this.itemCountLabel,
    required this.orderTotalLabel,
    required this.grandTotal,
    required this.checkoutLabel,
    required this.onCheckout,
  });

  final String itemCountLabel;
  final String orderTotalLabel;
  final int grandTotal;
  final String checkoutLabel;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: context.colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText.body(itemCountLabel, muted: true),
              const VGap(AppSpacing.sm),
              Row(
                children: [
                  Expanded(child: AppText.title(orderTotalLabel)),
                  AppText.title(
                    formatRupiah(grandTotal),
                    color: context.colors.primary,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              const VGap(AppSpacing.md),
              AppButton(checkoutLabel, onPressed: onCheckout),
            ],
          ),
        ),
      ),
    );
  }
}
