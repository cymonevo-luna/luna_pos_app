import 'package:flutter/material.dart';

import '../../../core/utils/photo_url_resolver.dart';

/// Network menu photo with bundled default-food fallback on missing URL or load failure.
class MenuPhoto extends StatelessWidget {
  const MenuPhoto({super.key, this.photoUrl});

  static const defaultAsset = 'assets/images/default_food.png';

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final resolved = resolvePhotoUrl(photoUrl);
    if (resolved.isEmpty) {
      return Image.asset(
        defaultAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Image.network(
      resolved,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Image.asset(
        defaultAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
