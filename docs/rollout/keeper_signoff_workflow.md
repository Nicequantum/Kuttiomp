# Keeper Sign-Off Workflow — Post-Pilot Review

**vRollout-1.0 | Protocol 2 Elder Approval at scale decision**

---

## Overview

After the 7-day pilot cohort completes, the Keeper Council reviews aggregated observations and issues a scale-readiness decision. No wider deployment proceeds without `approved_ready_for_scale` status.

## Review Steps

### 1. Collect pilot data

- Journey logging forms from all households
- `PilotLogStore` / Supabase `submit_pilot_feedback_secure` mirror
- Screenshot gallery (`pilot_screenshots/`) — UI only, no sacred content
- Optional voice feedback recordings with speaker attribution

### 2. Council review session

| Review item | Pass criteria |
|-------------|---------------|
| Onboarding clarity | ≥90% households complete without steward assistance |
| Mode persistence | Survives device restart in all households |
| Search + oral-first | Land query returns attributed audio in all modes tested |
| Elder contribution chain | Submit → pending → approve → search mirror (Elder households) |
| Offline resilience | Cached content available; sacred re-auth honored |
| Accessibility (Elder) | 32pt+ readable; semantics labels present |
| Dignity (Protocol 10) | No gamification observed in any household |
| Protocol violations | Zero unresolved `ProtocolViolationException` reports |

### 3. Screenshot upload protocol

1. Stewards upload to tribal secure storage (not public cloud)
2. Filename: `{household_id}/{journey_step}.png`
3. Keeper reviews for dignity and cultural appropriateness
4. Reference in `PilotObservation.screenshotRef`

### 4. Voice feedback recording

- Elder may record verbal council feedback
- Requires `speaker_id` + `primary_audio_id` (Protocol 7)
- Attached to sign-off record in audit log

### 5. Sign-off decision

```dart
final record = await PilotFeedbackService().recordKeeperSignoff(
  cohortId: 'pilot-cohort-2026-q3',
  keeperId: 'keeper-council',
  keeperName: 'Knowledge Keepers Council',
  status: PilotSignoffStatus.approvedReadyForScale,
  protocolCoverage: '100%',
);
```

**Statuses:**

| Status | Meaning |
|--------|---------|
| `pending` | Pilot in progress |
| `keeper_review` | Council reviewing |
| `approved_ready_for_scale` | Approved for community rollout |
| `needs_revision` | Issues identified; pilot extended or fixes required |

### 6. Archival

- Store `PilotSimulationRunner.formatCouncilReport()` output in tribal records
- Update `DEPLOYMENT_SOVEREIGNTY_CHECKLIST.md` pilot section
- Notify admin portal team (Priority 2) when scale approved

---

## Approved & Ready for Scale — Proclamation Template

```
The Kuttiomp pilot cohort [ID] has been reviewed by the Knowledge Keepers Council.
All journey steps were observed with protocol compliance.
Status: Approved & Ready for Scale
Protocol coverage: 100%
Action: Proceed to community device deployment and living corpus seeding.
Blessing: May this infrastructure carry our language with the same care
and respect as our oral tradition itself.
```

---

**Next chapter after sign-off:** Priority 3 — Living corpus seeding with approved elder recordings.