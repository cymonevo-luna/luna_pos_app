import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/router/navigation_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import 'models/production_request.dart';
import 'production_request_controller.dart';

class ProductionRequestListPage extends ConsumerStatefulWidget {
  const ProductionRequestListPage({super.key});

  @override
  ConsumerState<ProductionRequestListPage> createState() =>
      _ProductionRequestListPageState();
}

class _ProductionRequestListPageState
    extends ConsumerState<ProductionRequestListPage> {
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
      ref.read(productionRequestListProvider.notifier).loadMore();
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
    final state = ref.watch(productionRequestListProvider);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return LazyShellTabLoader(
      branch: ShellBranch.calendar,
      onVisible: (ref) =>
          ref.read(productionRequestListProvider.notifier).loadIfNeeded(),
      child: Scaffold(
      appBar: AppBar(title: Text(l10n.productionDeliveries)),
      body: _ProductionRequestListBody(
        state: state,
        dateFormat: dateFormat,
        onRefresh: () =>
            ref.read(productionRequestListProvider.notifier).refresh(),
        onRetry: () => ref.read(productionRequestListProvider.notifier).retry(),
        onLogout: _logout,
        onTap: (item) => context.pushNamed(
          AppRoute.productionRequestDetail.name,
          pathParameters: {'id': item.id},
        ),
        emptyLabel: l10n.noDeliveriesPending,
        retryLabel: l10n.retry,
        notAuthorizedTitle: l10n.notAuthorized,
        notAuthorizedMessage: l10n.notAuthorizedMessage,
        logoutLabel: l10n.logout,
        scrollController: _scrollController,
      ),
      ),
    );
  }
}

class _ProductionRequestListBody extends StatelessWidget {
  const _ProductionRequestListBody({
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

  final ProductionRequestListState state;
  final DateFormat dateFormat;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(ProductionRequestSummary item) onTap;
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

    if (state.error != null && state.items.isEmpty) {
      return _ErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    if (state.items.isEmpty) {
      if (state.loading || state.page == 0) {
        return const Center(child: CircularProgressIndicator());
      }
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
          return _ProductionRequestRow(
            item: item,
            dateFormat: dateFormat,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _ProductionRequestRow extends StatelessWidget {
  const _ProductionRequestRow({
    required this.item,
    required this.dateFormat,
    required this.onTap,
  });

  final ProductionRequestSummary item;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final createdAt = item.createdAt;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (createdAt != null)
            AppText.caption(dateFormat.format(createdAt.toLocal()), muted: true),
          if (createdAt != null) const VGap(AppSpacing.xs),
          if (item.items.isNotEmpty)
            for (final line in item.items) ...[
              Row(
                children: [
                  Expanded(child: AppText.title(line.menuTitle)),
                  AppText.body(
                    '${l10n.quantityLabel}: ${line.quantity}',
                    muted: true,
                  ),
                ],
              ),
              if (line != item.items.last) const VGap(AppSpacing.xs),
            ]
          else
            AppText.body(
              l10n.productionItemCount(item.itemCount),
              muted: true,
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
