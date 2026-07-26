# Young Learner — Phone/Tablet Logging Template

**vPilotCohortDocs-1.0**

**Mode:** `KuttiompMode.youngLearner` | **Device:** `LiveDeviceType.youthAndroid`  
**Protocols:** 3, 7, 10, 11

---

## Logging Rhythm

- **Observer:** Young learner (with optional parent co-sign)
- **Frequency:** One observation per day minimum; voice note encouraged
- **Dignity check:** No scores, streaks, or competitive language (Protocol 10)

---

## Daily Prompts

| Day | Journey step | Prompt (oral-first) |
|-----|--------------|---------------------|
| 1 | `onboarding` | "I chose my learning path" |
| 2 | `search_land` | "I found a word about land" |
| 3 | `lesson_complete` | "I finished a lesson today" |
| 4 | `phrases` | "I practiced a phrase" |
| 5 | `mode_switch` | "I saw how another mode looks" |
| 6 | `offline_toggle` | "The app worked without internet" |
| 7 | `pilot_logging` | "I helped log our week" |

---

## Submission Template

```dart
await PilotFeedbackService().submitLiveObservation(LivePilotObservation(
  id: 'live-youth-{household}-{day}',
  householdId: '{household_id}',
  observerRole: 'young_learner_self',
  mode: KuttiompMode.youngLearner,
  deviceType: LiveDeviceType.youthAndroid,
  journeyStep: LiveJourneyStep.lessonComplete,
  observation: 'Completed lesson with oral-first blocks; dignity preserved.',
  speakerMetadata: {
    'speaker_id': 'youth-{household_id}',
    'name': 'Young Learner',
    'authority_source': 'elder',
  },
));
```

**Dashboard path:** Pilot Logging → select journey step → Submit with Screenshot + Voice