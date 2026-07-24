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
import 'daily_menu_summary_controller.dart';
import 'models/daily_menu_summary.dart';

class DailyMenuSummaryPage extends ConsumerStatefulWidget {
  const DailyMenuSummaryPage({super.key});

  @override
  ConsumerState<DailyMenuSummaryPage> createState() =>
      _DailyMenuSummaryPageState();
}

class _DailyMenuSummaryPageState extends ConsumerState<DailyMenuSummaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyMenuSummaryController.notifier).loadIfNeeded();
    });
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(dailyMenuSummaryController);
    final locale = Localizations.localeOf(context);
    final todayLabel = DateFormat.yMMMMEEEEd(locale.toString()).format(
      DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyMenuSummaryTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: AppText.body(todayLabel, muted: true),
          ),
          Padding(
            padding: AppSpacing.screenPadding.copyWith(top: 0),
            child: _SummaryCards(
              loading: state.loading && state.summary == null,
              totalQuantity: state.summary?.totalQuantity ?? 0,
              totalRevenue: state.summary?.totalRevenue ?? 0,
              itemsLabel: l10n.dailyMenuSummaryTotalItems,
              revenueLabel: l10n.dailyMenuSummaryTotalRevenue,
            ),
          ),
          Padding(
            padding: AppSpacing.screenPadding.copyWith(top: 0, bottom: 0),
            child: AppText.title(l10n.menu),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _DailyMenuSummaryBody(
              state: state,
              onRefresh: () =>
                  ref.read(dailyMenuSummaryController.notifier).refresh(),
              onRetry: () =>
                  ref.read(dailyMenuSummaryController.notifier).retry(),
              onLogout: _logout,
              emptyLabel: l10n.dailyMenuSummaryNoSales,
              retryLabel: l10n.retry,
              notAuthorizedTitle: l10n.notAuthorized,
              notAuthorizedMessage: l10n.notAuthorizedMessage,
              logoutLabel: l10n.logout,
              quantityLabel: l10n.quantityLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({
    required this.loading,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.itemsLabel,
    required this.revenueLabel,
  });

  final bool loading;
  final int totalQuantity;
  final int totalRevenue;
  final String itemsLabel;
  final String revenueLabel;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppCard(
        key: Key('daily_menu_summary_loading_card'),
        child: SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppStatCard(
            key: const Key('daily_menu_summary_total_items_card'),
            icon: Icons.shopping_bag_outlined,
            color: context.colors.primary,
            value: '$totalQuantity',
            label: itemsLabel,
          ),
        ),
        const HGap(AppSpacing.sm),
        Expanded(
          child: AppStatCard(
            key: const Key('daily_menu_summary_total_revenue_card'),
            icon: Icons.payments_outlined,
            color: context.tokens.success,
            value: formatRupiah(totalRevenue),
            label: revenueLabel,
          ),
        ),
      ],
    );
  }
}

class _DailyMenuSummaryBody extends StatelessWidget {
  const _DailyMenuSummaryBody({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLogout,
    required this.emptyLabel,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
    required this.quantityLabel,
  });

  final DailyMenuSummaryState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final String emptyLabel;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;
  final String quantityLabel;

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

    if (state.error != null && state.summary == null) {
      return _ErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    final menus = state.summary?.menus ?? const <DailyMenuSummaryItem>[];

    if (menus.isEmpty) {
      if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return _EmptyView(message: emptyLabel, onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        itemCount: menus.length,
        separatorBuilder: (_, _) => const VGap(AppSpacing.sm),
        itemBuilder: (context, index) {
          return _MenuSummaryRow(
            item: menus[index],
            quantityLabel: quantityLabel,
          );
        },
      ),
    );
  }
}

class _MenuSummaryRow extends StatelessWidget {
  const _MenuSummaryRow({
    required this.item,
    required this.quantityLabel,
  });

  final DailyMenuSummaryItem item;
  final String quantityLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: Key('daily_menu_summary_row_${item.menuId}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: AppText.title(item.menuTitle)),
              AppText.title(
                formatRupiah(item.revenue),
                color: context.colors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const VGap(AppSpacing.xxs),
          AppText.body(
            '$quantityLabel: ${item.quantitySold}',
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
            height: MediaQuery.sizeOf(context).height * 0.25,
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
