/// Bridges [ApiClient] 401/403 handling to the Riverpod [AuthController].
class SessionGuard {
  Future<void> Function()? onExpired;

  Future<void> notifyExpired() async {
    await onExpired?.call();
  }
}
