# Elder — Phone Logging Template

**vPilotCohortDocs-1.0**

**Mode:** `KuttiompMode.elder` | **Device:** `LiveDeviceType.elderAndroidPhone`  
**Protocols:** 2, 7, 8, 11

---

## Design Principles

- **High contrast** — land accent on white; 32 pt+ body text
- **Voice-dominant** — single-tap **Voice Log + Photo**
- **ElderModeOverlay** — all captures apply elder tier + accessibility semantics
- **Living authority** — `authority_source: elder` on every submission

---

## Single-Tap Flow

1. Dashboard or Profile → **Pilot Logging**
2. Tap **Submit with Screenshot + Voice** (one action)
3. System auto-applies:
   - `speaker_id` from profile
   - `sacred_flag` check (blocks ceremonial screenshots without consent)
   - `ElderModeOverlay` font + touch targets
4. Optional: **Seeding Campaigns** → `/seeding` for corpus contribution same week

---

## Elder-Specific Journey Steps

| Step | Action | Keeper tie-in |
|------|--------|---------------|
| `elder_contribute` | Record via `/contribute` | Pending gate |
| `keeper_approve` | Review in Keeper Dashboard | Protocol 2 |
| `seeding_campaign` | Land Stewardship Phrases | vSeeding-1.0 |
| `pilot_logging` | Household observation | vPilotLive-1.0 |

---

## Submission Template

```dart
await PilotLiveService().submitLiveObservation(LivePilotObservation(
  id: 'live-elder-{household}-{day}',
  householdId: '{household_id}',
  observerRole: 'elder_keeper',
  mode: KuttiompMode.elder,
  deviceType: LiveDeviceType.elderAndroidPhone,
  journeyStep: LiveJourneyStep.elderContribute,
  observation: 'Elder contributed oral recording; awaiting Keeper approval.',
  speakerMetadata: {
    'speaker_id': 'elder-{household_id}',
    'name': 'Elder Observer',
    'authority_source': 'elder',
    'hasSemanticsLabel': true,
    'fontSize': 32.0,
  },
));
```

**Keeper sign-off:** `/keeper-pilot-signoff` → `recordKeeperSignoffWithMedia()`