import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../placeholder/coming_soon_page.dart';

/// Purchase orders list screen (procurement shell tab).
class PurchasesListPage extends StatelessWidget {
  const PurchasesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ComingSoonPage(
      title: l10n.purchases,
      icon: Icons.shopping_cart_outlined,
    );
  }
}
