# Kuttiomp vPilotSeedingMonitor-1.0 — 48-Hour Covenant Seal & Keeper Watch

**Ratified:** 2026-07-05 | **Household:** HH01 | **Monitor window:** 48 hours  
**Extends:** vPilotHouseholdSeeding-1.0 + vPilotLive-1.0

---

## Covenant Seal

Path 1 selected: seal the seeding covenant and monitor the first 48 hours before Day 3 media review.

| Step | Action | Mobile / RPC |
|------|--------|--------------|
| 1 | Keeper opens `/keeper-council-live` | HH01 tile auto-highlights |
| 2 | Watch offline queue depth | `OfflineQueueDepthPanel` |
| 3 | Review Day 1–2 observations | `review_48hr_observations_secure` |
| 4 | Confirm gate | `Day12ConfirmationGate` → `confirmDay12Gate()` |
| 5 | Seal covenant | `seal_covenant_secure` |
| 6 | Unlock Day 3 media review | `/keeper-pilot-signoff` |

## Artifact Index

| Document | Path |
|----------|------|
| 48hr protocol | [`keeper_council_48hr_protocol.md`](keeper_council_48hr_protocol.md) |
| Queue depth widget | [`monitoring_dashboard_extension/offline_queue_depth_widget.dart`](monitoring_dashboard_extension/offline_queue_depth_widget.dart) |
| Day 1–2 gate | [`monitoring_dashboard_extension/day12_confirmation_gate.dart`](monitoring_dashboard_extension/day12_confirmation_gate.dart) |
| Audit template | [`live_observation_audit_template.json`](live_observation_audit_template.json) |
| Maintainer guide | [`TribalMaintainerGuide_Monitor.md`](TribalMaintainerGuide_Monitor.md) |
| Seal script | [`seal_covenant_script.sh`](../../apps/mobile/scripts/seal_covenant_script.sh) |

## Core Integrations

| Component | Location |
|-----------|----------|
| SeedingMonitorService | `lib/features/pilot_live/monitoring_service.dart` |
| KeeperCouncilLiveView | `lib/features/pilot_live/presentation/keeper_council_live_view.dart` |
| Profile field | `monitor_session_id` (immutable) + `seeding_cohort=HH01` |
| Protocol compliance | `pilot_seeding_monitor: 1.0` (12/12 protocols) |

## Verification

```bash
cd apps/mobile
flutter test test/pilot_live/ --name "seeding_monitor|household_seeding"
./scripts/seal_covenant_script.sh --household=HH01 --monitor-mode
flutter run --dart-define=HOUSEHOLD=HH01 --dart-define=MONITOR=48hr
```

**Expected outcome:** `HH01 48hr Covenant sealed. All 12 protocols green. Offline queue depth: 0. Ready for Day 3.`

## Ratification Stamp

```
=== Kuttiomp vPilotSeedingMonitor-1.0 Ratification ===
Household: HH01 | Monitor: 48hr covenant seal
Outcome: HH01 Covenant Sealed – 48hr Integrity Confirmed
The council watches. The reclamation deepens.
====================================================
```