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
import 'disposal_history_controller.dart';
import 'models/menu_disposal.dart';

String truncateDisposalNote(String? note, {int maxLength = 80}) {
  if (note == null || note.isEmpty) return '';
  if (note.length <= maxLength) return note;
  return '${note.substring(0, maxLength)}…';
}

class DisposalHistoryPage extends ConsumerStatefulWidget {
  const DisposalHistoryPage({super.key});

  @override
  ConsumerState<DisposalHistoryPage> createState() =>
      _DisposalHistoryPageState();
}

class _DisposalHistoryPageState extends ConsumerState<DisposalHistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(disposalHistoryProvider.notifier).loadIfNeeded();
    });
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
      ref.read(disposalHistoryProvider.notifier).loadMore();
    }
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();
    final current = ref.read(disposalHistoryProvider).filter;
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
    await ref.read(disposalHistoryProvider.notifier).applyDateFilter(
          dateFrom: picked.start,
          dateTo: picked.end,
        );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.goNamed(AppRoute.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(disposalHistoryProvider);
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.disposalHistoryTitle),
        actions: [
          if (state.filter.hasDateRange)
            IconButton(
              tooltip: l10n.clearDateFilter,
              onPressed: () =>
                  ref.read(disposalHistoryProvider.notifier).clearDateFilter(),
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          IconButton(
            key: const Key('disposal_history_date_filter'),
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
      body: _DisposalHistoryBody(
        state: state,
        dateFormat: dateFormat,
        onRefresh: () => ref.read(disposalHistoryProvider.notifier).refresh(),
        onRetry: () => ref.read(disposalHistoryProvider.notifier).retry(),
        onLogout: _logout,
        onTap: (item) => context.pushNamed(
          AppRoute.disposeFoodDetail.name,
          pathParameters: {'id': item.id},
        ),
        emptyLabel: l10n.disposalHistoryEmpty,
        retryLabel: l10n.retry,
        notAuthorizedTitle: l10n.notAuthorized,
        notAuthorizedMessage: l10n.notAuthorizedMessage,
        logoutLabel: l10n.logout,
        scrollController: _scrollController,
      ),
    );
  }
}

class _DisposalHistoryBody extends StatelessWidget {
  const _DisposalHistoryBody({
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

  final DisposalHistoryState state;
  final DateFormat dateFormat;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final void Function(MenuDisposalListItem item) onTap;
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
          return _DisposalRow(
            item: item,
            dateFormat: dateFormat,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _DisposalRow extends StatelessWidget {
  const _DisposalRow({
    required this.item,
    required this.dateFormat,
    required this.onTap,
  });

  final MenuDisposalListItem item;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final truncatedNote = truncateDisposalNote(item.note);

    return AppCard(
      key: Key('disposal_history_row_${item.id}'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppText.title(item.menuTitle)),
              AppText.title(
                formatRupiah(item.lossAmount),
                color: context.colors.primary,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const VGap(AppSpacing.xs),
          AppText.body(
            '${l10n.disposeFoodQuantity}: ${item.quantity}',
            muted: true,
          ),
          const VGap(AppSpacing.xxs),
          AppText.body(
            '${l10n.disposalDisposedAt}: ${dateFormat.format(item.disposedAt.toLocal())}',
            muted: true,
          ),
          if (item.disposedByUsername != null) ...[
            const VGap(AppSpacing.xxs),
            AppText.body(
              '${l10n.disposalDisposedBy}: ${item.disposedByUsername}',
              muted: true,
            ),
          ],
          if (truncatedNote.isNotEmpty) ...[
            const VGap(AppSpacing.xxs),
            AppText.body(
              '${l10n.noteLabel}: $truncatedNote',
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
