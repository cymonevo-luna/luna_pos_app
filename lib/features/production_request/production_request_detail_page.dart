import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'models/production_request.dart';
import 'production_request_controller.dart';

class ProductionRequestDetailPage extends ConsumerWidget {
  const ProductionRequestDetailPage({super.key, required this.requestId});

  final String requestId;

  Future<void> _confirmDelivery(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final success = await ref
        .read(productionRequestDetailProvider(requestId).notifier)
        .markDone();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deliveryConfirmed)),
      );
      ref.invalidate(productionRequestListProvider);
      context.pop();
      return;
    }

    final error =
        ref.read(productionRequestDetailProvider(requestId)).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(productionRequestDetailProvider(requestId));
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productionDeliveryDetail)),
      body: _ProductionRequestDetailBody(
        state: state,
        dateFormat: dateFormat,
        onRetry: () => ref
            .read(productionRequestDetailProvider(requestId).notifier)
            .retry(),
        onLogout: () async {
          await ref.read(authProvider.notifier).logout();
          if (!context.mounted) return;
          context.goNamed(AppRoute.login.name);
        },
        onConfirm: state.detail?.status == ProductionRequestStatus.readyToPick
            ? () => _confirmDelivery(context, ref, l10n)
            : null,
        retryLabel: l10n.retry,
        notAuthorizedTitle: l10n.notAuthorized,
        notAuthorizedMessage: l10n.notAuthorizedMessage,
        logoutLabel: l10n.logout,
        confirmLabel: l10n.confirmDelivery,
      ),
    );
  }
}

class _ProductionRequestDetailBody extends StatelessWidget {
  const _ProductionRequestDetailBody({
    required this.state,
    required this.dateFormat,
    required this.onRetry,
    required this.onLogout,
    required this.onConfirm,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
    required this.confirmLabel,
  });

  final ProductionRequestDetailState state;
  final DateFormat dateFormat;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final Future<void> Function()? onConfirm;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;
  final String confirmLabel;

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

    final createdAt = detail.createdAt;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              if (createdAt != null)
                AppCard(
                  child: AppText.body(
                    dateFormat.format(createdAt.toLocal()),
                    muted: true,
                  ),
                ),
              if (createdAt != null) const VGap(AppSpacing.lg),
              AppSectionHeader(title: l10n.productionDeliveryItems),
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
              if (detail.notes != null && detail.notes!.trim().isNotEmpty) ...[
                const VGap(AppSpacing.lg),
                AppSectionHeader(title: l10n.noteLabel),
                const VGap(AppSpacing.sm),
                AppCard(
                  child: AppText.body(detail.notes!),
                ),
              ],
            ],
          ),
        ),
        if (onConfirm != null)
          SafeArea(
            minimum: const EdgeInsets.all(AppSpacing.md),
            child: AppButton(
              confirmLabel,
              key: const Key('confirm_delivery_button'),
              loading: state.markingDone,
              onPressed: state.markingDone ? null : onConfirm,
            ),
          ),
      ],
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({required this.item});

  final ProductionRequestItem item;

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
            children: [
              Expanded(child: AppText.title(item.menuTitle)),
              AppText.body('${l10n.quantityLabel}: ${item.quantity}'),
            ],
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
