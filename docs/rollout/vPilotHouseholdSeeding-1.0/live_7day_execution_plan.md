# Live 7-Day Execution Plan — Household 1

**Keeper council daily agenda + observation prompts**

| Day | Household action | Keeper council | Observation prompt |
|-----|------------------|----------------|-------------------|
| **1** | Install + onboarding QR | Acknowledge claim in `/keeper-council-live` | "Child/parent completed first launch" |
| **2** | Search `land` on iPad | Review offline sync queue | "Land word heard with attribution" |
| **3** | Lesson on iPad | **Group media review** `/keeper-pilot-signoff` | "Lesson activity completed" |
| **4** | Elder logs on phone | Approve/revise observations | "Elder contributed or observed" |
| **5** | Offline test (30 min) | Check sacred re-auth | "Cached content served" |
| **6** | Profile audit both devices | Pre-sign-off review | "Week nearly complete" |
| **7** | Reflection circle | `completeHouseholdSeeding()` + optional seeding | "Household covenant sealed" |

## Code Hooks

```dart
// Daily log
await HouseholdSeedingService().recordDayObservation(
  day: 3,
  observation: 'Lesson completed on family iPad.',
  observerRole: 'parent_observer',
  mode: KuttiompMode.littleOnes,
  deviceType: LiveDeviceType.familyIpad,
  journeyStep: LiveJourneyStep.lessonComplete,
);

// Day 7
await HouseholdSeedingService().completeHouseholdSeeding(householdId: 'HH01');
```