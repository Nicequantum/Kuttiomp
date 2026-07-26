# Core Adult — Phone Logging Template

**vPilotCohortDocs-1.0**

**Mode:** `KuttiompMode.coreAdult` | **Device:** `LiveDeviceType.androidPhone`  
**Protocols:** 3, 6, 9, 11

---

## Primary Observer Role

Tribal member using Kuttiomp in daily life — documents land-context search, lessons, and offline resilience.

---

## Weekly Logging Grid

| Day | Focus | Journey step | Land context? |
|-----|-------|--------------|---------------|
| 1 | Onboarding + mode | `onboarding` | — |
| 2 | Search land | `search_land` | Yes |
| 3 | Lesson progress | `lesson_complete` | — |
| 4 | Phrases | `pilot_logging` | Optional |
| 5 | Offline test | `offline_toggle` | — |
| 6 | Profile audit | `profile_audit` | — |
| 7 | Cohort debrief | `pilot_logging` | — |

---

## Submission (Offline-First)

```dart
await PilotLiveService().submitLiveObservation(LivePilotObservation(
  id: 'live-adult-{household}-{day}',
  householdId: '{household_id}',
  observerRole: 'tribal_member',
  mode: KuttiompMode.coreAdult,
  deviceType: LiveDeviceType.androidPhone,
  journeyStep: LiveJourneyStep.searchLand,
  observation: 'Search "land" returned attributed results with geo badge.',
  speakerMetadata: {
    'speaker_id': 'member-{household_id}',
    'name': 'Core Adult Observer',
    'authority_source': 'elder',
    'land_context': {'label': 'Narragansett territory'},
  },
));
```

On reconnect: `PilotLiveService().syncPendingObservations()` flushes `PilotLiveLogStore` queue.

**Route:** `/pilot-logging` (Dashboard quick link)