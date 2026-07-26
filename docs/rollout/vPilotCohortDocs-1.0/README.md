# Kuttiomp vPilotCohortDocs-1.0 — Pilot Cohort Support Documentation

**Ratified:** 2026-07-05 | **Mobile base:** v2.3.0+1 (frozen) | **Extends:** vPilotLive-1.0

This package furnishes participating households and Keepers with elder-approved, protocol-enforced guidance maintainable by a tribal team of 3–5 through 2050 (Protocol 12).

---

## Artifact Index

| Document | Path | Protocols |
|----------|------|-----------|
| Household onboarding packet | [`household_onboarding_packet_v1.md`](household_onboarding_packet_v1.md) | 2, 7, 11 |
| Little Ones iPad template | [`device_logging_templates/little_ones_ipad_template.pdfspec.md`](device_logging_templates/little_ones_ipad_template.pdfspec.md) | 3, 7, 11 |
| Young Learner phone template | [`device_logging_templates/young_learner_phone_template.md`](device_logging_templates/young_learner_phone_template.md) | 3, 7, 11 |
| Core Adult template | [`device_logging_templates/core_adult_template.md`](device_logging_templates/core_adult_template.md) | 3, 9, 11 |
| Elder phone template | [`device_logging_templates/elder_phone_template.md`](device_logging_templates/elder_phone_template.md) | 2, 7, 11 |
| 7-day Keeper calendar | [`keeper_7day_review_calendar.md`](keeper_7day_review_calendar.md) | 2, 8, 9 |
| Onboarding audio script (l10n) | [`templates/onboarding_audio_script.arb`](templates/onboarding_audio_script.arb) | 2, 7 |
| Keeper sign-off checklist | [`templates/keeper_signoff_checklist.json`](templates/keeper_signoff_checklist.json) | 1–12 |
| Tribal maintainer guide | [`TribalMaintainerGuide.md`](TribalMaintainerGuide.md) | 12 |

## Code Integration Points

| Mobile module | Path |
|---------------|------|
| Live pilot service | `apps/mobile/lib/features/pilot_live/pilot_live_service.dart` |
| Pilot feedback (live observations) | `apps/mobile/lib/rollout/pilot_feedback_service.dart` |
| In-app logging UI | `apps/mobile/lib/features/pilot_live/presentation/pilot_feedback_logger.dart` |
| Keeper sign-off | `apps/mobile/lib/features/pilot_live/presentation/keeper_live_signoff_view.dart` |
| Offline log store | `apps/mobile/lib/features/pilot_live/data/pilot_live_log_store.dart` |

## Verification

```bash
cd apps/mobile
flutter test test/pilot_live/ --name cohort_docs
./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate
```

## Ratification Stamp

```
=== Kuttiomp vPilotCohortDocs-1.0 Ratification ===
Constitution: v2.3.0+1 (unchanged)
Protocols affirmed: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
Outcome: CohortDocs-1.0 rendered under full 12-protocol compliance
The pilot is embodied, documented, and ready for the first families.
================================================
```