import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/formatting/currency_formatter.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'models/purchase_request.dart';
import 'purchase_detail_controller.dart';
import 'utils/whatsapp_contact.dart';
import 'widgets/purchase_proof_ui.dart';
import 'widgets/purchase_status_badge.dart';

class PurchaseDetailPage extends ConsumerStatefulWidget {
  const PurchaseDetailPage({super.key, required this.purchaseId});

  final String purchaseId;

  @override
  ConsumerState<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends ConsumerState<PurchaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(purchaseDetailProvider(widget.purchaseId));
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_jm();

    ref.listen(purchaseDetailProvider(widget.purchaseId), (previous, next) {
      final message = next.error;
      if (message != null && message != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.purchaseDetail)),
      body: Stack(
        children: [
          _PurchaseDetailBody(
            state: state,
            dateFormat: dateFormat,
            onRetry: () => ref
                .read(purchaseDetailProvider(widget.purchaseId).notifier)
                .retry(),
            onLogout: () async {
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) return;
              context.goNamed(AppRoute.login.name);
            },
            onStatusSelected: (status) => _handleStatusSelected(context, status),
            retryLabel: l10n.retry,
            notAuthorizedTitle: l10n.notAuthorized,
            notAuthorizedMessage: l10n.procurementAccessDenied,
            logoutLabel: l10n.logout,
          ),
          if (state.updatingStatus)
            const ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _handleStatusSelected(
    BuildContext context,
    PurchaseRequestStatus status,
  ) async {
    final controller =
        ref.read(purchaseDetailProvider(widget.purchaseId).notifier);
    final current = ref.read(purchaseDetailProvider(widget.purchaseId)).detail;
    if (current == null || current.status == status) return;

    if (controller.statusRequiresProof(status)) {
      final source = await showPurchasePhotoSourceSheet(context);
      if (!context.mounted || source == null) return;
      await controller.updateStatusWithProof(status, source);
      return;
    }

    await controller.updateStatus(status);
  }
}

class _PurchaseDetailBody extends StatelessWidget {
  const _PurchaseDetailBody({
    required this.state,
    required this.dateFormat,
    required this.onRetry,
    required this.onLogout,
    required this.onStatusSelected,
    required this.retryLabel,
    required this.notAuthorizedTitle,
    required this.notAuthorizedMessage,
    required this.logoutLabel,
  });

  final PurchaseDetailState state;
  final DateFormat dateFormat;
  final VoidCallback onRetry;
  final Future<void> Function() onLogout;
  final ValueChanged<PurchaseRequestStatus> onStatusSelected;
  final String retryLabel;
  final String notAuthorizedTitle;
  final String notAuthorizedMessage;
  final String logoutLabel;

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
    if (detail == null) return const SizedBox.shrink();

    return _PurchaseDetailContent(
      detail: detail,
      dateFormat: dateFormat,
      onStatusSelected: onStatusSelected,
    );
  }
}

class _PurchaseDetailContent extends StatelessWidget {
  const _PurchaseDetailContent({
    required this.detail,
    required this.dateFormat,
    required this.onStatusSelected,
  });

  final PurchaseRequestDetail detail;
  final DateFormat dateFormat;
  final ValueChanged<PurchaseRequestStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final createdAt = detail.createdAt;
    final whatsAppPhone = extractWhatsAppPhone(detail.supplierContactInfo);

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppText.title(detail.supplierName)),
                  PurchaseStatusBadge(status: detail.status),
                ],
              ),
              if (detail.supplierContactInfo != null &&
                  detail.supplierContactInfo!.trim().isNotEmpty) ...[
                const VGap(AppSpacing.xs),
                AppText.body(detail.supplierContactInfo!, muted: true),
              ],
              const VGap(AppSpacing.sm),
              AppButton(
                l10n.purchaseContactSupplier,
                icon: Icons.chat_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: whatsAppPhone != null
                    ? () => _openWhatsApp(detail, whatsAppPhone)
                    : null,
              ),
            ],
          ),
        ),
        const VGap(AppSpacing.md),
        _PurchaseTotalsSection(
          detail: detail,
          dateFormat: dateFormat,
          createdAt: createdAt,
        ),
        if (detail.createdByUsername != null) ...[
          const VGap(AppSpacing.sm),
          AppText.body(
            '${l10n.purchaseCreatedBy}: ${detail.createdByUsername}',
            muted: true,
          ),
        ],
        const VGap(AppSpacing.lg),
        AppSectionHeader(title: l10n.purchaseUpdateStatus),
        const VGap(AppSpacing.sm),
        _StatusDropdown(
          key: ValueKey(detail.status),
          status: detail.status,
          onChanged: onStatusSelected,
        ),
        const VGap(AppSpacing.lg),
        if (detail.paidProofUrl != null || detail.deliveredProofUrl != null) ...[
          AppSectionHeader(title: l10n.purchaseProofPhotos),
          const VGap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              if (detail.paidProofUrl != null)
                PurchaseProofThumbnail(
                  label: l10n.purchaseProofPaid,
                  proofUrl: detail.paidProofUrl!,
                  onTap: () => showPurchaseProofViewer(
                    context,
                    proofUrl: detail.paidProofUrl!,
                    title: l10n.purchaseProofPaid,
                  ),
                ),
              if (detail.deliveredProofUrl != null)
                PurchaseProofThumbnail(
                  label: l10n.purchaseProofDelivered,
                  proofUrl: detail.deliveredProofUrl!,
                  onTap: () => showPurchaseProofViewer(
                    context,
                    proofUrl: detail.deliveredProofUrl!,
                    title: l10n.purchaseProofDelivered,
                  ),
                ),
            ],
          ),
          const VGap(AppSpacing.lg),
        ],
        AppSectionHeader(title: l10n.purchaseLineItems),
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
    );
  }

  Future<void> _openWhatsApp(
    PurchaseRequestDetail detail,
    String phone,
  ) async {
    final url = Uri.parse(
      buildWhatsAppUrl(phone, buildPurchaseWhatsAppMessage(detail)),
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open WhatsApp');
    }
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    super.key,
    required this.status,
    required this.onChanged,
  });

  final PurchaseRequestStatus status;
  final ValueChanged<PurchaseRequestStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: l10n.purchaseUpdateStatus,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PurchaseRequestStatus>(
          key: const Key('purchase_status_dropdown'),
          isExpanded: true,
          value: status,
          items: PurchaseRequestStatus.values
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(purchaseStatusLabel(l10n, value)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}

class _PurchaseTotalsSection extends StatelessWidget {
  const _PurchaseTotalsSection({
    required this.detail,
    required this.dateFormat,
    required this.createdAt,
  });

  final PurchaseRequestDetail detail;
  final DateFormat dateFormat;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actualAmount = detail.totalActualAmount;
    final estimatedAmount = detail.totalEstimatedAmount ?? 0;
    final hasActual = actualAmount != null;
    final showEstimatedSecondary = hasActual &&
        estimatedAmount != 0 &&
        estimatedAmount != actualAmount;
    final displayAmount = actualAmount ?? estimatedAmount;
    final at = createdAt;
    final createdAtLabel =
        at == null ? '—' : dateFormat.format(at.toLocal());

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppStatCard(
                icon: hasActual
                    ? Icons.price_check_outlined
                    : Icons.payments_outlined,
                color: hasActual
                    ? context.colors.tertiary
                    : context.colors.primary,
                value: formatRupiah(displayAmount),
                label: hasActual
                    ? l10n.purchaseActualTotal
                    : l10n.purchaseEstimatedTotal,
              ),
            ),
            const HGap(AppSpacing.sm),
            Expanded(
              child: AppStatCard(
                icon: Icons.schedule_outlined,
                color: context.colors.secondary,
                value: createdAtLabel,
                label: l10n.purchaseCreatedAt,
              ),
            ),
          ],
        ),
        if (showEstimatedSecondary) ...[
          const VGap(AppSpacing.sm),
          AppStatCard(
            icon: Icons.payments_outlined,
            color: context.colors.primary,
            value: formatRupiah(estimatedAmount),
            label: l10n.purchaseEstimatedTotal,
          ),
        ],
      ],
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({required this.item});

  final PurchaseRequestItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unitLabel = item.unit?.trim();
    final quantityLabel = unitLabel != null && unitLabel.isNotEmpty
        ? '${item.quantity} $unitLabel'
        : '${item.quantity}';

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
              Expanded(
                child: AppText.title(item.foodSupplyTitle ?? item.foodSupplyId),
              ),
              _LineItemAmounts(item: item),
            ],
          ),
          const VGap(AppSpacing.xxs),
          AppText.caption(
            '${l10n.quantityLabel}: $quantityLabel'
            '${item.unitPrice != null ? ' · ${l10n.unitPrice}: ${formatRupiah(item.unitPrice!.round())}' : ''}',
          ),
        ],
      ),
    );
  }
}

class _LineItemAmounts extends StatelessWidget {
  const _LineItemAmounts({required this.item});

  final PurchaseRequestItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actualAmount = item.lineActualAmount;
    final estimatedAmount = item.lineEstimatedAmount;

    if (actualAmount != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText.title(formatRupiah(actualAmount)),
          if (estimatedAmount != null && estimatedAmount != actualAmount)
            AppText.caption(
              '${l10n.purchaseEstimatedTotal}: ${formatRupiah(estimatedAmount)}',
            ),
        ],
      );
    }

    if (estimatedAmount != null) {
      return AppText.title(formatRupiah(estimatedAmount));
    }

    return const SizedBox.shrink();
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
