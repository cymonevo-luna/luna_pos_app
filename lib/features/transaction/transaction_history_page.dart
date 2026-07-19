import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/router/navigation_config.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import 'models/transaction.dart';
import 'payment_method_label.dart';
import 'transaction_history_controller.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
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
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();
    final current = ref.read(transactionHistoryProvider).filter;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: current.dateFrom != null && current.dateTo != null
          ? DateTimeRange(start: current.dateFrom!, end: current.dateTo!)
          : null,
      helpText: l10n.filterByDate,
      locale: locale,
    );
    if (!mounted || picked == null) return;
    await ref.read(transactionHistoryProvider.notifier).applyDateFilter(
          dateFrom: picked.start,
          dateTo: picked.end,
        );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  String _paymentMethodLabel(AppLocalizations l10n, String method) {
    return paymentMethodLabel(l10n, method);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(transactionHistoryProvider);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return LazyShellTabLoader(
      branch: ShellBranch.transactions,
      onVisible: (ref) =>
          ref.read(transactionHistoryProvider.notifier).loadIfNeeded(),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactionHistory),
        actions: [
          if (state.filter.hasDateRange)
            IconButton(
              tooltip: l10n.clearDateFilter,
              onPressed: () =>
                  ref.read(transactionHistoryProvider.notifier).clearDateFilter(),
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          IconButton(
            tooltip: l10n.filterByDate,
            onPressed: _pickDateRange,
            icon: Icon(
              state.filter.hasDateRange
                  ? Icons.date_range
                  : Icons.date_range_outlined,
            ),
          ),
        ],
      ),
      body: _TransactionHistoryBody(
        state: state,
        dateFormat: dateFormat,
        paymentMethodLabel: (method) => _paymentMethodLabel(l10n, method),
        onRefresh: () =>
            ref.read(transactionHistoryProvider.notifier).refresh(),
        onRetry: () => ref.read(transactionHistoryProvider.notifier).retry(),
        onLogout: _logout,
        onTap: (item) => context.pushNamed(
          AppRoute.transactionDetail.name,
          pathParameters: {'id': item.id},
        ),
        emptyLabel: l10n.noTransactions,
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

class _TransactionHistoryBody extends StatelessWidget {
  const _TransactionHistoryBody({
    required this.state,
    required this.dateFormat,
    required this.paymentMethodLabel,
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

  final TransactionHistoryState state;
  final DateFormat dateFormat;
  final String Function(String method) paymentMethodLabel;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(TransactionListItem item) onTap;
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
          return _TransactionRow(
            item: item,
            dateFormat: dateFormat,
            paymentMethodLabel: paymentMethodLabel(item.method),
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.item,
    required this.dateFormat,
    required this.paymentMethodLabel,
    required this.onTap,
  });

  final TransactionListItem item;
  final DateFormat dateFormat;
  final String paymentMethodLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final occurredAt = item.occurredAt;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.title(
                  occurredAt != null
                      ? dateFormat.format(occurredAt.toLocal())
                      : '—',
                ),
              ),
              AppText.title(
                formatRupiah(item.amount),
                color: context.colors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const VGap(AppSpacing.xs),
          AppText.body('${l10n.paymentMethod}: $paymentMethodLabel', muted: true),
          if (item.cashierUsername != null) ...[
            const VGap(AppSpacing.xxs),
            AppText.body(
              '${l10n.cashier}: ${item.cashierUsername}',
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
