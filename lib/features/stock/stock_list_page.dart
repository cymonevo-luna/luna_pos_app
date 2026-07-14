import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/di/locator.dart';
import '../../core/utils/units.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/food_supply_repository.dart';
import 'models/food_supply.dart';
import 'stock_controller.dart';
import 'stock_form_sheet.dart';

/// Paginated food-supply list for operational users.
class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends ConsumerState<StockListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(stockProvider.notifier).loadMore();
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  Future<void> _openCreate() async {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await StockFormSheet.show(context);
      return;
    }
    await context.pushNamed(AppRoute.stockNew.name);
  }

  Future<void> _openEdit(FoodSupply supply) async {
    FoodSupply detail = supply;
    try {
      detail = await locator<FoodSupplyRepository>().fetchFoodSupply(supply.id);
    } catch (_) {
      // Fall back to list item when detail fetch fails.
    }

    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await StockFormSheet.show(context, existing: detail);
      return;
    }
    await context.pushNamed(
      AppRoute.stockEdit.name,
      pathParameters: {'id': supply.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(stockProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stock),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('stock_add_fab'),
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: Text(l10n.addSupply),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding.copyWith(bottom: 0),
            child: TextField(
              key: const Key('stock_search_field'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchStock,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(stockProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: ref.read(stockProvider.notifier).setSearch,
            ),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _StockListBody(
              state: state,
              isWide: isWide,
              onRefresh: () => ref.read(stockProvider.notifier).refresh(),
              onRetry: () => ref.read(stockProvider.notifier).retry(),
              onLogout: _logout,
              onTap: _openEdit,
              emptyLabel: l10n.noStockItems,
              retryLabel: l10n.retry,
              notAuthorizedTitle: l10n.notAuthorized,
              notAuthorizedMessage: l10n.procurementAccessDenied,
              logoutLabel: l10n.logout,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockListBody extends StatelessWidget {
  const _StockListBody({
    required this.state,
    required this.isWide,
    required this.onRefresh,
    required this.onRetry,
    required this.onLogout,
    required this.onTap,
    required this.emptyLabel,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
    required this.scrollController,
  });

  final StockState state;
  final bool isWide;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(FoodSupply supply) onTap;
  final String emptyLabel;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (state.forbidden) {
      return _ForbiddenView(
        title: notAuthorizedTitle,
        message: state.error ?? notAuthorizedMessage,
        logoutLabel: logoutLabel,
        onLogout: onLogout,
      );
    }

    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return _ErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    if (state.isEmpty) {
      return _EmptyView(message: emptyLabel, onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: isWide
          ? GridView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 2.4,
              ),
              itemCount: state.items.length + (state.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _StockCard(
                  supply: state.items[index],
                  onTap: () => onTap(state.items[index]),
                );
              },
            )
          : ListView.separated(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              itemCount: state.items.length + (state.loadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const VGap(AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _StockCard(
                  supply: state.items[index],
                  onTap: () => onTap(state.items[index]),
                );
              },
            ),
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.supply, required this.onTap});

  final FoodSupply supply;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final quantityLabel =
        formatMeasurementQuantity(supply.stockQuantity, supply.unit);

    return AppCard(
      key: Key('stock_card_${supply.id}'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(supply.title),
          if (supply.description != null && supply.description!.isNotEmpty) ...[
            const VGap(AppSpacing.xs),
            AppText.body(supply.description!, muted: true, maxLines: 2),
          ],
          const VGap(AppSpacing.sm),
          AppText.body(
            'Stock: $quantityLabel',
            color: context.colors.primary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
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

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message, required this.onRefresh});

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
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppText.body(message, align: TextAlign.center, muted: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForbiddenView extends StatelessWidget {
  const _ForbiddenView({
    required this.title,
    required this.message,
    required this.logoutLabel,
    required this.onLogout,
  });

  final String title;
  final String message;
  final String logoutLabel;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 48, color: context.colors.error),
            const VGap(AppSpacing.md),
            AppText.title(title),
            const VGap(AppSpacing.sm),
            AppText.body(message, align: TextAlign.center),
            const VGap(AppSpacing.lg),
            AppButton(logoutLabel, icon: Icons.logout, onPressed: onLogout),
          ],
        ),
      ),
    );
  }
}
