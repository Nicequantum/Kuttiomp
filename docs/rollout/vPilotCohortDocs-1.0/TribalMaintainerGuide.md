# Tribal Maintainer Guide — Pilot Cohort Documentation (vPilotCohortDocs-1.0)

**Onboarding target:** < 60 minutes for any new team member

---

## Purpose

Equip households and Keepers with printable, voice-narrated, protocol-enforced pilot materials — maintainable by 3–5 stewards through 2050 without architectural debt (Protocol 12).

---

## 60-Minute Onboarding Map

| Minutes | Task |
|---------|------|
| 0–10 | Read [`README.md`](README.md) + ratification stamp |
| 10–20 | Print [`household_onboarding_packet_v1.md`](household_onboarding_packet_v1.md) |
| 20–30 | Match households to `device_logging_templates/` |
| 30–40 | Walk Keeper through [`keeper_7day_review_calendar.md`](keeper_7day_review_calendar.md) |
| 40–50 | Run `./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate` |
| 50–60 | Verify: `flutter test test/pilot_live/ --name cohort_docs` |

---

## Generate Household Packets

```bash
cd apps/mobile
./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate
```

Outputs validation report; PDF rendering uses tribal print toolchain (Markdown → PDF).

---

## Distribute to Cohort

1. Pilot Coordinator prints onboarding packet per household
2. Attach correct device template (Little Ones / Youth / Adult / Elder)
3. Collect signed consent + Keeper witness signature
4. Technology Steward confirms app routes: `/pilot-logging`, `/keeper-pilot-signoff`

---

## Code Cross-Reference

| Doc action | Mobile implementation |
|------------|----------------------|
| Log observation | `PilotLiveService.submitLiveObservation()` |
| Offline queue | `PilotLiveLogStore` |
| Keeper notified | `KeeperLiveSignoffNotifier.notify()` |
| Sign-off | `recordKeeperSignoffWithMedia()` |
| Checklist schema | `templates/keeper_signoff_checklist.json` |

---

## Verify Full Stack

```bash
cd apps/mobile
flutter test test/pilot_live/ --name cohort_docs
./scripts/pilot_simulation_runner.sh --with-seeding --live-device-mode
```

**(Protocol 12 compliance verified — mobile constitution unchanged)**