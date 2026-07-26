# Tribal Maintainer Guide — Community Rollout (vRollout-1.0)

**Onboarding target:** < 20 minutes (extends v2.3.0+1 without modifying mobile constitution).

## Purpose

Prove the day-in-the-life journey in pilot households before community scale (§1 validation).

## Quick Navigation

1. `docs/rollout/pilot_playbook.md` — cohort plan, device matrix, 7-day schedule
2. `docs/rollout/journey_logging_template.md` — observation forms
3. `docs/rollout/keeper_signoff_workflow.md` — post-pilot Keeper review
4. `lib/rollout/pilot_feedback_service.dart` — `submitPilotObservation()`, `recordKeeperSignoff()`
5. `lib/rollout/pilot_simulation_runner.dart` — device matrix simulation
6. `scripts/pilot_simulation_runner.sh` — one-command simulation

## Verify

```bash
cd apps/mobile
./scripts/pilot_simulation_runner.sh
flutter test test/rollout/
```

**(Protocol 12 compliance verified — mobile constitution unchanged)**