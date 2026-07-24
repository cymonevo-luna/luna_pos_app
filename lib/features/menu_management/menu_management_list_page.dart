import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/router/navigation_config.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/di/locator.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/menu/widgets/menu_photo.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import 'data/admin_menu_repository.dart';
import 'menu_management_form_sheet.dart';
import 'menu_management_list_controller.dart';
import 'models/admin_menu.dart';

/// Paginated admin menu list for menu management.
class MenuManagementListPage extends ConsumerStatefulWidget {
  const MenuManagementListPage({super.key});

  @override
  ConsumerState<MenuManagementListPage> createState() =>
      _MenuManagementListPageState();
}

class _MenuManagementListPageState extends ConsumerState<MenuManagementListPage> {
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
      ref.read(menuManagementProvider.notifier).loadMore();
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
      await MenuManagementFormSheet.show(context);
      return;
    }
    await context.pushNamed(AppRoute.manageMenusNew.name);
  }

  Future<void> _openEdit(AdminMenu menu) async {
    AdminMenu detail = menu;
    try {
      detail = await locator<AdminMenuRepository>().fetchMenu(menu.id);
    } catch (_) {
      // Fall back to list item when detail fetch fails.
    }

    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await MenuManagementFormSheet.show(context, existing: detail);
      return;
    }
    await context.pushNamed(
      AppRoute.manageMenusEdit.name,
      pathParameters: {'id': menu.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(menuManagementProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return LazyShellTabLoader(
      branch: ShellBranch.manageMenus,
      onVisible: (ref) {
        ref.read(menuManagementProvider.notifier).loadInitial();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.manageMenus),
        ),
        floatingActionButton: FloatingActionButton.extended(
          key: const Key('menu_management_add_fab'),
          onPressed: _openCreate,
          icon: const Icon(Icons.add),
          label: Text(l10n.manageMenusNew),
        ),
        body: Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding.copyWith(bottom: 0),
              child: TextField(
                key: const Key('menu_management_search_field'),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.manageMenusSearch,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state.search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(menuManagementProvider.notifier)
                                .setSearch('');
                          },
                        )
                      : null,
                ),
                onChanged:
                    ref.read(menuManagementProvider.notifier).setSearch,
              ),
            ),
            const VGap(AppSpacing.sm),
            Padding(
              padding: AppSpacing.screenPadding.copyWith(top: 0, bottom: 0),
              child: _SortControls(
                sortBy: state.sortBy,
                sortOrder: state.sortOrder,
                onSortByChanged: (sortBy) => ref
                    .read(menuManagementProvider.notifier)
                    .setSort(sortBy, state.sortOrder),
                onToggleOrder: ref
                    .read(menuManagementProvider.notifier)
                    .toggleSortOrder,
              ),
            ),
            const VGap(AppSpacing.sm),
            Expanded(
              child: _MenuManagementListBody(
                state: state,
                isWide: isWide,
                onRefresh: () =>
                    ref.read(menuManagementProvider.notifier).refresh(),
                onRetry: () =>
                    ref.read(menuManagementProvider.notifier).retry(),
                onLogout: _logout,
                onTap: _openEdit,
                emptyLabel: l10n.noManageMenus,
                retryLabel: l10n.retry,
                notAuthorizedTitle: l10n.notAuthorized,
                notAuthorizedMessage: l10n.procurementAccessDenied,
                logoutLabel: l10n.logout,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortControls extends StatelessWidget {
  const _SortControls({
    required this.sortBy,
    required this.sortOrder,
    required this.onSortByChanged,
    required this.onToggleOrder,
  });

  final AdminMenuSortBy sortBy;
  final AdminMenuSortOrder sortOrder;
  final ValueChanged<AdminMenuSortBy> onSortByChanged;
  final VoidCallback onToggleOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<AdminMenuSortBy>(
            key: const Key('menu_management_sort_field'),
            initialValue: sortBy,
            decoration: InputDecoration(
              labelText: l10n.manageMenusSortLabel,
              isDense: true,
            ),
            items: [
              DropdownMenuItem(
                value: AdminMenuSortBy.title,
                child: Text(l10n.manageMenusSortTitle),
              ),
              DropdownMenuItem(
                value: AdminMenuSortBy.stock,
                child: Text(l10n.manageMenusSortStock),
              ),
            ],
            onChanged: (value) {
              if (value != null) onSortByChanged(value);
            },
          ),
        ),
        const HGap(AppSpacing.sm),
        IconButton(
          key: const Key('menu_management_sort_order_button'),
          tooltip: sortOrder == AdminMenuSortOrder.asc
              ? l10n.manageMenusSortAscending
              : l10n.manageMenusSortDescending,
          onPressed: onToggleOrder,
          icon: Icon(
            sortOrder == AdminMenuSortOrder.asc
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
        ),
      ],
    );
  }
}

class _MenuManagementListBody extends StatelessWidget {
  const _MenuManagementListBody({
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

  final MenuManagementState state;
  final bool isWide;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(AdminMenu menu) onTap;
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
                childAspectRatio: 2.8,
              ),
              itemCount: state.items.length + (state.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _MenuManagementCard(
                  menu: state.items[index],
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
                return _MenuManagementCard(
                  menu: state.items[index],
                  onTap: () => onTap(state.items[index]),
                );
              },
            ),
    );
  }
}

class _MenuManagementCard extends StatelessWidget {
  const _MenuManagementCard({required this.menu, required this.onTap});

  final AdminMenu menu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final inStock = menu.availableStock > 0;

    return AppCard(
      key: Key('menu_management_card_${menu.id}'),
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.brMd,
            child: SizedBox(
              width: 64,
              height: 64,
              child: MenuPhoto(photoUrl: menu.photoUrl),
            ),
          ),
          const HGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(menu.title, maxLines: 1),
                const VGap(AppSpacing.xxs),
                AppText.body(menu.categoryName, muted: true, maxLines: 1),
                const VGap(AppSpacing.xs),
                Row(
                  children: [
                    Flexible(child: _StockBadge(
                      stock: menu.availableStock,
                      inStock: inStock,
                    )),
                    const HGap(AppSpacing.sm),
                    Flexible(
                      child: AppText.label(
                        formatRupiah(menu.sellPrice),
                        color: colors.primary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        align: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock, required this.inStock});

  final int stock;
  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: inStock ? colors.primaryContainer : colors.errorContainer,
        borderRadius: AppRadius.brSm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: AppText.body(
          'Stock: $stock',
          color: inStock ? colors.onPrimaryContainer : colors.onErrorContainer,
          maxLines: 1,
        ),
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
