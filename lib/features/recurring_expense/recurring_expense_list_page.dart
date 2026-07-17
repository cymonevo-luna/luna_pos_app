import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/di/locator.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/recurring_expense_repository.dart';
import 'models/recurring_expense.dart';
import 'recurring_expense_form_sheet.dart';
import 'recurring_expense_list_controller.dart';
import 'widgets/schedule_summary_chip.dart';

/// Paginated recurring-expense list for operational and manager users.
class RecurringExpenseListPage extends ConsumerStatefulWidget {
  const RecurringExpenseListPage({super.key});

  @override
  ConsumerState<RecurringExpenseListPage> createState() =>
      _RecurringExpenseListPageState();
}

class _RecurringExpenseListPageState
    extends ConsumerState<RecurringExpenseListPage> {
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
      ref.read(recurringExpenseListProvider.notifier).loadMore();
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
      await RecurringExpenseFormSheet.show(context);
      return;
    }
    await context.pushNamed(AppRoute.recurringExpensesNew.name);
  }

  Future<void> _openEdit(RecurringExpense expense) async {
    RecurringExpense detail = expense;
    try {
      detail = await locator<RecurringExpenseRepository>()
          .fetchRecurringExpense(expense.id);
    } catch (_) {
      // Fall back to list item when detail fetch fails.
    }

    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await RecurringExpenseFormSheet.show(context, existing: detail);
      return;
    }
    await context.pushNamed(
      AppRoute.recurringExpensesEdit.name,
      pathParameters: {'id': expense.id},
    );
  }

  Future<void> _confirmDelete(RecurringExpense expense) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecurringExpense),
        content: Text(l10n.deleteRecurringExpenseConfirm(expense.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(recurringExpenseListProvider.notifier)
          .deleteExpense(expense.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteRecurringExpenseFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(recurringExpenseListProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recurringExpensesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('recurring_expense_add_fab'),
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: Text(l10n.createRecurringExpense),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding.copyWith(bottom: 0),
            child: TextField(
              key: const Key('recurring_expense_search_field'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchRecurringExpenses,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(recurringExpenseListProvider.notifier)
                              .setSearch('');
                        },
                      )
                    : null,
              ),
              onChanged:
                  ref.read(recurringExpenseListProvider.notifier).setSearch,
            ),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _RecurringExpenseListBody(
              state: state,
              isWide: isWide,
              onRefresh: () =>
                  ref.read(recurringExpenseListProvider.notifier).refresh(),
              onRetry: () =>
                  ref.read(recurringExpenseListProvider.notifier).retry(),
              onLogout: _logout,
              onTap: _openEdit,
              onDelete: _confirmDelete,
              emptyLabel: l10n.noRecurringExpenses,
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

class _RecurringExpenseListBody extends StatelessWidget {
  const _RecurringExpenseListBody({
    required this.state,
    required this.isWide,
    required this.onRefresh,
    required this.onRetry,
    required this.onLogout,
    required this.onTap,
    required this.onDelete,
    required this.emptyLabel,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
    required this.scrollController,
  });

  final RecurringExpenseListState state;
  final bool isWide;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(RecurringExpense expense) onTap;
  final void Function(RecurringExpense expense) onDelete;
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
                childAspectRatio: 2.2,
              ),
              itemCount: state.items.length + (state.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _RecurringExpenseCard(
                  expense: state.items[index],
                  onTap: () => onTap(state.items[index]),
                  onDelete: () => onDelete(state.items[index]),
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
                return _RecurringExpenseCard(
                  expense: state.items[index],
                  onTap: () => onTap(state.items[index]),
                  onDelete: () => onDelete(state.items[index]),
                );
              },
            ),
    );
  }
}

class _RecurringExpenseCard extends StatelessWidget {
  const _RecurringExpenseCard({
    required this.expense,
    required this.onTap,
    required this.onDelete,
  });

  final RecurringExpense expense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Dismissible(
      key: Key('recurring_expense_dismiss_${expense.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: context.colors.error.withValues(alpha: 0.15),
        child: Icon(Icons.delete_outline, color: context.colors.error),
      ),
      child: AppCard(
        key: Key('recurring_expense_card_${expense.id}'),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: AppText.title(expense.title)),
                      if (!expense.isActive)
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.xs),
                          child: Text(
                            l10n.inactive,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: context.colors.error),
                          ),
                        ),
                    ],
                  ),
                  if (expense.description != null &&
                      expense.description!.isNotEmpty) ...[
                    const VGap(AppSpacing.xs),
                    AppText.body(
                      expense.description!,
                      muted: true,
                      maxLines: 2,
                    ),
                  ],
                  const VGap(AppSpacing.sm),
                  AppText.body(
                    formatRupiah(expense.amount),
                    color: context.colors.primary,
                    weight: FontWeight.w600,
                  ),
                  const VGap(AppSpacing.sm),
                  ScheduleSummaryChip(
                    schedule: expense.recurring,
                    isActive: expense.isActive,
                  ),
                  if (expense.nextRunAt != null) ...[
                    const VGap(AppSpacing.xs),
                    AppText.body(
                      '${l10n.nextRunAt}: ${dateFormat.format(expense.nextRunAt!.toLocal())}',
                      muted: true,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              key: Key('recurring_expense_delete_${expense.id}'),
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
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
