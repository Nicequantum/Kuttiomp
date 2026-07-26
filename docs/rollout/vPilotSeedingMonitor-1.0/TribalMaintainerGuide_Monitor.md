# Tribal Maintainer Guide — 48-Hour Seeding Monitor

**vPilotSeedingMonitor-1.0 | Onboarding time: < 30 minutes**

## Prerequisites

- vPilotHouseholdSeeding-1.0 ratified and HH01 active
- Elder mode access on Keeper council device
- Flutter SDK on PATH

## Quick Start (< 30 min)

### 1. Verify artifacts (5 min)

```bash
cd apps/mobile
flutter test test/pilot_live/ --name seeding_monitor
```

### 2. Open Keeper council live view (2 min)

- Navigate to `/keeper-council-live`
- Confirm HH01 tile highlighted with "Under 48hr Keeper watch"
- Note `OfflineQueueDepthPanel` values

### 3. Watch Day 1–2 (24–48 hr)

- Family logs observations via Dashboard → Pilot Logging
- Council reviews feed + queue depth in real time
- Use `keeper_council_48hr_protocol.md` checklist

### 4. Confirm gate + seal (10 min)

```bash
./scripts/seal_covenant_script.sh --household=HH01 --monitor-mode
```

Or in-app:

1. Tap **Confirm Day 1–2 Observations** on `Day12ConfirmationGate`
2. Verify Day 3 unlocks
3. Tap **Seal 48hr Covenant**
4. Confirm snackbar: `HH01 Covenant Sealed – 48hr Integrity Confirmed`

### 5. Advance to Day 3 (5 min)

- `/keeper-pilot-signoff` now accessible
- Continue 7-day cycle per `vPilotHouseholdSeeding-1.0`

## Key Files

| Purpose | Path |
|---------|------|
| Monitor service | `lib/features/pilot_live/monitoring_service.dart` |
| Live view | `lib/features/pilot_live/presentation/keeper_council_live_view.dart` |
| Queue panel | `lib/features/pilot_live/monitoring_dashboard_extension/offline_queue_depth_widget.dart` |
| Day 1–2 gate | `lib/features/pilot_live/monitoring_dashboard_extension/day12_confirmation_gate.dart` |
| Audit template | `docs/rollout/vPilotSeedingMonitor-1.0/live_observation_audit_template.json` |

## Governance

- **Never** bypass `Day12ConfirmationGate` for Day 3 media review.
- `monitor_session_id` is immutable once assigned to HH01 profile.
- All 12 Cultural Governance Protocols enforced at 100% (`pilot_seeding_monitor: 1.0`).

## Troubleshooting

| Symptom | Action |
|---------|--------|
| Day 3 button locked | Confirm Day 1–2 observations exist; run gate confirmation |
| Queue depth > 0 at seal | Document exception in audit template; elder stamp required |
| RPC offline | Local audit authoritative; sync on reconnect |