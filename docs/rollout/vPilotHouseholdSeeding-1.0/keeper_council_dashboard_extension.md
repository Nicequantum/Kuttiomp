# Keeper Council Dashboard Extension — Live Monitoring

**vPilotHouseholdSeeding-1.0 | Route: `/keeper-council-live`**

## Quick Links (Elder mode)

| Link | Route | Purpose |
|------|-------|---------|
| Keeper Council Live | `/keeper-council-live` | HH01 status, observation feed |
| Live Sign-Off | `/keeper-pilot-signoff` | Screenshot + voice media review |
| Seeding Campaigns | `/seeding` | Day 7 reflection seed |

## Dashboard Panel Fields

- **Household ID:** HH01
- **Status:** pending → recruited → paired → active → sealed
- **Current day:** 0–7
- **Pending reviews:** `KeeperLiveSignoffNotifier.pendingReviewCount`
- **Observations:** filtered `householdId == 'HH01'`

## Seal Day 7

Button triggers `HouseholdSeedingService.completeHouseholdSeeding()`:
- `recordKeeperSignoffWithMedia()`
- Optional `ElderCampaign.landStewardshipPhrases` reflection
- Audit: `Household 1 successfully completed under full sovereignty`

## Implementation

`lib/features/pilot_live/presentation/keeper_council_live_view.dart`