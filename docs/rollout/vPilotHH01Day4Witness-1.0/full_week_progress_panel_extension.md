# Full Week Progress Panel Extension

**vPilotHH01Day4Witness-1.0 | Canonical: `lib/features/pilot_live/presentation/full_cycle_progress_panel.dart`**

## UI Spec

| Element | Behavior |
|---------|----------|
| Header | `X/7 days walked under sovereignty` |
| Day 3 media review | Green check when unlocked |
| Day 3 sign-off | Green check when complete |
| Day 4 council witness | Green check when `day4WitnessConfirmed` |
| Day 7 reflection prep | Shows when draft prepared (gated) |
| Day chips D1–D7 | ✓ green when complete; 🔒 grey when locked |

## Chip Lock Logic

```dart
progress.isDayChipLocked(day) // true when prior days incomplete
```

Day 5 chip locked until Day 4 witnessed and logged.

## Riverpod Bindings

| Provider | Source |
|----------|--------|
| `fullCycleProgressProvider` | `FullCycleStore.instance.progress` |
| `day3MediaReviewUnlockedProvider` | `CovenantProgressTracker.isDay3MediaReviewUnlocked` |
| `day7ReflectionPrepReadyProvider` | `ReflectionPrepStore.instance.isPrepared` |