#!/usr/bin/env bash
# Tier-2 device test for POS-91: printer settings Bluetooth scan permission flow.
#
# Revokes BLUETOOTH_SCAN/CONNECT on the host, runs the integration test on the
# shared emulator, and grants permissions while the app requests them.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=lib/flutter-test-env.sh
source "$SCRIPT_DIR/lib/flutter-test-env.sh"

resolve_flutter_bin || {
  _flutter_test_env_log "ERROR: Flutter not found."
  exit 1
}
resolve_android_sdk || {
  _flutter_test_env_log "ERROR: Android SDK not found."
  exit 1
}

DEVICE="$(bash "$SCRIPT_DIR/start-shared-emulator.sh" | tail -n1)"
PKG="com.example.flutter_template"

_flutter_test_env_log "Revoking Bluetooth permissions on $DEVICE ..."
for perm in android.permission.BLUETOOTH_SCAN android.permission.BLUETOOTH_CONNECT; do
  "$(adb_bin)" -s "$DEVICE" shell pm revoke "$PKG" "$perm" 2>/dev/null || true
done

grant_permissions() {
  sleep 25
  _flutter_test_env_log "Granting Bluetooth permissions on $DEVICE ..."
  for perm in android.permission.BLUETOOTH_SCAN android.permission.BLUETOOTH_CONNECT; do
    "$(adb_bin)" -s "$DEVICE" shell pm grant "$PKG" "$perm" 2>/dev/null || true
  done
}

grant_permissions &
GRANT_PID=$!

cd "$ROOT_DIR"
set +e
"$FLUTTER_BIN" test integration_test/printer_bluetooth_scan_test.dart -d "$DEVICE"
EXIT_CODE=$?
set -e

kill "$GRANT_PID" 2>/dev/null || true
wait "$GRANT_PID" 2>/dev/null || true

# Restore permissions for follow-up runs.
for perm in android.permission.BLUETOOTH_SCAN android.permission.BLUETOOTH_CONNECT; do
  "$(adb_bin)" -s "$DEVICE" shell pm grant "$PKG" "$perm" 2>/dev/null || true
done

exit "$EXIT_CODE"
