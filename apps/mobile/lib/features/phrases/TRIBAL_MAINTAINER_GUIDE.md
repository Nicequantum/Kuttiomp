# Tribal Maintainer Guide – Phrases Module

**Onboarding target:** one hour (Protocol 12)  
**Constitution:** MAD v2.0 §§4, 6, 7 — parity with Lexeme

## Directory map

```
features/phrases/
├── data/
│   ├── phrases_repository.dart   # AuditedRepository + RPC + offline
│   └── isar_phrase_collection.dart
├── domain/
│   ├── phrase.dart               # PhraseModel (hand-written immutable)
│   └── phrase_model.dart         # barrel export
└── presentation/
    ├── phrase_card.dart          # KuttiompContentWidget
    ├── phrases_list_screen.dart  # ModeAwareShell.forContentList
    └── phrase_detail_screen.dart # KuttiompDetailViewShell
```

**Providers:** `core/di/phrase_providers.dart` (locked foundation)  
**Routes:** `/phrases`, `/phrase/:id`

## One-hour path

1. Read `domain/phrase.dart` — protocol fields (speaker, elder, clan, oral, land).
2. Trace `data/phrases_repository.dart` — RPC then offline mirror.
3. UI: list → card → detail guards (same stack as Lexeme).
4. Verify:

```bash
cd apps/mobile
flutter test test/features/phrases/
flutter test test/offline/phrase_offline_sync_test.dart
dart run scripts/dignity_lint.dart
```

## Protocol table

| Protocol | Artifact |
|----------|----------|
| 1 Speaker | `speakerMetadata` on model + card |
| 2 Elder | `elderApproved` + `ApprovedContentGate` |
| 3 Tiers | `visibleToTiers` + `ModeTierGuard` |
| 4 Sacred | `sacredFlag` + `SacredContentLockerWidget` |
| 5 Clan | `clanScope` + gateway filter |
| 6 Land | `landContext` + `GeoContextBadge` |
| 7 Oral | `primaryAudioId` + `OralFirstPlayer` |
| 8 Authority | `AuthorityBadge` + decorator |
| 9 Audit | `AuditedRepository` logs |

**(Protocol 12 compliance verified)**