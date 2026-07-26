#!/usr/bin/env bash
# Kuttiomp vPilotSeedingMonitor-1.0 — 48-hour covenant seal activation
# Canonical script: apps/mobile/scripts/seal_covenant_script.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/../../../apps/mobile/scripts/seal_covenant_script.sh" "$@"