import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Placeholder create screen for menu management.
class MenuManagementFormPage extends StatelessWidget {
  const MenuManagementFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).manageMenus),
      ),
    );
  }
}

/// Placeholder edit screen for menu management.
class MenuManagementEditPage extends StatelessWidget {
  const MenuManagementEditPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).manageMenus),
      ),
    );
  }
}
