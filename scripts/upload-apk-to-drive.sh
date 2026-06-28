#!/usr/bin/env bash
# Upload a built .apk to the shared luna Google Drive using rclone.
#
# Layout in Drive (under the shared parent folder):
#   <AppName>/
#     debug/     <- development APKs (auto-deploy on master push)
#     release/   <- release APKs (manual, chosen via the Jenkins dropdown)
#
# rclone auto-creates the <AppName>/<debug|release>/ folders if missing.
#
# Usage:
#   scripts/upload-apk-to-drive.sh <apk_path> [debug|release]   # default: debug
#
# Env:
#   GDRIVE_REMOTE            rclone remote name (default: gdrive)
#   GDRIVE_PARENT_FOLDER_ID  Drive folder ID that holds every app folder
#                            (default: the shared luna apps folder below)
#   APP_NAME                 override the app folder name (default: pubspec `name`)
#   RCLONE_CONFIG            path to an rclone.conf (the deploy host stages this)
set -euo pipefail

log() { printf '>> %s\n' "$*" >&2; }

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

APK_PATH="${1:?usage: upload-apk-to-drive.sh <apk_path> [debug|release]}"
BUILD_TYPE="${2:-debug}"
case "$BUILD_TYPE" in
	debug|release) ;;
	*) echo "ERROR: build type must be 'debug' or 'release' (got '$BUILD_TYPE')" >&2; exit 2 ;;
esac
[ -f "$APK_PATH" ] || { echo "ERROR: APK not found: $APK_PATH" >&2; exit 1; }

command -v rclone >/dev/null 2>&1 || {
	echo "ERROR: rclone not found on PATH. Install rclone and configure the '${GDRIVE_REMOTE:-gdrive}' remote." >&2
	exit 1
}

GDRIVE_REMOTE="${GDRIVE_REMOTE:-gdrive}"
# Shared "luna apps" Drive folder. Each app gets its own subfolder underneath.
GDRIVE_PARENT_FOLDER_ID="${GDRIVE_PARENT_FOLDER_ID:-1up3qsmD0QYr-JVKDxmAEctJJzsSG1-bI}"

# Pull app name + version straight out of pubspec.yaml (no yq dependency).
read_pubspec() { grep -E "^$1:" pubspec.yaml | head -n1 | sed -E "s/^$1:[[:space:]]*//" | tr -d '"'\'; }
APP_NAME="${APP_NAME:-$(read_pubspec name)}"
VERSION="$(read_pubspec version)"
[ -n "$APP_NAME" ] || { echo "ERROR: could not resolve APP_NAME from pubspec.yaml" >&2; exit 1; }
[ -n "$VERSION" ] || VERSION="0.0.0"

SHORT_SHA="$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || echo nogit)"
STAMP="$(date -u +%Y%m%d-%H%M%S)"
# e.g. my_app-v1.0.0+1-debug-1a2b3c4-20260621-120000.apk
FILENAME="${APP_NAME}-v${VERSION}-${BUILD_TYPE}-${SHORT_SHA}-${STAMP}.apk"

# rclone connection-string syntax pins the shared parent folder as the remote
# root for this command, so paths resolve relative to it regardless of the
# remote's configured default root.
DEST="${GDRIVE_REMOTE},root_folder_id=${GDRIVE_PARENT_FOLDER_ID}:${APP_NAME}/${BUILD_TYPE}/${FILENAME}"

log "Uploading $BUILD_TYPE APK to Google Drive: ${APP_NAME}/${BUILD_TYPE}/${FILENAME}"
rclone copyto "$APK_PATH" "$DEST" --drive-use-trash=false --no-traverse >&2

log "Upload complete: ${APP_NAME}/${BUILD_TYPE}/${FILENAME}"
printf '%s\n' "${APP_NAME}/${BUILD_TYPE}/${FILENAME}"
