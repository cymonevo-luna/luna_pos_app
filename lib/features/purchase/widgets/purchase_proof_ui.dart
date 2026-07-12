import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/photo_url_resolver.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import '../purchase_detail_controller.dart';

class PurchaseProofThumbnail extends StatelessWidget {
  const PurchaseProofThumbnail({
    super.key,
    required this.label,
    required this.proofUrl,
    this.onTap,
  });

  final String label;
  final String proofUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolved = resolvePhotoUrl(proofUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.caption(label),
        const VGap(AppSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Image.network(
              resolved,
              key: ValueKey(resolved),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 120,
                height: 120,
                color: context.colors.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showPurchaseProofViewer(
  BuildContext context, {
  required String proofUrl,
  required String title,
}) {
  final resolved = resolvePhotoUrl(proofUrl);
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(child: AppText.title(title)),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          InteractiveViewer(
            child: Image.network(
              resolved,
              fit: BoxFit.contain,
            ),
          ),
          const VGap(AppSpacing.md),
        ],
      ),
    ),
  );
}

Future<PurchasePhotoSource?> showPurchasePhotoSourceSheet(
  BuildContext context,
) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<PurchasePhotoSource>(
    context: context,
    builder: (context) => SafeArea(
      key: const Key('purchase_photo_sheet'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            key: const Key('purchase_take_photo'),
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.purchaseTakePhoto),
            onTap: () =>
                Navigator.of(context).pop(PurchasePhotoSource.camera),
          ),
          ListTile(
            key: const Key('purchase_choose_gallery'),
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.purchaseChooseGallery),
            onTap: () =>
                Navigator.of(context).pop(PurchasePhotoSource.gallery),
          ),
        ],
      ),
    ),
  );
}
