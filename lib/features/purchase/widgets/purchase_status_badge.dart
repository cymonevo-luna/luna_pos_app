import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../models/purchase_request.dart';

class PurchaseStatusBadge extends StatelessWidget {
  const PurchaseStatusBadge({super.key, required this.status});

  final PurchaseRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final colors = context.colors;

    final (label, background, foreground) = switch (status) {
      PurchaseRequestStatus.pending => (
          l10n.purchaseStatusPending,
          colors.surfaceContainerHighest,
          colors.onSurfaceVariant,
        ),
      PurchaseRequestStatus.requested => (
          l10n.purchaseStatusRequested,
          colors.primaryContainer,
          colors.onPrimaryContainer,
        ),
      PurchaseRequestStatus.paid => (
          l10n.purchaseStatusPaid,
          tokens.warning.withValues(alpha: 0.18),
          tokens.warning,
        ),
      PurchaseRequestStatus.delivered => (
          l10n.purchaseStatusDelivered,
          tokens.success.withValues(alpha: 0.18),
          tokens.success,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

String purchaseStatusLabel(
  AppLocalizations l10n,
  PurchaseRequestStatus status,
) =>
    switch (status) {
      PurchaseRequestStatus.pending => l10n.purchaseStatusPending,
      PurchaseRequestStatus.requested => l10n.purchaseStatusRequested,
      PurchaseRequestStatus.paid => l10n.purchaseStatusPaid,
      PurchaseRequestStatus.delivered => l10n.purchaseStatusDelivered,
    };
