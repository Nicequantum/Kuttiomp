#!/usr/bin/env bash
# Kuttiomp vRollout-1.0 + vSeeding-1.0 — Pilot & seeding simulation runner
set -euo pipefail
cd "$(dirname "$0")/.."

WITH_SEEDING=false
LIVE_DEVICE_MODE=false
MONITOR_MODE=false
HOUSEHOLD=""
for arg in "$@"; do
  case "$arg" in
    --with-seeding) WITH_SEEDING=true ;;
    --live-device-mode) LIVE_DEVICE_MODE=true ;;
    --monitor-mode) MONITOR_MODE=true ;;
    --household=*) HOUSEHOLD="${arg#*=}" ;;
  esac
done

echo "=== Kuttiomp Pilot Simulation (vRollout-1.0) ==="
flutter pub get
flutter test test/rollout/ --reporter expanded

if [ "$WITH_SEEDING" = true ]; then
  echo ""
  echo "=== Kuttiomp Seeding Simulation (vSeeding-1.0) ==="
  flutter test test/seeding/ --reporter expanded
  echo ""
  echo "=== Seeding maintainer guide ==="
  echo "  lib/features/seeding/seeding_TRIBAL_MAINTAINER_GUIDE.md"
fi

if [ "$LIVE_DEVICE_MODE" = true ]; then
  echo ""
  echo "=== Kuttiomp Live Pilot Simulation (vPilotLive-1.0) ==="
  flutter test test/pilot_live/ --reporter expanded
  echo ""
  echo "=== Kuttiomp Cohort Docs (vPilotCohortDocs-1.0) ==="
  flutter test test/pilot_live/ --name cohort_docs --reporter expanded
  ./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate
  echo ""
  echo "=== Live pilot maintainer guide ==="
  echo "  lib/features/pilot_live/pilot_live_TRIBAL_MAINTAINER_GUIDE.md"
  echo "  ../../docs/rollout/vPilotCohortDocs-1.0/TribalMaintainerGuide.md"
fi

if [ -n "$HOUSEHOLD" ]; then
  echo ""
  echo "=== Kuttiomp Household Seeding ($HOUSEHOLD | vPilotHouseholdSeeding-1.0) ==="
  flutter test test/pilot_live/ --name household_seeding --reporter expanded
  echo "  ../../docs/rollout/vPilotHouseholdSeeding-1.0/TribalMaintainerGuide_Seeding.md"
fi

if [ "$MONITOR_MODE" = true ]; then
  echo ""
  echo "=== Kuttiomp 48hr Monitor ($HOUSEHOLD | vPilotSeedingMonitor-1.0) ==="
  flutter test test/pilot_live/ --name "seeding_monitor|household_seeding" --reporter expanded
  ./scripts/seal_covenant_script.sh --household="${HOUSEHOLD:-HH01}" --monitor-mode --seal=48hr
  echo "  ../../docs/rollout/vPilotSeedingMonitor-1.0/TribalMaintainerGuide_Monitor.md"
  echo ""
  echo "=== Kuttiomp Full Cycle ($HOUSEHOLD | vPilotHH01FullCycle-1.0) ==="
  flutter test test/pilot_live/ --name "full_cycle" --reporter expanded
  ./scripts/seal_day7_covenant_script.sh --household="${HOUSEHOLD:-HH01}" --advance=day3
  echo "  ../../docs/rollout/vPilotHH01FullCycle-1.0/TribalMaintainerGuide_FullCycle.md"
fi

echo ""
echo "=== Pilot docs ready for tribal council ==="
echo "  ../../docs/rollout/pilot_playbook.md"
echo "  ../../docs/rollout/journey_logging_template.md"
echo "  ../../docs/rollout/keeper_signoff_workflow.md"
echo "=== Simulation complete | Review Keeper sign-off workflow ==="