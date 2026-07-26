#!/usr/bin/env bash
# Kuttiomp vPilotHH01FullCycle-1.0 — Day 3 advance + Day 7 covenant seal
# Canonical script: apps/mobile/scripts/seal_day7_covenant_script.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/../../../apps/mobile/scripts/seal_day7_covenant_script.sh" "$@"