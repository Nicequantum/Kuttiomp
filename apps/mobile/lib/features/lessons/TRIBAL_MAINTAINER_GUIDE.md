# Tribal Maintainer Guide – Lessons Module

**Onboarding target:** one hour (Protocol 12)  
**Constitution:** MAD v2.0 §§4, 6, 7 — parity with Phrases; **Protocol 4 sacred care**

## Directory map

```
features/lessons/
├── data/
│   ├── lessons_repository.dart      # AuditedRepository + offline mirror
│   └── isar_lesson_collection.dart  # Sacred consent + purge on violation
├── domain/
│   ├── lesson.dart                  # LessonModel (hand-written immutable)
│   └── lesson_model.dart            # barrel export
└── presentation/
    ├── lesson_card.dart             # KuttiompContentWidget + SacredContentLocker
    ├── lessons_list_screen.dart     # ModeAwareShell; filters ceremonial for non-elder
    └── lesson_detail_screen.dart    # KuttiompDetailViewShell + consent
```

**Providers:** `core/di/lesson_providers.dart` (locked foundation)  
**Routes:** `/lessons`, `/lesson/:id`

## Protocol 4 (mandatory)

| Rule | Implementation |
|------|----------------|
| Sacred/ceremonial never auto-renders | `SacredContentLockerWidget` on card/detail |
| Offline requires re-auth + consent | `IsarLessonCollection.syncFromRepository` |
| Consent denied | `reportAndPurgeSacredViolation` (local delete + audit) |
| Public lists exclude ceremonial for non-elder | `LessonsListScreen` filter |
| Stewardship excludes sacred | Living corpus filter uses non-sacred lexemes only |

## One-hour path

1. Read `domain/lesson.dart` — `ceremonialFlag`, audio blocks, stages.
2. Trace `data/lessons_repository.dart` + `isar_lesson_collection.dart`.
3. UI: list → card → detail with oral sequence.
4. Verify:

```bash
cd apps/mobile
flutter test test/features/lessons/
flutter test test/offline/lesson_offline_sync_test.dart
dart run scripts/dignity_lint.dart
```

**(Protocol 12 compliance verified)**