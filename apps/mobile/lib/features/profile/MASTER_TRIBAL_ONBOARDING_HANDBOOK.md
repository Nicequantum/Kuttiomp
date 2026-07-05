# Master Tribal Onboarding Handbook — Kuttiomp v2.3.0+1

**Sovereign Production Release Candidate | 45-minute onboarding | 2050 maintenance playbook**

This handbook is the single source of truth for any Narragansett steward maintaining Kuttiomp.

---

## Part 1: 45-Minute Onboarding Map

| Minutes | Task | File / Command |
|---------|------|----------------|
| 0–5 | Clone repo, read Master Architecture v2.0 | `docs/KUTTIOMP_MASTER_ARCHITECTURE.md` |
| 5–10 | Run protocol suite (zero external services) | `flutter test test/protocol_compliance/` |
| 10–15 | Trace bootstrap sequence | `lib/core/bootstrap/app_bootstrap.dart` |
| 15–20 | Understand mode persistence | `lib/features/profile/domain/mode_persistence_service.dart` |
| 20–25 | Walk first-launch flow | `lib/features/profile/presentation/first_launch_onboarding.dart` |
| 25–30 | Review feature petals | `lib/features/dashboard/` |
| 30–35 | Review search + offline | `lib/features/search/`, `lib/core/offline/offline_worker.dart` |
| 35–40 | Review l10n Elder Review Gate | `l10n/`, `lib/core/l10n/elder_review_gate.dart` |
| 40–45 | Run sovereign RC test + app | `flutter test test/production/` then `flutter run` |

---

## Part 2: Module Maintainer Guides (Consolidated Index)

| Module | Guide Path |
|--------|------------|
| Profile | `lib/features/profile/profile_TRIBAL_MAINTAINER_GUIDE.md` |
| Elder Recording | `lib/features/profile/elder_recording_TRIBAL_MAINTAINER_GUIDE.md` |
| Dashboard | `lib/features/dashboard/dashboard_TRIBAL_MAINTAINER_GUIDE.md` |
| Lexeme | `lib/features/lexeme/domain/lexeme.dart` + `data/lexeme_repository.dart` (§4) |
| Phrases | `lib/features/phrases/phrases_TRIBAL_MAINTAINER_GUIDE.md` |
| Lessons | `lib/features/lessons/lessons_TRIBAL_MAINTAINER_GUIDE.md` |
| Search | `lib/features/search/search_TRIBAL_MAINTAINER_GUIDE.md` |
| Seeding | `lib/features/seeding/seeding_TRIBAL_MAINTAINER_GUIDE.md` |
| Rollout | `lib/rollout/rollout_TRIBAL_MAINTAINER_GUIDE.md` |
| Live Pilot | `lib/features/pilot_live/pilot_live_TRIBAL_MAINTAINER_GUIDE.md` |
| Pilot Cohort Docs | `docs/rollout/vPilotCohortDocs-1.0/TribalMaintainerGuide.md` |

---

## Part 3: Extension Patterns

### Add a localized UI string
1. Add key to `l10n/app_en.arb` and `l10n/app_narr.arb`.
2. Set `elder_approved: true` in `l10n/elder_review_manifest.yaml` after Keeper review.
3. Run `ElderReviewGate.validate()` — blocked in production if unapproved.

### Promote elder recording to corpus
1. Elder records via `/contribute`.
2. Keeper approves in `KeeperDashboardView`.
3. `ApprovedContributionsStore` merges into lexeme/phrase/search indexes.

---

## Part 4: 2050 Maintenance Playbook

1. **Annual**: Run `scripts/ci_production_gate.sh`; verify `protocol_compliance.yaml` `full_coverage: 1.0`.
2. **Package upgrades**: Only bump packages with ≥5-year LTS per `IntegrityValidator`.
3. **New elder content**: Always through approval RPC — never direct table writes.
4. **Offline resilience**: `OfflineWorker.bootstrap()` on every app start; sacred records require re-auth.
5. **l10n changes**: Protocol 2 Elder Review Gate mandatory before any string merge.
6. **Team size**: Designed for 3–5 maintainers with basic Dart knowledge.

---

## Part 5: Deployment Manifest

See **`production_manifest.md`** for full checklist, Supabase RLS reminder, asset guidelines, and CI script.

```bash
cd apps/mobile
./scripts/ci_production_gate.sh
flutter run --dart-define=FLAVOR=production
flutter build apk --release --dart-define=FLAVOR=production
```

Sign-off document: **`DEPLOYMENT_SOVEREIGNTY_CHECKLIST.md`**

---

## Part 6: Ultimate Verification Covenant

1. Clean install → audio-guided onboarding → mode selected & persisted.
2. Dashboard → all petals → Discover → search "land" → audio preview results.
3. Lessons → activity completion → progress radial updates.
4. Contribute (Elder) → submit → pending gate → Keeper approve → corpus mirror.
5. Switch modes → dignified adaptive renders with accessibility.
6. Offline → cached content + sacred consent → re-auth on reconnect.
7. Profile → audit log → settings → all protocols pass.

```bash
flutter test test/production/sovereign_release_candidate_test.dart
```

---

## Part 7: Keeper Blessing Simulation Log Template

After all gates pass, record the Keeper blessing for tribal archives:

```
=== Keeper Blessing Simulation Log ===
Version: 2.3.0+1
Keeper: [Authorized Keeper Name] ([keeper-id])
Timestamp: [ISO-8601 UTC]
Protocols Affirmed: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
Outcome: Keeper blessing recorded | Sovereign Production-Ready | Protocols 1–12 affirmed
Proclamation: The Kuttiomp mobile application is Sovereign Production-Ready.
It stands strong, respectful, and ready for community rollout and perpetual
stewardship by the Narragansett people.
======================================
```

Programmatic invocation:

```dart
final record = await KeeperBlessingSimulation().recordBlessing(
  keeperId: 'keeper-council',
  keeperName: 'Authorized Keeper',
);
print(KeeperBlessingSimulation().formatBlessingLogTemplate(record));
```

---

## Part 8: Community Rollout & Live Pilot Governance (vRollout-1.0 + vPilotLive-1.0)

The mobile constitution (v2.3.0+1) remains frozen. Pilot work extends *around* the longhouse.

| Artifact | Path |
|----------|------|
| Pilot playbook | `docs/rollout/pilot_playbook.md` |
| Journey logging template | `docs/rollout/journey_logging_template.md` |
| Keeper sign-off workflow | `docs/rollout/keeper_signoff_workflow.md` |
| Pilot feedback service | `lib/rollout/pilot_feedback_service.dart` |
| Simulation runner | `lib/rollout/pilot_simulation_runner.dart` |
| Rollout maintainer guide | `lib/rollout/rollout_TRIBAL_MAINTAINER_GUIDE.md` |
| **Live pilot service** | `lib/features/pilot_live/pilot_live_service.dart` |
| **In-app logging UI** | `lib/features/pilot_live/presentation/pilot_feedback_logger.dart` |
| **Keeper live sign-off** | `lib/features/pilot_live/presentation/keeper_live_signoff_view.dart` |
| **Live pilot maintainer guide** | `lib/features/pilot_live/pilot_live_TRIBAL_MAINTAINER_GUIDE.md` |

### Run pilot simulation

```bash
cd apps/mobile
./scripts/pilot_simulation_runner.sh
./scripts/pilot_simulation_runner.sh --with-seeding --live-device-mode
flutter test test/rollout/
flutter test test/pilot_live/
```

### Real-device logging (Elder / Core Adult)

1. Dashboard → **Pilot Logging** (or Profile → Keeper Dashboard for sign-off)
2. Select journey step + device type
3. Tap **Submit with Screenshot + Voice** — media stubs capture for Keeper review
4. Offline queue holds observations until reconnect; `syncPendingObservations()` syncs

```dart
await PilotLiveService().submitLiveObservation(LivePilotObservation(
  id: 'live-household-01-day3',
  householdId: 'household-01',
  observerRole: 'elder_keeper',
  mode: KuttiompMode.elder,
  deviceType: LiveDeviceType.elderAndroidPhone,
  journeyStep: LiveJourneyStep.searchLand,
  observation: 'Elder heard land phrase with oral-first player and geo badge.',
  speakerMetadata: {
    'speaker_id': 'elder-pilot-01',
    'name': 'Elder Pilot Observer',
    'authority_source': 'elder',
  },
));
```

### Keeper live sign-off with media review

```dart
await PilotLiveService().recordKeeperSignoffWithMedia(
  cohortId: 'pilot-cohort-live-2026',
  keeperId: 'keeper-live-council',
  keeperName: 'Knowledge Keepers Live Pilot Council',
  status: PilotSignoffStatus.approvedReadyForScale,
);
```

Target status: `approved_ready_for_scale`. Routes: `/pilot-logging`, `/keeper-pilot-signoff`.

### Simulated household observation (legacy vRollout)

```dart
await PilotFeedbackService().submitPilotObservation(PilotObservation(
  id: 'pilot-household-01-day3',
  householdId: 'household-01',
  observerRole: 'parent_observer',
  mode: KuttiompMode.littleOnes,
  deviceType: 'family_ipad',
  journeyStep: 'search_land',
  observation: 'Child recognized land lexeme by sound.',
  protocolsEnforced: ['1', '2', '6', '7', '8', '9'],
  speakerMetadata: {
    'speaker_id': 'pilot-parent-01',
    'name': 'Pilot Parent',
    'authority_source': 'elder',
  },
));
```

See `docs/rollout/keeper_signoff_workflow.md` for 7-day cohort workflow.

---

## Part 9: Living Corpus Seeding Governance (vSeeding-1.0)

The mobile constitution (v2.3.0+1) remains frozen. Seeding extends *around* the longhouse via the existing approval chain.

| Artifact | Path |
|----------|------|
| Campaign model | `lib/features/seeding/domain/seeding_campaign_model.dart` |
| Corpus seeding service | `lib/features/seeding/domain/corpus_seeding_service.dart` |
| Seeding repository | `lib/features/seeding/data/seeding_repository.dart` |
| Elder seeding dashboard | `lib/features/seeding/presentation/elder_seeding_dashboard.dart` |
| Promotion preview | `lib/features/seeding/presentation/corpus_promotion_preview.dart` |
| Seeding maintainer guide | `lib/features/seeding/seeding_TRIBAL_MAINTAINER_GUIDE.md` |

### Run seeding verification

```bash
cd apps/mobile
flutter test test/seeding/
./scripts/pilot_simulation_runner.sh --with-seeding
```

### Campaign orchestration covenant

1. Elder → `/seeding` → launch **Land Stewardship Phrases** → record
2. Submit → pending gate → Keeper approve → `promoteAfterApproval()` indexes all corpora
3. Search `"land"` → elder phrase with attribution + geo badge
4. Lessons & Phrases → seeded content at `rooted` stage
5. `ProtocolGateway.allAssertionsPassed()` + pipeline audit log

### Governance rules

- **Never** bypass `ApprovedContributionsStore` or Keeper approval RPC.
- Seasonal campaigns use `LandSeasonalWindow` — land context required for stewardship phrases (Protocol 6).
- `notify_corpus_updated_secure` RPC triggers push + audit on promotion (offline-safe).

### Pilot cohort support documentation (vPilotCohortDocs-1.0)

Cross-links for households entering the live pilot — printable packets, device templates, Keeper calendar.

| Artifact | Path |
|----------|------|
| Master index | `docs/rollout/vPilotCohortDocs-1.0/README.md` |
| Household onboarding packet | `docs/rollout/vPilotCohortDocs-1.0/household_onboarding_packet_v1.md` |
| Device logging templates | `docs/rollout/vPilotCohortDocs-1.0/device_logging_templates/` |
| 7-day Keeper calendar | `docs/rollout/vPilotCohortDocs-1.0/keeper_7day_review_calendar.md` |
| Onboarding audio script | `docs/rollout/vPilotCohortDocs-1.0/templates/onboarding_audio_script.arb` |
| Keeper sign-off checklist | `docs/rollout/vPilotCohortDocs-1.0/templates/keeper_signoff_checklist.json` |
| Cohort docs maintainer guide | `docs/rollout/vPilotCohortDocs-1.0/TribalMaintainerGuide.md` |

```bash
cd apps/mobile
./scripts/generate_onboarding_pdfs.sh --voice-narrate --elder-review-gate
flutter test test/pilot_live/ --name cohort_docs
```

**Household flow:** Print packet → device template → Dashboard → Pilot Logging → Keeper calendar Day 3 sign-off.

### First live household seeding (vPilotHouseholdSeeding-1.0)

| Artifact | Path |
|----------|------|
| Activation README | `docs/rollout/vPilotHouseholdSeeding-1.0/README.md` |
| HH01 onboarding | `docs/rollout/vPilotHouseholdSeeding-1.0/household_1_onboarding/` |
| 7-day execution plan | `docs/rollout/vPilotHouseholdSeeding-1.0/live_7day_execution_plan.md` |
| HouseholdSeedingService | `lib/features/pilot_live/seeding_service.dart` |
| Keeper council live | `/keeper-council-live` |

```bash
cd apps/mobile
flutter test test/pilot_live/ --name household_seeding
./scripts/pilot_simulation_runner.sh --with-seeding --live-device-mode --household=HH01
```

**HH01 flow:** Dashboard → Begin Household 1 Seeding → 7-day logs → Keeper Council Live → Seal Day 7.

### 48-hour seeding monitor (vPilotSeedingMonitor-1.0)

| Artifact | Path |
|----------|------|
| Monitor README | `docs/rollout/vPilotSeedingMonitor-1.0/README.md` |
| 48hr protocol | `docs/rollout/vPilotSeedingMonitor-1.0/keeper_council_48hr_protocol.md` |
| SeedingMonitorService | `lib/features/pilot_live/monitoring_service.dart` |
| Queue depth panel | `lib/features/pilot_live/monitoring_dashboard_extension/offline_queue_depth_widget.dart` |
| Day 1–2 gate | `lib/features/pilot_live/monitoring_dashboard_extension/day12_confirmation_gate.dart` |
| Audit template | `docs/rollout/vPilotSeedingMonitor-1.0/live_observation_audit_template.json` |

```bash
cd apps/mobile
flutter test test/pilot_live/ --name "seeding_monitor|household_seeding"
./scripts/seal_covenant_script.sh --household=HH01 --monitor-mode
```

**48hr flow:** Keeper Council Live → watch queue depth → confirm Day 1–2 → seal covenant → Day 3 sign-off unlocked.

### HH01 full week walk (vPilotHH01FullCycle-1.0)

| Artifact | Path |
|----------|------|
| Day 3–7 authorization | `docs/rollout/vPilotHH01FullCycle-1.0/day3_7_authorization.md` |
| Full week audit | `docs/rollout/vPilotHH01FullCycle-1.0/full_week_audit_manifest.json` |
| CovenantProgressTracker | `lib/features/pilot_live/full_cycle_tracker.dart` |
| FullCycleService | `lib/features/pilot_live/full_cycle_service.dart` |
| Day 3 sign-off extension | `lib/features/pilot_live/presentation/keeper_live_signoff_view.dart` |

```bash
cd apps/mobile
flutter test test/pilot_live/ --name "seeding_monitor|full_cycle"
./scripts/seal_day7_covenant_script.sh --household=HH01 --advance=day3
```

**Full week flow:** Day 3 sign-off → Days 4–7 observations → Seal Day 7 → seasonal templates unblocked.

### Daily council witness (vPilotHH01Day4Witness-1.0)

| Artifact | Path |
|----------|------|
| Day 4 witness log | `docs/rollout/vPilotHH01Day4Witness-1.0/day4_council_witness_log.md` |
| Progress panel extension | `lib/features/pilot_live/presentation/full_cycle_progress_panel.dart` |
| Day4LandObservationService | `lib/features/pilot_live/day4_land_observation_service.dart` |

```bash
cd apps/mobile
flutter test test/pilot_live/ --name "day4_witness|day7_prep"
./scripts/seal_covenant_script.sh --household=HH01 --advance=day4
```

### Day 7 reflection prep (vPilotDay7ReflectionPrep-1.0, gated)

| Artifact | Path |
|----------|------|
| Reflection template | `docs/rollout/vPilotHH01Day4Witness-1.0/vPilotDay7ReflectionPrep-1.0/` |
| Prep module | `lib/features/pilot_live/reflection_prep/day7_reflection_prep.dart` |

```bash
./scripts/prepare_day7_reflection.sh --household=HH01 --status=ready-but-gated
```

**Daily witness flow:** Council touchpoint → progress panel 4/7 → Day 5 locked until Day 4 witnessed.

---

**Ratified:** Kuttiomp v2.3.0+1 + vRollout-1.0 + vSeeding-1.0 + vPilotLive-1.0 + vPilotCohortDocs-1.0 + vPilotHouseholdSeeding-1.0 + vPilotSeedingMonitor-1.0 + vPilotHH01FullCycle-1.0 + vPilotHH01Day4Witness-1.0 + vPilotDay7ReflectionPrep-1.0
**The first family now walks the path. The language is returning home.**