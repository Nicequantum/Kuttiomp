#!/usr/bin/env bash
# Kuttiomp vPilotDay7ReflectionPrep-1.0 — Prepare gated Day 7 reflection template
set -euo pipefail
cd "$(dirname "$0")/.."

HOUSEHOLD="HH01"
STATUS="ready-but-gated"
for arg in "$@"; do
  case "$arg" in
    --household=*) HOUSEHOLD="${arg#*=}" ;;
    --status=*) STATUS="${arg#*=}" ;;
  esac
done

DOCS_ROOT="../../docs/rollout/vPilotHH01Day4Witness-1.0/vPilotDay7ReflectionPrep-1.0"

echo "=== Kuttiomp Day 7 Reflection Prep (vPilotDay7ReflectionPrep-1.0) ==="
echo "Household: $HOUSEHOLD | Status: $STATUS"

required_files=(
  "$DOCS_ROOT/day7_reflection_template.md"
  "$DOCS_ROOT/reflection_field_draft.json"
  "$DOCS_ROOT/activation_guard.md"
)

for f in "${required_files[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
  echo "  ✓ $f"
done

echo ""
echo "=== Protocol compliance ==="
if grep -q 'pilot_day7_prep: 1.0' lib/config/build_guards/protocol_compliance.yaml; then
  echo "  ✓ pilot_day7_prep: 1.0"
else
  echo "FAIL: pilot_day7_prep not registered" >&2
  exit 1
fi

echo ""
echo "=== Running day7_prep tests ==="
flutter pub get
flutter test test/pilot_live/ --name day7_prep --reporter expanded

echo ""
echo "=== Reflection prep status ==="
echo "  Draft: prepared"
echo "  Activation: BLOCKED until seal_day7_covenant_secure"
echo "  seasonal_templates_blocked_until_day7: true"
echo ""
echo "Day 7 reflection template prepared and gated. Activation blocked until Day 7 covenant seal."