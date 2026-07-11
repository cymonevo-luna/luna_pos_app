import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'menu_controller.dart';
import 'models/pos_menu.dart';
import 'widgets/menu_item_card.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardAuth());
  }

  void _guardAuth() {
    final authed = ref.read(authProvider).isAuthenticated;
    if (!authed && mounted) {
      context.goNamed(AppRoute.login.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider.select((s) => s.isAuthenticated), (previous, next) {
      if (!next && mounted) context.goNamed(AppRoute.login.name);
    });

    final l10n = AppLocalizations.of(context);
    final menu = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menu),
        actions: [
          IconButton(
            tooltip: l10n.refreshMenu,
            onPressed: menu.loading || menu.refreshing
                ? null
                : () => ref.read(menuProvider.notifier).refresh(),
            icon: menu.refreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _MenuBody(
        state: menu,
        onRetry: () => ref.read(menuProvider.notifier).retry(),
        onRefresh: () => ref.read(menuProvider.notifier).refresh(),
        onToggle: (item) => ref.read(menuProvider.notifier).toggleSelection(item),
        emptyLabel: l10n.noMenuItemsAvailable,
        retryLabel: l10n.retry,
      ),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.state,
    required this.onRetry,
    required this.onRefresh,
    required this.onToggle,
    required this.emptyLabel,
    required this.retryLabel,
  });

  final MenuState state;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final void Function(POSMenuItem item) onToggle;
  final String emptyLabel;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.data == null) {
      return _MenuErrorView(
        message: state.error!,
        retryLabel: retryLabel,
        onRetry: onRetry,
      );
    }

    if (state.isEmpty) {
      return _MenuEmptyView(
        message: emptyLabel,
        onRefresh: onRefresh,
      );
    }

    final data = state.data!;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900
              ? 4
              : width >= 600
                  ? 3
                  : 2;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              for (final category in data.categories) ...[
                if (category.menus.isNotEmpty) ...[
                  AppSectionHeader(title: category.name),
                  const VGap(AppSpacing.sm),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.menus.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final item = category.menus[index];
                      return MenuItemCard(
                        item: item,
                        selected: state.selectedItemId == item.id,
                        onTap: () => onToggle(item),
                      );
                    },
                  ),
                  const VGap(AppSpacing.lg),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MenuErrorView extends StatelessWidget {
  const _MenuErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const VGap(AppSpacing.md),
            AppText.body(message, align: TextAlign.center),
            const VGap(AppSpacing.lg),
            AppButton(retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _MenuEmptyView extends StatelessWidget {
  const _MenuEmptyView({
    required this.message,
    required this.onRefresh,
  });

  final String message;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppText.body(message, align: TextAlign.center, muted: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
