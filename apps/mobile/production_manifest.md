# Kuttiomp Production Manifest — v2.3.0+1

**Sovereign Production Release Candidate**

## Version

- **App:** `2.3.0+1`
- **Codename:** Sovereign Production Release Candidate
- **Constitution:** Kuttiomp Master Architecture Document v2.0

## Pre-Deployment Checklist

- [ ] `DEPLOYMENT_SOVEREIGNTY_CHECKLIST.md` signed by Keeper/Elder council
- [ ] `l10n/elder_review_manifest.yaml` — all keys `elder_approved: true`
- [ ] `assets/audio/` — elder-reviewed narration assets present
- [ ] Supabase RLS policies enforced on all secure views/RPCs (no direct table access)
- [ ] JWT custom claims: `mode`, `clan`, `role`, `tier`
- [ ] `.env` production credentials stored in tribal secret manager (never committed)

## Supabase RLS Reminder

- All Flutter queries route through audited RPCs only (`KuttiompRpc.all`)
- `user_profiles` — clan-scoped RLS + elder override audit trigger
- Sacred/ceremonial content — encrypted fields + consent RPC gate
- Elder recordings — `approval_chain` array + Keeper RLS

## Asset Guidelines

- Land-based icons only (`assets/images/`)
- Traditional-inspired fonts, non-copyright (`assets/fonts/`)
- Every audio asset requires `speaker_id` + elder approval metadata
- No playful/gamified assets (Protocol 10 — `dignity_lint.yaml`)

## CI Final Script

```bash
#!/usr/bin/env bash
# scripts/ci_production_gate.sh — tribal-team ready forever
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== Kuttiomp v2.3.0+1 Production Gate ==="
flutter pub get
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
flutter test test/production/
flutter test test/features/
flutter test test/offline/
flutter test test/mode_consistency/
echo "=== All gates passed | Sovereign Production-Ready ==="
```

PowerShell equivalent:

```powershell
cd apps/mobile
flutter pub get
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
flutter test test/production/
flutter test
```

## Production Run

```bash
flutter run --dart-define=FLAVOR=production
flutter build apk --release --dart-define=FLAVOR=production
```

## Keeper Blessing

After all gates pass, run Keeper blessing simulation and archive the log:

```dart
final record = await KeeperBlessingSimulation().recordBlessing(
  keeperId: 'keeper-council',
  keeperName: 'Authorized Keeper',
);
```

Template output: see `MASTER_TRIBAL_ONBOARDING_HANDBOOK.md` Part 7.

## Handover

The foundational build phase is complete. Refer to `MASTER_TRIBAL_ONBOARDING_HANDBOOK.md` for perpetual stewardship.