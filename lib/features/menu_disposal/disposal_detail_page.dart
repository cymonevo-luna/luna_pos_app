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
import 'disposal_detail_controller.dart';

class DisposalDetailPage extends ConsumerWidget {
  const DisposalDetailPage({super.key, required this.disposalId});

  final String disposalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(disposalDetailProvider(disposalId));
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.disposalDetailTitle)),
      body: _DisposalDetailBody(
        state: state,
        dateFormat: dateFormat,
        onRetry: () =>
            ref.read(disposalDetailProvider(disposalId).notifier).retry(),
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
}

class _DisposalDetailBody extends StatelessWidget {
  const _DisposalDetailBody({
    required this.state,
    required this.dateFormat,
    required this.onRetry,
    required this.onLogout,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
  });

  final DisposalDetailState state;
  final DateFormat dateFormat;
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 48, color: context.colors.error),
              const VGap(AppSpacing.md),
              AppText.title(notAuthorizedTitle),
              const VGap(AppSpacing.sm),
              AppText.body(
                state.error ?? notAuthorizedMessage,
                align: TextAlign.center,
              ),
              const VGap(AppSpacing.lg),
              AppButton(logoutLabel, icon: Icons.logout, onPressed: onLogout),
            ],
          ),
        ),
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

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.title(detail.menuTitle),
            const VGap(AppSpacing.lg),
            _DetailRow(label: l10n.menu, value: detail.menuTitle),
            _DetailRow(
              label: l10n.disposeFoodQuantity,
              value: '${detail.quantity}',
            ),
            _DetailRow(
              label: l10n.disposalLossAmount,
              value: formatRupiah(detail.lossAmount),
            ),
            _DetailRow(
              label: l10n.disposalDisposedAt,
              value: dateFormat.format(detail.disposedAt.toLocal()),
            ),
            if (detail.disposedByUsername != null)
              _DetailRow(
                label: l10n.disposalDisposedBy,
                value: detail.disposedByUsername!,
              ),
            if (detail.note != null && detail.note!.isNotEmpty)
              _DetailRow(label: l10n.noteLabel, value: detail.note!),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: AppText.body(label, muted: true)),
          Expanded(
            flex: 2,
            child: AppText.body(value, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
