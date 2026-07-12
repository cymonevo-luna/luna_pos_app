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
import 'models/transaction.dart';
import 'transaction_detail_controller.dart';

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(transactionDetailProvider(transactionId));
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionDetails)),
      body: _TransactionDetailBody(
        state: state,
        dateFormat: dateFormat,
        paymentMethodLabel: _paymentMethodLabel(l10n, state.detail?.method),
        onRetry: () =>
            ref.read(transactionDetailProvider(transactionId).notifier).retry(),
        onLogout: () async {
          await ref.read(authProvider.notifier).logout();
          if (!context.mounted) return;
          context.goNamed(AppRoute.login.name);
        },
        retryLabel: l10n.retry,
        notAuthorizedTitle: l10n.notAuthorized,
        notAuthorizedMessage: l10n.notAuthorizedMessage,
        logoutLabel: l10n.logout,
      ),
    );
  }

  String _paymentMethodLabel(AppLocalizations l10n, String? method) {
    if (method == null) return '—';
    return switch (method.toUpperCase()) {
      'OFFLINE' => l10n.paymentMethodOffline,
      _ => method,
    };
  }
}

class _TransactionDetailBody extends StatelessWidget {
  const _TransactionDetailBody({
    required this.state,
    required this.dateFormat,
    required this.paymentMethodLabel,
    required this.onRetry,
    required this.onLogout,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
  });

  final TransactionDetailState state;
  final DateFormat dateFormat;
  final String paymentMethodLabel;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (state.forbidden) {
      return _ForbiddenView(
        title: notAuthorizedTitle,
        message: state.error ?? notAuthorizedMessage,
        logoutLabel: logoutLabel,
        onLogout: onLogout,
      );
    }

    if (state.loading && state.detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.detail == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.error),
              const VGap(AppSpacing.md),
              AppText.body(state.error!, align: TextAlign.center),
              const VGap(AppSpacing.lg),
              AppButton(retryLabel, onPressed: onRetry),
            ],
          ),
        ),
      );
    }

    final detail = state.detail;
    if (detail == null) {
      return const SizedBox.shrink();
    }

    final occurredAt = detail.occurredAt;

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (occurredAt != null)
                AppText.body(dateFormat.format(occurredAt.toLocal())),
              const VGap(AppSpacing.xs),
              AppText.body('${l10n.paymentMethod}: $paymentMethodLabel', muted: true),
              if (detail.cashierUsername != null) ...[
                const VGap(AppSpacing.xxs),
                AppText.body(
                  '${l10n.cashier}: ${detail.cashierUsername}',
                  muted: true,
                ),
              ],
            ],
          ),
        ),
        const VGap(AppSpacing.lg),
        AppSectionHeader(title: l10n.checkout),
        const VGap(AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (final item in detail.items) ...[
                _LineItemRow(item: item),
                if (item != detail.items.last) const Divider(),
              ],
            ],
          ),
        ),
        const VGap(AppSpacing.lg),
        AppCard(
          child: Column(
            children: [
              _TotalRow(label: l10n.subtotal, amount: detail.subtotalAmount),
              const VGap(AppSpacing.sm),
              _TotalRow(label: l10n.discount, amount: detail.discountAmount),
              const VGap(AppSpacing.sm),
              _TotalRow(
                label: l10n.total,
                amount: detail.amount,
                emphasized: true,
              ),
              if (detail.cashTendered != null) ...[
                const VGap(AppSpacing.sm),
                _TotalRow(
                  label: l10n.cashReceived,
                  amount: detail.cashTendered!,
                ),
              ],
              const VGap(AppSpacing.sm),
              _TotalRow(
                label: l10n.change,
                amount: detail.changeAmount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({required this.item});

  final TransactionItemRequest item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: AppText.title(item.title)),
              AppText.title(formatRupiah(item.lineTotal)),
            ],
          ),
          const VGap(AppSpacing.xxs),
          AppText.caption(
            '${l10n.quantityLabel}: ${item.quantity} · ${l10n.unitPrice}: ${formatRupiah(item.unitPrice)}',
          ),
          if (item.note != null && item.note!.trim().isNotEmpty) ...[
            const VGap(AppSpacing.xxs),
            AppText.caption('${l10n.noteLabel}: ${item.note}'),
          ],
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.amount,
    this.emphasized = false,
  });

  final String label;
  final int amount;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: emphasized
              ? AppText.title(label, weight: FontWeight.w700)
              : AppText.body(label),
        ),
        emphasized
            ? AppText.title(
                formatRupiah(amount),
                color: context.colors.primary,
                weight: FontWeight.w700,
              )
            : AppText.body(formatRupiah(amount)),
      ],
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
