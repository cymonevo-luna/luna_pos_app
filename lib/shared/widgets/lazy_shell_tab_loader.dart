import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/navigation_config.dart';
import '../../core/router/shell_branch_provider.dart';

/// Defers [onVisible] until this shell tab branch is active.
class LazyShellTabLoader extends ConsumerStatefulWidget {
  const LazyShellTabLoader({
    super.key,
    required this.branch,
    required this.onVisible,
    required this.child,
  });

  final ShellBranch branch;
  final void Function(WidgetRef ref) onVisible;
  final Widget child;

  @override
  ConsumerState<LazyShellTabLoader> createState() => _LazyShellTabLoaderState();
}

class _LazyShellTabLoaderState extends ConsumerState<LazyShellTabLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerIfVisible());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(shellCurrentBranchProvider, (previous, next) {
      if (previous != next && next == widget.branch.branchIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _triggerIfVisible());
      }
    });

    return widget.child;
  }

  void _triggerIfVisible() {
    if (!mounted) return;
    if (ref.read(shellCurrentBranchProvider) == widget.branch.branchIndex) {
      widget.onVisible(ref);
    }
  }
}
