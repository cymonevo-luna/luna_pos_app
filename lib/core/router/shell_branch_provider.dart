import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the active [StatefulShellRoute] branch index so tab screens can defer
/// API loads until their branch is visible.
class ShellBranchNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setBranch(int index) {
    if (state != index) {
      state = index;
    }
  }
}

final shellCurrentBranchProvider =
    NotifierProvider<ShellBranchNotifier, int>(ShellBranchNotifier.new);
