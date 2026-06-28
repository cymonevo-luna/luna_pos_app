#!/usr/bin/env bash
# Deploy this Flutter app: build the Android .apk and upload it to Google Drive.
#
# This is the single entry point the luna_jenkins deploy host invokes (after it
# checks out the requested ref and stages the per-app .env + rclone.conf). It is
# the Flutter analogue of the backend services' scripts/refresh-daemon.sh.
#
# Usage:
#   scripts/deploy-apk.sh [debug|release]   # default: debug
#
# Auto-deploys (GitHub master push -> Jenkins webhook) always pass "debug";
# a "release" build is chosen manually via the Jenkins BUILD_TYPE dropdown.
#
# All build/upload env overrides (FLUTTER_BIN, GDRIVE_REMOTE,
# GDRIVE_PARENT_FOLDER_ID, APP_NAME, RCLONE_CONFIG, ...) are honored by the
# scripts this one calls.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
BUILD_TYPE="${1:-debug}"

echo ">> Deploying APK (build type: $BUILD_TYPE)" >&2

APK_PATH="$("$SCRIPT_DIR/build-apk.sh" "$BUILD_TYPE" | tail -n1)"
echo ">> Built artifact: $APK_PATH" >&2

"$SCRIPT_DIR/upload-apk-to-drive.sh" "$APK_PATH" "$BUILD_TYPE"

echo ">> APK deploy finished ($BUILD_TYPE)." >&2
