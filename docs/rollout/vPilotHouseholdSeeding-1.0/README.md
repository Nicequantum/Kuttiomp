# Kuttiomp vPilotHouseholdSeeding-1.0 — First Live Household Cohort Activation

**Ratified:** 2026-07-05 | **Household:** HH01 (Little Ones iPad + Elder phone)  
**Extends:** vPilotCohortDocs-1.0 + vPilotLive-1.0

---

## Activation Covenant

Recruit, equip, and monitor **Household 1** through the complete 7-day cycle under live Keeper council oversight.

| Step | Action | Mobile / RPC |
|------|--------|--------------|
| 1 | Keeper recruitment call + consent | `createHouseholdSeedClaim` |
| 2 | Printed packet + QR bundle delivery | `device_pairing_qr_bundle.zipspec.md` |
| 3 | iPad scan → Little Ones mode + Elder paired claim | `pairDevices()` |
| 4 | Days 1–7 live observations | `submitLiveObservation()` |
| 5 | Day 3 Keeper media review | `/keeper-pilot-signoff` |
| 6 | Day 7 sign-off + reflection seed | `completeHouseholdSeeding()` |

## Artifact Index

| Document | Path |
|----------|------|
| Recruitment script | [`household_1_onboarding/recruitment_call_script.md`](household_1_onboarding/recruitment_call_script.md) |
| Distribution checklist | [`household_1_onboarding/printed_packet_distribution_checklist.md`](household_1_onboarding/printed_packet_distribution_checklist.md) |
| QR pairing bundle | [`household_1_onboarding/device_pairing_qr_bundle.zipspec.md`](household_1_onboarding/device_pairing_qr_bundle.zipspec.md) |
| 7-day execution plan | [`live_7day_execution_plan.md`](live_7day_execution_plan.md) |
| Seeding checklist | [`seeding_checklist.json`](seeding_checklist.json) |
| Maintainer guide | [`TribalMaintainerGuide_Seeding.md`](TribalMaintainerGuide_Seeding.md) |
| Keeper council extension | [`keeper_council_dashboard_extension.md`](keeper_council_dashboard_extension.md) |

## Verification

```bash
cd apps/mobile
flutter test test/pilot_live/ --name "household_seeding|cohort_docs"
./scripts/generate_onboarding_pdfs.sh --voice-narrate --household=HH01
./scripts/pilot_simulation_runner.sh --with-seeding --live-device-mode --household=HH01
```

## Ratification Stamp

```
=== Kuttiomp vPilotHouseholdSeeding-1.0 Ratification ===
Household: HH01 | Cohort: pilot-household-1-2026
Outcome: Household 1 successfully completed under full sovereignty
The first family now walks the path.
=======================================================
```