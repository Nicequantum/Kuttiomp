# Journey Logging Template — Day in the Language Home

**Pilot cohort observation form (vRollout-1.0)**

Copy one form per household per day. Submit via `PilotFeedbackService.submitPilotObservation()` or tribal paper archive.

---

## Household Metadata

| Field | Value |
|-------|-------|
| Household ID | `household-__` |
| Date | YYYY-MM-DD |
| Observer name / role | |
| Kuttiomp mode | Little Ones / Young Learner / Core Adult / Elder |
| Device type | e.g. elder_android_phone, family_ipad |
| App version | 2.3.0+1 |

---

## Journey Step Checklist

Mark each step observed today. Note protocol compliance (Y/N) and brief observation.

| Step | Observed | Protocols enforced (1–12) | Notes |
|------|----------|---------------------------|-------|
| Onboarding + audio narration | ☐ | 2, 3, 9, 11 | |
| Mode switch (FAB / bottom sheet) | ☐ | 3, 8, 11 | |
| Dashboard petals navigation | ☐ | 3, 10 | |
| Search "land" + audio preview | ☐ | 1, 6, 7, 9 | |
| Lesson activity + progress | ☐ | 1, 7, 8 | |
| Phrase / lexeme detail guards | ☐ | 1, 2, 4, 5 | |
| Elder contribute + pending gate | ☐ | 2, 7, 8 | |
| Keeper approve → corpus mirror | ☐ | 2, 8, 9 | |
| Profile audit log review | ☐ | 9, 11 | |
| Offline toggle + sacred consent | ☐ | 4, 5, 9 | |

---

## Qualitative Observation (required)

**What moment did the language feel most alive today?**

> 

**What moment required elder or Keeper guidance?**

> 

**Did any protocol feel misaligned with cultural practice? (Protocol 12 flag)**

> 

---

## Voice & Screenshot Attachments (optional)

| Attachment | Reference ID | Elder approved |
|------------|--------------|----------------|
| Screenshot | `pilot_screenshots/...` | ☐ |
| Voice feedback | `audio-pilot-feedback-...` | ☐ |

---

## Observer Sign-Off

| Field | Value |
|-------|-------|
| Observer signature | |
| Timestamp (UTC) | |

---

## RPC Submission Payload (for stewards)

```json
{
  "id": "pilot-household-01-2026-07-05",
  "household_id": "household-01",
  "mode": "little_ones",
  "journey_step": "search_land",
  "observation": "Child recognized land lexeme by sound.",
  "protocols_enforced": ["1", "2", "6", "7", "8", "9"],
  "elder_approved": true
}
```