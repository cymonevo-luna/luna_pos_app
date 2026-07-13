import 'package:flutter/material.dart';

import '../di/locator.dart';
import 'token_refresh_service.dart';

/// Extends the POS session on app resume, cashier activity, and periodic
/// near-expiry checks.
class SessionActivityWatcher extends StatefulWidget {
  const SessionActivityWatcher({super.key, required this.child});

  final Widget child;

  @override
  State<SessionActivityWatcher> createState() => _SessionActivityWatcherState();
}

class _SessionActivityWatcherState extends State<SessionActivityWatcher>
    with WidgetsBindingObserver {
  TokenRefreshService? get _tokenRefresh =>
      locator.isRegistered<TokenRefreshService>()
          ? locator<TokenRefreshService>()
          : null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tokenRefresh?.startPeriodicRefreshCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tokenRefresh?.stopPeriodicRefreshCheck();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tokenRefresh?.refreshOnResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenRefresh = _tokenRefresh;
    if (tokenRefresh == null) return widget.child;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => tokenRefresh.refreshOnActivity(),
      child: widget.child,
    );
  }
}
