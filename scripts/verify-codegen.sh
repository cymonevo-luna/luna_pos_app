#!/usr/bin/env bash
# Verify committed freezed/json_serializable outputs exist for every annotated model.
#
# Deploy builds skip build_runner (SKIP_CODEGEN=1) and rely on generated files in
# git; this script is the gate that catches a missing `dart run build_runner build`
# before push.
#
# Usage: scripts/verify-codegen.sh
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

missing=0

while IFS= read -r src; do
	base="${src%.dart}"
	freezed="${base}.freezed.dart"
	if [ ! -f "$freezed" ]; then
		echo "ERROR: missing $freezed (source: $src)" >&2
		missing=1
	fi
	if grep -q 'fromJson' "$src" && [ ! -f "${base}.g.dart" ]; then
		echo "ERROR: missing ${base}.g.dart (source: $src)" >&2
		missing=1
	fi
done < <(grep -rl '@freezed' lib --include='*.dart' | grep -vE '\.(freezed|g)\.dart$' || true)

if [ "$missing" -ne 0 ]; then
	echo "Run: dart run build_runner build" >&2
	exit 1
fi

echo ">> Codegen outputs present for all @freezed models."
