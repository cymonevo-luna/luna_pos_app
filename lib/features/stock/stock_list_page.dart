import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../placeholder/coming_soon_page.dart';

/// Stock management list screen (procurement shell tab).
class StockListPage extends StatelessWidget {
  const StockListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ComingSoonPage(
      title: l10n.stock,
      icon: Icons.inventory_2_outlined,
    );
  }
}
