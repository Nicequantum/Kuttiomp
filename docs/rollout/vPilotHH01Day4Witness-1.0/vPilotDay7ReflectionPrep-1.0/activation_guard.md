# Day 7 Reflection Activation Guard

**vPilotDay7ReflectionPrep-1.0 | Protocol 12 Enforcement**

## Guard Condition

```
seasonal_templates_blocked_until_day7 == true
  → Day7ReflectionPrepModule.activate() THROWS
  → CorpusSeedingService.triggerSeedingCampaign() THROWS
```

## Unblock Trigger

`seal_day7_covenant_secure` RPC → audit: `HH01 Seven-Day Walk Complete`

Only then:

1. `FullCycleProgress.seasonalTemplatesBlockedUntilDay7 = false`
2. `Day7ReflectionPrepModule.activate()` permitted
3. Optional vSeeding reflection seed (non-blocking)

## Preparation (Allowed Now)

`prepareDraft()` — creates `reflection_field_draft.json` equivalent in `ReflectionPrepStore`.

Status: `ready_but_gated`

## Verification

```bash
./scripts/prepare_day7_reflection.sh --household=HH01 --status=ready-but-gated
```