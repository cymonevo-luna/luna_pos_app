import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/router/navigation_config.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';
import '../../shared/widgets/widgets.dart';
import 'cashier_balance_adjust_sheet.dart';
import 'cashier_balance_controller.dart';
import 'models/cashier_balance.dart';

class CashierBalancePage extends ConsumerStatefulWidget {
  const CashierBalancePage({super.key});

  @override
  ConsumerState<CashierBalancePage> createState() => _CashierBalancePageState();
}

class _CashierBalancePageState extends ConsumerState<CashierBalancePage> {
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
      ref.read(cashierBalanceController.notifier).loadMore();
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  Future<void> _openAdjust(CashierBalanceAdjustmentType type) async {
    await CashierBalanceAdjustSheet.show(context, type: type);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(cashierBalanceController);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return LazyShellTabLoader(
      branch: ShellBranch.cashierBalance,
      onVisible: (ref) =>
          ref.read(cashierBalanceController.notifier).loadIfNeeded(),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.cashierBalanceTitle),
        actions: [
          IconButton(
            key: const Key('cashier_balance_add_button'),
            tooltip: l10n.cashierBalanceAdd,
            onPressed: state.submitting
                ? null
                : () => _openAdjust(CashierBalanceAdjustmentType.add),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            key: const Key('cashier_balance_deduct_button'),
            tooltip: l10n.cashierBalanceDeduct,
            onPressed: state.submitting
                ? null
                : () => _openAdjust(CashierBalanceAdjustmentType.deduct),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: _BalanceCard(
              loading: state.loading && state.balance == null,
              balance: state.balance?.balance,
              label: l10n.cashierBalanceCurrent,
            ),
          ),
          Padding(
            padding: AppSpacing.screenPadding.copyWith(top: 0, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppText.title(l10n.cashierBalanceHistory),
            ),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _CashierBalanceHistoryBody(
              state: state,
              dateFormat: dateFormat,
              onRefresh: () =>
                  ref.read(cashierBalanceController.notifier).refresh(),
              onRetry: () =>
                  ref.read(cashierBalanceController.notifier).retry(),
              onLogout: _logout,
              emptyLabel: l10n.cashierBalanceNoEntries,
              retryLabel: l10n.retry,
              notAuthorizedTitle: l10n.notAuthorized,
              notAuthorizedMessage: l10n.cashierBalanceAccessDenied,
              logoutLabel: l10n.logout,
              requestedByLabel: l10n.cashierBalanceRequestedBy,
              transactionLabel: l10n.cashierBalanceTransaction,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.loading,
    required this.balance,
    required this.label,
  });

  final bool loading;
  final int? balance;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('cashier_balance_card'),
      child: loading
          ? const SizedBox(
              height: 72,
              child: Center(child: CircularProgressIndicator()),
            )
          : AppStatCard(
              icon: Icons.account_balance_wallet_outlined,
              color: context.colors.primary,
              value: formatRupiah(balance ?? 0),
              label: label,
            ),
    );
  }
}

class _CashierBalanceHistoryBody extends StatelessWidget {
  const _CashierBalanceHistoryBody({
    required this.state,
    required this.dateFormat,
    required this.onRefresh,
    required this.onRetry,
    required this.onLogout,
    required this.emptyLabel,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
    required this.requestedByLabel,
    required this.transactionLabel,
    required this.scrollController,
  });

  final CashierBalanceState state;
  final DateFormat dateFormat;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final String emptyLabel;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;
  final String requestedByLabel;
  final String transactionLabel;
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

    if (state.error != null && state.entries.isEmpty) {
      return _ErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    if (state.entries.isEmpty) {
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
        itemCount: state.entries.length + (state.loadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const VGap(AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index >= state.entries.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _CashierBalanceEntryCard(
            entry: state.entries[index],
            dateFormat: dateFormat,
            requestedByLabel: requestedByLabel,
            transactionLabel: transactionLabel,
          );
        },
      ),
    );
  }
}

class _CashierBalanceEntryCard extends StatelessWidget {
  const _CashierBalanceEntryCard({
    required this.entry,
    required this.dateFormat,
    required this.requestedByLabel,
    required this.transactionLabel,
  });

  final CashierBalanceEntry entry;
  final DateFormat dateFormat;
  final String requestedByLabel;
  final String transactionLabel;

  @override
  Widget build(BuildContext context) {
    final signedAmount = entry.signedAmount;
    final amountColor =
        signedAmount >= 0 ? context.tokens.success : context.tokens.danger;
    final amountPrefix = signedAmount >= 0 ? '+' : '-';
    final transactionId = entry.transactionId;

    return AppCard(
      key: Key('cashier_balance_entry_${entry.id}'),
      onTap: transactionId != null && transactionId.isNotEmpty
          ? () => context.pushNamed(
                AppRoute.transactionDetail.name,
                pathParameters: {'id': transactionId},
              )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText.body(
                  dateFormat.format(entry.createdAt.toLocal()),
                  muted: true,
                ),
              ),
              AppText.body(
                '$amountPrefix${formatRupiah(signedAmount.abs())}',
                color: amountColor,
                weight: FontWeight.w600,
              ),
            ],
          ),
          const VGap(AppSpacing.xs),
          AppText.title(entry.purpose),
          if (entry.requestedByUsername != null &&
              entry.requestedByUsername!.isNotEmpty) ...[
            const VGap(AppSpacing.xs),
            AppText.body(
              '$requestedByLabel ${entry.requestedByUsername}',
              muted: true,
            ),
          ],
          if (transactionId != null && transactionId.isNotEmpty) ...[
            const VGap(AppSpacing.xs),
            AppText.body(
              '$transactionLabel $transactionId',
              color: context.colors.primary,
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
