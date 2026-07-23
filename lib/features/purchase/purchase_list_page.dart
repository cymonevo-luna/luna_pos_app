import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'models/purchase_request.dart';
import 'purchase_list_controller.dart';
import 'widgets/purchase_status_badge.dart';

class PurchaseListPage extends ConsumerStatefulWidget {
  const PurchaseListPage({super.key});

  @override
  ConsumerState<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends ConsumerState<PurchaseListPage> {
  final _scrollController = ScrollController();

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
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(purchaseListProvider.notifier).loadMore();
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(purchaseListProvider);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.purchases),
        actions: [
          TextButton.icon(
            key: const Key('smart_purchase_entry_button'),
            onPressed: () =>
                context.pushNamed(AppRoute.purchasesSmartRequest.name),
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text(l10n.smartPurchaseTitle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoute.purchasesNew.name),
        icon: const Icon(Icons.add),
        label: Text(l10n.purchasesNew),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusFilterBar(
            selected: state.filter.status,
            onSelected: (status) =>
                ref.read(purchaseListProvider.notifier).applyStatusFilter(status),
          ),
          Expanded(
            child: _PurchaseListBody(
              state: state,
              dateFormat: dateFormat,
              onRefresh: () => ref.read(purchaseListProvider.notifier).refresh(),
              onRetry: () => ref.read(purchaseListProvider.notifier).retry(),
              onLogout: _logout,
              onTap: (item) => context.pushNamed(
                AppRoute.purchaseDetail.name,
                pathParameters: {'id': item.id},
              ),
              emptyLabel: l10n.noPurchaseRequests,
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

class _StatusFilterBar extends StatelessWidget {
  const _StatusFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final PurchaseRequestStatus? selected;
  final ValueChanged<PurchaseRequestStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: l10n.purchaseFilterAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          const HGap(AppSpacing.xs),
          _FilterChip(
            label: l10n.purchaseStatusPending,
            selected: selected == PurchaseRequestStatus.pending,
            onTap: () => onSelected(PurchaseRequestStatus.pending),
          ),
          const HGap(AppSpacing.xs),
          _FilterChip(
            label: l10n.purchaseStatusRequested,
            selected: selected == PurchaseRequestStatus.requested,
            onTap: () => onSelected(PurchaseRequestStatus.requested),
          ),
          const HGap(AppSpacing.xs),
          _FilterChip(
            label: l10n.purchaseStatusPaid,
            selected: selected == PurchaseRequestStatus.paid,
            onTap: () => onSelected(PurchaseRequestStatus.paid),
          ),
          const HGap(AppSpacing.xs),
          _FilterChip(
            label: l10n.purchaseStatusDelivered,
            selected: selected == PurchaseRequestStatus.delivered,
            onTap: () => onSelected(PurchaseRequestStatus.delivered),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: colors.primaryContainer,
      labelStyle: TextStyle(
        color: selected ? colors.onPrimaryContainer : colors.onSurface,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }
}

class _PurchaseListBody extends StatelessWidget {
  const _PurchaseListBody({
    required this.state,
    required this.dateFormat,
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

  final PurchaseListState state;
  final DateFormat dateFormat;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(PurchaseRequestSummary item) onTap;
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
      child: ListView.separated(
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

          final item = state.items[index];
          return _PurchaseRequestRow(
            item: item,
            dateFormat: dateFormat,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _PurchaseRequestRow extends StatelessWidget {
  const _PurchaseRequestRow({
    required this.item,
    required this.dateFormat,
    required this.onTap,
  });

  final PurchaseRequestSummary item;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final createdAt = item.createdAt;
    final displayAmount = item.totalActualAmount ?? item.totalEstimatedAmount;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.title(
                  createdAt != null
                      ? dateFormat.format(createdAt.toLocal())
                      : '—',
                ),
              ),
              PurchaseStatusBadge(status: item.status),
            ],
          ),
          const VGap(AppSpacing.xs),
          AppText.title(item.supplierName),
          const VGap(AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: AppText.body(
                  l10n.purchaseItemCount(item.itemCount),
                  muted: true,
                ),
              ),
              AppText.title(
                formatRupiah(displayAmount),
                color: context.colors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          if (item.createdByUsername != null) ...[
            const VGap(AppSpacing.xxs),
            AppText.body(
              '${l10n.purchaseCreatedBy}: ${item.createdByUsername}',
              muted: true,
            ),
          ],
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
            height: MediaQuery.sizeOf(context).height * 0.5,
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
