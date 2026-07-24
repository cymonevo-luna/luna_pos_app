import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/navigation_config.dart';
import '../../core/router/shell_branch_provider.dart';
import '../../features/auth/auth_controller.dart';
import '../../l10n/app_localizations.dart';

/// Shell scaffold for the bottom-navigation tabs. Backed by
/// [StatefulShellRoute.indexedStack], so each tab is built exactly once and
/// kept alive — switching tabs swaps the active branch instead of pushing a new
/// page, which avoids growing the navigation stack.
class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onSelected(
    WidgetRef ref,
    List<int> visibleBranches,
    int visibleIndex,
  ) {
    final branchIndex = visibleBranches[visibleIndex];
    ref.read(shellCurrentBranchProvider.notifier).setBranch(branchIndex);
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authProvider.select((s) => s.user));
    final visibleBranches = visibleShellBranches(user);
    final wideLayout = MediaQuery.sizeOf(context).width >= 600;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(shellCurrentBranchProvider.notifier)
          .setBranch(navigationShell.currentIndex);
    });

    final destinations = <NavigationDestination>[];
    for (final branch in visibleBranches) {
      destinations.add(_destinationForBranch(branch, l10n));
    }

    var selectedIndex = visibleBranches.indexOf(navigationShell.currentIndex);
    if (selectedIndex < 0) selectedIndex = 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _onSelected(ref, visibleBranches, index),
        labelBehavior: wideLayout
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: destinations,
      ),
    );
  }

  NavigationDestination _destinationForBranch(
    int branch,
    AppLocalizations l10n,
  ) {
    return switch (branch) {
      0 => NavigationDestination(
          icon: const Icon(Icons.restaurant_menu_outlined),
          selectedIcon: const Icon(Icons.restaurant_menu),
          label: l10n.menu,
        ),
      1 => NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long),
          label: l10n.transactionHistory,
        ),
      2 => NavigationDestination(
          icon: const Icon(Icons.lunch_dining_outlined),
          selectedIcon: const Icon(Icons.lunch_dining),
          label: l10n.deliveries,
        ),
      3 => NavigationDestination(
          icon: const Icon(Icons.inventory_2_outlined),
          selectedIcon: const Icon(Icons.inventory_2),
          label: l10n.stock,
        ),
      4 => NavigationDestination(
          icon: const Icon(Icons.shopping_cart_outlined),
          selectedIcon: const Icon(Icons.shopping_cart),
          label: l10n.purchases,
        ),
      5 => NavigationDestination(
          icon: const Icon(Icons.payments_outlined),
          selectedIcon: const Icon(Icons.payments),
          label: l10n.expensesTitle,
        ),
      6 => NavigationDestination(
          icon: const Icon(Icons.event_repeat_outlined),
          selectedIcon: const Icon(Icons.event_repeat),
          label: l10n.recurringExpensesTitle,
        ),
      7 => NavigationDestination(
          icon: const Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: const Icon(Icons.account_balance_wallet),
          label: l10n.cashierBalanceTitle,
        ),
      8 => NavigationDestination(
          icon: const Icon(Icons.delete_outline),
          selectedIcon: const Icon(Icons.delete),
          label: l10n.disposeFoodTitle,
        ),
      9 => NavigationDestination(
          icon: const Icon(Icons.edit_note_outlined),
          selectedIcon: const Icon(Icons.edit_note),
          label: l10n.manageMenus,
        ),
      10 => NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      _ => NavigationDestination(
          icon: const Icon(Icons.help_outline),
          label: l10n.profile,
        ),
    };
  }
}

/// Hosts the branch navigators (like an [IndexedStack], so every tab stays
/// alive) but slides horizontally when the active tab changes — left/right
/// depending on the direction of travel.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 1,
  );

  late int _currentIndex;
  late int _previousIndex;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = widget.currentIndex;
      _direction = _currentIndex > _previousIndex ? 1 : -1;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animating = !_controller.isCompleted;
        final t = Curves.easeInOut.transform(_controller.value);

        final background = <Widget>[];
        Widget? outgoing;
        Widget? incoming;

        for (var i = 0; i < widget.children.length; i++) {
          // Branch navigators keep their own GlobalKeys, so moving them between
          // Offstage/SlideTransition wrappers preserves their state.
          final child = widget.children[i];
          final isCurrent = i == _currentIndex;
          final isPrevious =
              i == _previousIndex && animating && _previousIndex != _currentIndex;

          if (isCurrent) {
            incoming = FractionalTranslation(
              translation: Offset((1 - t) * _direction, 0),
              child: child,
            );
          } else if (isPrevious) {
            outgoing = FractionalTranslation(
              translation: Offset(-t * _direction, 0),
              child: child,
            );
          } else {
            background.add(
              Offstage(child: TickerMode(enabled: false, child: child)),
            );
          }
        }

        return IgnorePointer(
          ignoring: animating,
          child: Stack(
            children: [
              ...background,
              ?outgoing,
              ?incoming,
            ],
          ),
        );
      },
    );
  }
}
