# Tribal Maintainer Guide — Daily Council Witness

**vPilotHH01Day4Witness-1.0 | Reference time: < 15 minutes**

## Daily Cadence

| Day | Council Action | Route |
|-----|----------------|-------|
| 1–2 | 48hr monitor + seal | `/keeper-council-live` |
| 3 | Media sign-off | `/keeper-pilot-signoff` |
| 4 | Elder land witness | `/keeper-council-live` + Day4 service |
| 5–6 | Progress check + queue depth | `/keeper-council-live` |
| 7 | Seal covenant | `/keeper-council-live` |

## Day 4 Quick Steps (< 15 min)

```bash
cd apps/mobile
flutter test test/pilot_live/ --name day4_witness
./scripts/seal_covenant_script.sh --household=HH01 --advance=day4
```

1. Confirm Full Week Progress = **4/7**
2. Verify Day 4 chip green, Day 5 chip locked
3. Confirm audit: `HH01 Day 4 Council Witness Confirmed`

## Parallel Prep (Non-Blocking)

```bash
./scripts/prepare_day7_reflection.sh --household=HH01 --status=ready-but-gated
```

Reflection template prepared — activation blocked until Day 7 seal.

## Governance

- One daily touchpoint per council session
- Queue depth must be 0 before witness stamp
- Seasonal templates remain blocked (Protocol 12)