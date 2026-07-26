# Kuttiomp Pilot Playbook — vRollout-1.0

**Community Rollout Simulation & Pilot Cohort Validation**

This playbook proves the §1 day-in-the-life journey in real Narragansett households before broader deployment. The mobile constitution (v2.3.0+1) remains frozen; this work extends *around* the longhouse.

---

## Cohort Design

**Target:** 10 households across four generational paths (expandable after first wave).

| Household # | Mode | Primary device | Observer |
|-------------|------|----------------|----------|
| 1–3 | Little Ones | Family iPad | Parent/caregiver |
| 4–5 | Young Learner | Youth Android tablet | Learner + parent |
| 6–7 | Core Adult | Android phone | Tribal member |
| 8–10 | Elder | Elder Android phone (large text) | Elder/Keeper |

## Recruitment Criteria

- Narragansett household or tribal member household committed to language use
- Willingness to complete 7-day observation period
- Signed tribal consent for anonymized journey logging (no sacred content in screenshots)
- At least one household per mastery stage interest (awakening through deepening)

## Consent Flows

1. **Household consent** — verbal + written tribal consent form (Keeper provides)
2. **Screenshot consent** — UI-only captures; no sacred/ceremonial screens
3. **Voice feedback consent** — optional elder voice notes via `primary_audio_id` attribution
4. **Data sovereignty** — all logs via `submit_pilot_feedback_secure` RPC only; no direct table access

## 7-Day Pilot Schedule

| Day | Focus | Journey steps |
|-----|-------|---------------|
| 1 | First launch | onboarding, mode_switch |
| 2 | Discovery | search_land, dashboard petals |
| 3 | Learning | lesson_complete, lexeme browse |
| 4 | Conversation | phrases, land context |
| 5 | Elder path | elder_contribute, keeper_approve (Elder households) |
| 6 | Resilience | offline_toggle, sacred consent |
| 7 | Reflection | profile_audit, journey debrief |

## Device Matrix Requirements

- **Elder Android phones:** 6"+ screen, TalkBack tested, 32pt+ effective font
- **Family iPads:** iOS 16+ or Android tablet equivalent
- **Youth devices:** Parental guidance; dignified visuals verified (Protocol 10)
- **Offline test:** Airplane mode for 30 minutes on Day 6

## Household Documentation (vPilotCohortDocs-1.0)

Print and distribute before Day 0:

- `docs/rollout/vPilotCohortDocs-1.0/household_onboarding_packet_v1.md`
- Device template matching household generation (`device_logging_templates/`)
- Keeper calendar: `keeper_7day_review_calendar.md`

Generate packets: `cd apps/mobile && ./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate`

## Tribal Team Roles

| Role | Responsibility |
|------|----------------|
| Pilot Coordinator | Recruits households, distributes devices |
| Journey Logger | Collects `journey_logging_template.md` forms |
| Keeper Council | Reviews feedback, executes sign-off workflow |
| Technology Steward | Runs `pilot_simulation_runner.sh`, monitors RPC logs |

## Simulation Before Live Pilot

```bash
cd apps/mobile
./scripts/pilot_simulation_runner.sh
```

Review generated report and `docs/rollout/journey_logging_template.md` before recruiting.

---

**Ratified:** vRollout-1.0 | Extends Kuttiomp v2.3.0+1 without modifying mobile constitution.