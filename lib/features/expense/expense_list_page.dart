import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/di/locator.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/expense_repository.dart';
import 'expense_form_sheet.dart';
import 'expense_list_controller.dart';
import 'models/expense.dart';

/// Paginated expense list for operational and manager users.
class ExpenseListPage extends ConsumerStatefulWidget {
  const ExpenseListPage({super.key});

  @override
  ConsumerState<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends ConsumerState<ExpenseListPage> {
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
      ref.read(expenseListProvider.notifier).loadMore();
    }
  }

  Future<void> _openCreate() async {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await ExpenseFormSheet.show(context);
      return;
    }
    await context.pushNamed(AppRoute.expensesNew.name);
  }

  Future<void> _openEdit(Expense expense) async {
    Expense detail = expense;
    try {
      detail = await locator<ExpenseRepository>().fetchExpense(expense.id);
    } catch (_) {
      // Fall back to list item when detail fetch fails.
    }

    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      await ExpenseFormSheet.show(context, existing: detail);
      return;
    }
    await context.pushNamed(
      AppRoute.expensesEdit.name,
      pathParameters: {'id': expense.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(expenseListProvider);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expensesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('expense_add_fab'),
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: Text(l10n.createExpense),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding.copyWith(bottom: 0),
            child: TextField(
              key: const Key('expense_search_field'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchExpenses,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(expenseListProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: ref.read(expenseListProvider.notifier).setSearch,
            ),
          ),
          const VGap(AppSpacing.sm),
          Expanded(
            child: _ExpenseListBody(
              state: state,
              dateFormat: dateFormat,
              onRefresh: () => ref.read(expenseListProvider.notifier).refresh(),
              onRetry: () => ref.read(expenseListProvider.notifier).retry(),
              onTap: _openEdit,
              emptyLabel: l10n.noExpenses,
              retryLabel: l10n.retry,
              notAuthorizedTitle: l10n.notAuthorized,
              notAuthorizedMessage: l10n.procurementAccessDenied,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseListBody extends StatelessWidget {
  const _ExpenseListBody({
    required this.state,
    required this.dateFormat,
    required this.onRefresh,
    required this.onRetry,
    required this.onTap,
    required this.emptyLabel,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.scrollController,
  });

  final ExpenseListState state;
  final DateFormat dateFormat;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final void Function(Expense expense) onTap;
  final String emptyLabel;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (state.forbidden) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.title(notAuthorizedTitle, align: TextAlign.center),
              const VGap(AppSpacing.sm),
              AppText.body(
                state.error ?? notAuthorizedMessage,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.body(state.error!, align: TextAlign.center),
              const VGap(AppSpacing.lg),
              AppButton(retryLabel, onPressed: onRetry),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Center(child: AppText.body(emptyLabel)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        key: const Key('expense_list'),
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
          final expense = state.items[index];
          return _ExpenseCard(
            expense: expense,
            dateFormat: dateFormat,
            onTap: () => onTap(expense),
          );
        },
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.expense,
    required this.dateFormat,
    required this.onTap,
  });

  final Expense expense;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reportingDate = expense.createdAt;

    return AppCard(
      key: Key('expense_card_${expense.id}'),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(expense.title),
                if (expense.description?.isNotEmpty ?? false) ...[
                  const VGap(AppSpacing.xs),
                  AppText.body(
                    expense.description!,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
                if (reportingDate != null) ...[
                  const VGap(AppSpacing.xs),
                  AppText.label(
                    dateFormat.format(reportingDate.toLocal()),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
          const HGap(AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText.title(formatRupiah(expense.amount)),
              const VGap(AppSpacing.xs),
              AppText.label(
                expense.sourceOfFund == ExpenseSourceOfFund.cashier
                    ? l10n.expenseSourceCashier
                    : l10n.expenseSourcePersonalMoney,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
