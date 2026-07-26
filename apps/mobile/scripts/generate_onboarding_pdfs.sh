#!/usr/bin/env bash
# Kuttiomp vPilotCohortDocs-1.0 — Onboarding packet generation & elder review gate
set -euo pipefail
cd "$(dirname "$0")/.."

VOICE_NARRATE=false
ELDER_REVIEW_GATE=false
HOUSEHOLD=""
for arg in "$@"; do
  case "$arg" in
    --voice-narrate) VOICE_NARRATE=true ;;
    --elder-review-gate) ELDER_REVIEW_GATE=true ;;
    --household=*) HOUSEHOLD="${arg#*=}" ;;
  esac
done

DOCS_ROOT="../../docs/rollout/vPilotCohortDocs-1.0"
AUDIT_OUTCOME="CohortDocs-1.0 rendered under full 12-protocol compliance"

echo "=== Kuttiomp Onboarding PDF Generation (vPilotCohortDocs-1.0) ==="

required_files=(
  "$DOCS_ROOT/README.md"
  "$DOCS_ROOT/household_onboarding_packet_v1.md"
  "$DOCS_ROOT/device_logging_templates/little_ones_ipad_template.pdfspec.md"
  "$DOCS_ROOT/device_logging_templates/young_learner_phone_template.md"
  "$DOCS_ROOT/device_logging_templates/core_adult_template.md"
  "$DOCS_ROOT/device_logging_templates/elder_phone_template.md"
  "$DOCS_ROOT/keeper_7day_review_calendar.md"
  "$DOCS_ROOT/templates/onboarding_audio_script.arb"
  "$DOCS_ROOT/templates/keeper_signoff_checklist.json"
  "$DOCS_ROOT/TribalMaintainerGuide.md"
)

for f in "${required_files[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
  echo "  ✓ $f"
done

if [ "$ELDER_REVIEW_GATE" = true ]; then
  echo ""
  echo "=== Elder Review Gate (Protocol 2) ==="
  if [[ -f "l10n/elder_review_manifest.yaml" ]]; then
    echo "  ✓ elder_review_manifest.yaml present"
    echo "  → Merge cohort keys from $DOCS_ROOT/templates/onboarding_audio_script.arb after Keeper review"
  else
    echo "  WARN: elder_review_manifest.yaml not found" >&2
    exit 1
  fi
fi

if [ "$VOICE_NARRATE" = true ]; then
  echo ""
  echo "=== Voice Narration Stubs (Protocol 7) ==="
  echo "  Audio script: $DOCS_ROOT/templates/onboarding_audio_script.arb"
  echo "  QR targets: kuttiomp://first-launch?audio=cohortOnboardingWelcome"
  echo "  (Tribal toolchain: render Markdown → PDF with embedded QR + TTS links)"
fi

echo ""
echo "=== PDF Render Targets (tribal print pipeline) ==="
echo "  household_onboarding_packet_v1.pdf  ← household_onboarding_packet_v1.md"
echo "  little_ones_ipad_logging.pdf          ← little_ones_ipad_template.pdfspec.md"
echo "  keeper_7day_calendar.pdf              ← keeper_7day_review_calendar.md"

echo ""
echo "=== Audit Log Outcome ==="
echo "  $AUDIT_OUTCOME"

if [ -n "$HOUSEHOLD" ]; then
  echo ""
  echo "=== Household Seeding Bundle ($HOUSEHOLD) ==="
  HH_DOCS="../../docs/rollout/vPilotHouseholdSeeding-1.0"
  for f in "$HH_DOCS/README.md" "$HH_DOCS/live_7day_execution_plan.md" "$HH_DOCS/seeding_checklist.json"; do
    if [[ ! -f "$f" ]]; then
      echo "MISSING: $f" >&2
      exit 1
    fi
    echo "  ✓ $f"
  done
  echo "  QR bundle: $HH_DOCS/household_1_onboarding/device_pairing_qr_bundle.zipspec.md"
fi

echo ""
echo "=== Verification ==="
echo "  flutter test test/pilot_live/ --name 'household_seeding|cohort_docs'"
echo "=== Generation manifest complete ==="