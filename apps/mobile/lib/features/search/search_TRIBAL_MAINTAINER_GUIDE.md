# Tribal Maintainer Guide – Search Feature (v2.1.0+1)

**Onboarding target:** < 30 minutes.

## Purpose

Unified discovery layer across lexemes, phrases, and lessons with clan, tier, sacred, and land filters (§4, Protocols 1,4,5,6,7,9). The global search bar in `ModeShellScaffold` and the Dashboard Discover petal both route to `/search`.

## Quick Navigation

**Search `search_repository` to see audited RPC flow; onboarding <30 minutes.**

1. Open `lib/features/search/data/search_repository.dart` → `search()` merges lexeme/phrase/lesson/elder sources.
2. Open `lib/features/search/domain/search_model.dart` → re-exports `SearchResultModel` + `SearchContentType`.
3. Open `lib/features/search/domain/search_service.dart` → `discover()`, ranking, four mode strategies, voice-first preview.
4. Open `lib/features/search/presentation/search_page.dart` → `TierAwarePage` + full guard stack.
5. Open `lib/features/search/presentation/search_result_card.dart` → `OralFirstPlayer` + `GeoContextBadge` + sacred badge.
6. Open `lib/features/search/domain/search_providers.dart` → `searchFilterProvider` (dashboard Discover petal).
7. Open `lib/core/offline/offline_worker.dart` → bootstrap sync with sacred/clan consent + quota.

## Data Flow

1. Dashboard Discover petal or shell search bar → `searchFilterProvider` + `/search` (`SearchPage`).
2. RPC: `search_content_secure` (never direct tables); offline fallback delegates to feature repositories.
3. Every search logs: `Search executed | Protocols 1,4,5,6,9 enforced`.
4. Result tap → `/lexeme/:id`, `/phrase/:id`, or `/lesson/:id` based on `content_type`.
5. Elder-approved contributions indexed via `ApprovedContributionsStore.approvedSearchResults()`.
6. `OfflineWorker.bootstrap()` mirrors search index during app startup (§7).

## Modification Patterns

- **Add a searchable content type:** extend `SearchContentType`, add repository delegation in `search_repository.dart`, update filter chips in `search_page.dart`.
- **Change ranking:** edit `SearchService.rankResults()` — never sort in the UI layer.
- **Change mode visuals:** edit strategy class in `search_service.dart`.
- **New protocol field:** add to `SearchResultModel`, `toContentContext()`, and `_assertSearchProtocols()`.

## Verify

```bash
cd apps/mobile
flutter test test/features/search/ --update-goldens
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
flutter test test/offline/
flutter run
```

Expected covenant:
1. Dashboard → Discover → query "land" → land results with filters, audio preview, attribution.
2. Mode switch → Elder shows narrative voice-first preview snippets.
3. Offline toggle → cached results; sacred records require re-auth.
4. Elder phrase appears in search post-approval.
5. `ProtocolGateway.allAssertionsPassed()` + full suite green.

**(Protocol 12 compliance verified)**