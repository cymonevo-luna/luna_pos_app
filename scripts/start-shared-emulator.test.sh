#!/usr/bin/env bash
# Regression tests for scripts/start-shared-emulator.sh KVM preflight.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
START="$SCRIPT_DIR/start-shared-emulator.sh"
LIB="$SCRIPT_DIR/lib/flutter-test-env.sh"

[ -f "$START" ] || { echo "FAIL: start-shared-emulator.sh missing"; exit 1; }
[ -f "$LIB" ] || { echo "FAIL: lib/flutter-test-env.sh missing"; exit 1; }

grep -Fq 'source "$SCRIPT_DIR/lib/flutter-test-env.sh"' "$START" \
  || { echo "FAIL: start-shared-emulator.sh must source flutter-test-env.sh"; exit 1; }
grep -Fq 'require_kvm_for_shared_avd' "$START" \
  || { echo "FAIL: start-shared-emulator.sh must call require_kvm_for_shared_avd"; exit 1; }
grep -Fq 'EMULATOR_KVM_REQUIRED' "$LIB" \
  || { echo "FAIL: kvm_required_error_message must contain EMULATOR_KVM_REQUIRED"; exit 1; }
grep -Fq 'exit 2' "$START" \
  || { echo "FAIL: start-shared-emulator.sh must exit 2 on KVM failure"; exit 1; }
! grep -Fq 'swiftshader_indirect' "$START" \
  || { echo "FAIL: software GPU fallback must be removed from start-shared-emulator.sh"; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/fake-sdk/platform-tools" "$WORK/fake-sdk/emulator"

cat > "$WORK/fake-sdk/emulator/emulator" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = "-list-avds" ]; then
  echo "Luna_Test_Lite"
  exit 0
fi
echo "emulator should not be invoked during KVM preflight test" >&2
exit 99
EOF
chmod +x "$WORK/fake-sdk/emulator/emulator"

cat > "$WORK/fake-sdk/platform-tools/adb" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = "devices" ]; then
  echo "List of devices attached"
fi
exit 0
EOF
chmod +x "$WORK/fake-sdk/platform-tools/adb"

export ANDROID_HOME="$WORK/fake-sdk"
export ANDROID_SDK_ROOT="$WORK/fake-sdk"
export PATH="$WORK/fake-sdk/platform-tools:$WORK/fake-sdk/emulator:$PATH"
export LUNA_TEST_KVM_USABLE=0
export LUNA_TEST_KVM_GROUP_MEMBER=0

start_time=$(date +%s)
set +e
output="$(bash "$START" 2>&1)"
status=$?
set -e
end_time=$(date +%s)
elapsed=$((end_time - start_time))

[ "$status" -eq 2 ] || { echo "FAIL: expected exit 2 without KVM, got $status"; exit 1; }
echo "$output" | grep -Fq 'EMULATOR_KVM_REQUIRED' \
  || { echo "FAIL: expected EMULATOR_KVM_REQUIRED in output"; exit 1; }
[ "$elapsed" -lt 10 ] || { echo "FAIL: KVM preflight took ${elapsed}s (expected <10s)"; exit 1; }
echo "$output" | grep -Fq 'emulator should not be invoked' \
  && { echo "FAIL: emulator process was spawned without KVM"; exit 1; }

# shellcheck source=lib/flutter-test-env.sh
source "$LIB"
if require_kvm_for_shared_avd; then
  _flutter_test_env_log "KVM available on host; skipping live emulator boot assertion"
else
  _flutter_test_env_log "KVM unavailable on host (expected for fast-fail path)"
fi

echo "PASS start-shared-emulator.test.sh"
