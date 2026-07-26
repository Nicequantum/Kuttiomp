# Tribal Maintainer Guide — HH01 Full Week (Day 3–7)

**vPilotHH01FullCycle-1.0 | Reference time: < 20 minutes**

## Prerequisites

- vPilotSeedingMonitor-1.0 covenant sealed
- Audit: `HH01 Covenant Sealed – 48hr Integrity Confirmed`
- HH01 active at `/keeper-council-live`

## Quick Reference

### 1. Confirm Day 3 authorization (2 min)

```bash
cd apps/mobile
./scripts/seal_covenant_script.sh --household=HH01 --monitor-mode --seal=48hr
./scripts/seal_day7_covenant_script.sh --household=HH01 --advance=day3
```

Expected: `Day 3 media review unlocked. HH01 progressing under full elder authority.`

### 2. Day 3 media review (5 min)

- Open `/keeper-pilot-signoff` in Elder mode
- Review HH01 observations + media thumbnails
- Tap **Approve & Ready for Scale**
- Confirms `day3_signoff_complete`

### 3. Daily council touchpoints Days 4–6 (ongoing)

- `/keeper-council-live` → Full Week Progress panel
- Verify day chips fill as observations arrive
- Check offline queue depth = 0 before Day 7

### 4. Seal Day 7 covenant (5 min)

- All 7 day chips green + Day 3 sign-off complete
- Tap **Seal Day 7 Covenant** on Keeper Council Live
- Audit: `HH01 Seven-Day Walk Complete`
- Seasonal templates unblocked

## Key Files

| Purpose | Path |
|---------|------|
| Progress tracker | `lib/features/pilot_live/full_cycle_tracker.dart` |
| Full cycle service | `lib/features/pilot_live/full_cycle_service.dart` |
| Progress panel | `lib/features/pilot_live/presentation/full_cycle_progress_panel.dart` |
| Day 3 sign-off | `lib/features/pilot_live/presentation/keeper_live_signoff_view.dart` |

## Governance

- Do not launch seasonal seeding until Day 7 sealed (Protocol 12).
- Do not invite next cohort until HH01 seven-day walk complete.
- All Days 3–7 observations carry land-context metadata (Protocol 6).