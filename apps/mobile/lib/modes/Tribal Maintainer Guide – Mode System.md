# Tribal Maintainer Guide – Mode System

**Onboarding target:** one hour (Protocol 12)  
**Constitution:** Kuttiomp Master Architecture Document v2.0, §§5, 13, 4, 7

---

## Cultural Acknowledgment

The Mode System ensures every generation — from Little Ones to Elders — experiences Narragansett language content in a culturally respectful, accessible context. Mode switching is instantaneous (< 300 ms), sovereign, and permanently auditable.

---

## Directory Map (ratified §5)

```
lib/modes/
├── content_renderer.dart          # ContentRenderer.adaptForMode() strategy
├── mode_aware_material_app.dart   # Root MaterialApp.router + theme
├── mode_aware_shell.dart          # ModeTierGuard + adaptForMode wrapper
├── mode_persistence.dart          # SharedPreferences + Isar mirror hook
├── mode_shell_scaffold.dart       # Bottom nav + long-press narration
├── mode_visual_strategy.dart      # Strategy interface
├── little_ones/
│   ├── overrides/visual_strategy.dart
│   └── visual_strategy.dart       # Canonical export
├── young_learner/
│   ├── overrides/visual_strategy.dart
│   └── visual_strategy.dart
├── core_adult/
│   ├── overrides/visual_strategy.dart
│   └── visual_strategy.dart
└── elder/
    ├── voice_narrative_strategy.dart
    ├── accessibility_overlay.dart  # ElderModeOverlay (Protocol 11)
    └── TRIBAL_MAINTAINER_GUIDE.md

lib/core/mode/                       # Canonical exports (Command 2)
├── mode_controller.dart
├── mode_redirect_middleware.dart
└── mode_aware_material_app.dart
```

---

## Bootstrap Sequence (main.dart → app.dart)

```
WidgetsFlutterBinding.ensureInitialized()
  → AppBootstrap.initialize()
      1. ProtocolService.init()          # 12 guards armed
      2. Supabase Auth + AuditedClient   # Protocol 9
      3. Isar encrypted mirror           # §7
      4. ModeController.bootstrap()      # default Little Ones
      5. Profile sync (user_profiles)
      6. OfflineWorker
      7. FirstLaunchService
  → ProviderScope(overrides)
  → ModeAwareMaterialApp
      → GoRouter (StatefulShellRoute + PageStorageBucket)
      → KuttiompThemeExtension.forMode(currentMode)
```

---

## Riverpod / GoRouter Navigation Diagram

```mermaid
flowchart TD
    A[ModeController AsyncNotifier] -->|watch| B[ModeAwareMaterialApp]
    B -->|theme| C[KuttiompThemeExtension.forMode]
    A -->|refresh| D[GoRouter]
    D --> E[ModeRedirectMiddleware]
    E -->|first launch| F[/first-launch]
    E -->|tier OK| G[StatefulShellRoute]
    G --> H[PageStorageBucket]
    H --> I[ModeShellScaffold]
    I --> J[DashboardScreen]
    J --> K[ModeAwareShell]
    K --> L[ModeTierGuard]
    L --> M[ContentRenderer.adaptForMode]
    D --> N[Detail routes]
    N --> O[KuttiompDetailViewShell]
    O --> M
```

---

## Mode Switch Flow (§13)

1. User taps **Switch Mode** FAB or long-presses for audio narration.
2. `ModePersistenceService.persistAndSyncMode()`:
   - `ModePersistence.saveMode()` (SharedPreferences)
   - `mirrorModeToIsar()` (encrypted mirror key + audit log)
   - `authService.syncModeClaim()` (JWT)
   - `profileRepository.updateMode()` (Supabase `user_profiles`)
   - `ModeController.switchMode()` → `protocolService.enforceNewMode()`
3. `GoRouter.refresh()` + `FadeScaleTransition` (< 300 ms).
4. Scoped providers invalidate; scroll state preserved via `PageStorageBucket`.

**Elder remote override:** `ModePersistenceService.applyElderOverride()` — audited Protocol 9.

---

## Integration Checklist

| Surface | Guard stack |
|---------|-------------|
| Dashboard petals | `DashboardScreen` → `ModeAwareShell.forDashboard` |
| Content lists | `LexemesScreen` / `PhrasesScreen` / `LessonsScreen` → `ModeAwareShell.forContentList` |
| Detail routes | `KuttiompDetailViewShell` (Command 1) |
| Router pages | `_TierGatedShell` + `ApprovedContentGate` |
| Shell chrome | `ModeShellScaffold` + `KuttiompThemeExtension` |

---

## Protocol Cross-References

| Protocol | Mode System artifact |
|----------|-------------------|
| 3 Generational Tiers | `ModeTierGuard`, `ModeRedirectMiddleware`, `TierAwarePage` |
| 9 Data Sovereignty | `ModePersistenceService` audit log, Isar mirror |
| 11 Accessibility | `ElderModeOverlay`, 32pt Elder typography |
| 12 Long-Term Integrity | This guide + `render_all_modes_test.dart` |

---

## Verify

```bash
cd apps/mobile
flutter test test/mode_consistency/render_all_modes_test.dart
flutter test test/mode_consistency/render_all_modes_test.dart --update-goldens
flutter test test/offline/mode_persistence_offline_test.dart
flutter test test/protocol_compliance/design_system_protocol_test.dart
```

---

**(Protocol 12 compliance verified)**