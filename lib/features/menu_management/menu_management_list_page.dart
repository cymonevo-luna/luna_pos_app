import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/navigation_config.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lazy_shell_tab_loader.dart';

/// Placeholder list screen for menu management. Full UI lands in a follow-up task.
class MenuManagementListPage extends ConsumerWidget {
  const MenuManagementListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return LazyShellTabLoader(
      branch: ShellBranch.manageMenus,
      onVisible: (_) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.manageMenus),
        ),
      ),
    );
  }
}
