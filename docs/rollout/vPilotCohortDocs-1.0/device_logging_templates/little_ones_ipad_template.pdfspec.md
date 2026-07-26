# Little Ones — Family iPad Logging Template

**PDF specification | vPilotCohortDocs-1.0**

**Mode:** `KuttiompMode.littleOnes` | **Device:** `LiveDeviceType.familyIpad`  
**Protocols:** 3, 7, 11 | **Typography:** 32 pt minimum, touch targets ≥ 48 dp

---

## Design Requirements (Print + In-App)

| Element | Specification |
|---------|---------------|
| Page size | US Letter, portrait |
| Illustrations | Large pictorial buttons per journey step |
| Audio | QR links to `primary_audio_id` stubs (oral-first, Protocol 7) |
| Parent voice | Auto-capture parent voice note on every log tap |
| Sacred gate | `sacred_flag` must be false for all Little Ones captures |

---

## Journey Steps to Log

| Day | Step | Tap illustration | Auto voice prompt |
|-----|------|------------------|-------------------|
| 1 | `onboarding` | Child hearing welcome | "Parent: child completed onboarding" |
| 2 | `search_land` | Magnifying glass + land | "Parent: child heard land word" |
| 3 | `lesson_complete` | Lesson book | "Parent: child finished lesson activity" |
| 4 | `mode_switch` | Four petals | "Parent: we tried another mode" |
| 5 | `offline_toggle` | Cloud with slash | "Parent: offline worked at home" |
| 6 | `pilot_logging` | Microphone | "Parent: logging today" |
| 7 | `profile_audit` | Profile icon | "Parent: week complete" |

---

## In-App Submission (Parent Observer)

```dart
await PilotLiveService().submitLiveObservation(LivePilotObservation(
  id: 'live-little-ones-{household}-{day}',
  householdId: '{household_id}',
  observerRole: 'parent_observer',
  mode: KuttiompMode.littleOnes,
  deviceType: LiveDeviceType.familyIpad,
  journeyStep: LiveJourneyStep.searchLand, // per day
  observation: 'Child recognized greeting by sound on family iPad.',
  speakerMetadata: {
    'speaker_id': 'parent-{household_id}',
    'name': 'Parent Observer',
    'authority_source': 'elder',
    'hasSemanticsLabel': true,
    'fontSize': 32.0,
  },
  protocolChecks: [
    ProtocolCheck(protocolId: '3', passed: true),
    ProtocolCheck(protocolId: '7', passed: true),
    ProtocolCheck(protocolId: '11', passed: true),
  ],
));
```

Routes through `PilotFeedbackService.submitLiveObservation()` → offline queue → Keeper review.

---

## ProtocolMetadata Embed

```json
{
  "recordId": "live-little-ones-{id}",
  "protocolId": "11",
  "sacredFlag": false,
  "visibleToTiers": 1,
  "speakerId": "parent-{household_id}",
  "elderApproved": true,
  "primaryAudioId": "audio-parent-voice-{timestamp}",
  "requiresLandContext": false,
  "schemaVersion": "2.0"
}
```