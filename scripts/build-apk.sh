#!/usr/bin/env bash
# Build the Android .apk for this Flutter app.
#
# Self-locating: lives in <repo>/scripts/ and resolves the repo root as its
# parent, so it works the same locally and on the Jenkins deploy host.
#
# Usage:
#   scripts/build-apk.sh [debug|release]   # default: debug
#
# On success the ABSOLUTE path to the built .apk is printed on the LAST stdout
# line (everything else is logged to stderr) so callers can capture it with:
#   APK="$(scripts/build-apk.sh release | tail -n1)"
#
# Env overrides:
#   FLUTTER_BIN            flutter executable (default: flutter on PATH)
#   SKIP_CODEGEN           set to 1 to skip `dart run build_runner build`
#   BUILD_RUNNER_TIMEOUT   seconds before codegen is killed (default: 1800)
set -euo pipefail

log() { printf '>> %s\n' "$*" >&2; }

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

# build_runner uses a single-instance lock per package dir. After an aborted
# Jenkins deploy the lock file can outlive the dead process and block forever.
ensure_build_runner_unlocked() {
	local lock="$REPO_DIR/.dart_tool/build/lock/build_runner.lock"
	[ -f "$lock" ] || return 0

	local lock_pid=""
	lock_pid="$(tr -d '[:space:]' < "$lock" 2>/dev/null || true)"
	if [ -n "$lock_pid" ] && kill -0 "$lock_pid" 2>/dev/null; then
		local lock_cwd=""
		lock_cwd="$(readlink -f "/proc/$lock_pid/cwd" 2>/dev/null || true)"
		if [ "$lock_cwd" = "$REPO_DIR" ]; then
			log "build_runner lock held by live PID $lock_pid; leaving lock in place"
			return 0
		fi
	fi

	log "Removing stale build_runner lock at $lock"
	rm -f "$lock"
}

run_build_runner() {
	local timeout_secs="${BUILD_RUNNER_TIMEOUT:-1800}"
	log "dart run build_runner build (code generation, timeout ${timeout_secs}s)"
	if command -v timeout >/dev/null 2>&1; then
		timeout "$timeout_secs" dart run build_runner build --delete-conflicting-outputs >&2
	else
		dart run build_runner build --delete-conflicting-outputs >&2
	fi
}

BUILD_TYPE="${1:-debug}"
case "$BUILD_TYPE" in
	debug|release) ;;
	*)
		echo "ERROR: build type must be 'debug' or 'release' (got '$BUILD_TYPE')" >&2
		exit 2
		;;
esac

FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
command -v "$FLUTTER_BIN" >/dev/null 2>&1 || {
	echo "ERROR: '$FLUTTER_BIN' not found on PATH. Install the Flutter SDK or set FLUTTER_BIN." >&2
	exit 1
}

# The template ships `.env` as a bundled asset (see pubspec.yaml). A build fails
# if it is missing, so make sure SOMETHING is there (the deploy host stages the
# real per-app .env before calling this; locally we fall back to .env.example).
if [ ! -f .env ]; then
	if [ -f .env.example ]; then
		log "No .env found; copying .env.example so the asset bundle resolves."
		cp .env.example .env
	else
		log "WARN: no .env or .env.example present; build may fail on the .env asset."
	fi
fi

log "flutter pub get"
"$FLUTTER_BIN" pub get >&2

# freezed / json_serializable models need generated code before the build.
if [ "${SKIP_CODEGEN:-0}" != "1" ]; then
	ensure_build_runner_unlocked
	run_build_runner
fi

log "flutter build apk --$BUILD_TYPE"
"$FLUTTER_BIN" build apk "--$BUILD_TYPE" >&2

APK_PATH="$REPO_DIR/build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
[ -f "$APK_PATH" ] || {
	echo "ERROR: expected APK not found at $APK_PATH" >&2
	exit 1
}

log "Built $BUILD_TYPE APK: $APK_PATH"
# Last stdout line = the artifact path (machine-readable for callers).
printf '%s\n' "$APK_PATH"
