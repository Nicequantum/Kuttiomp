# Kuttiomp Mobile (Flutter)

Future mobile application for field audio recording, offline lexicon access, and land-based knowledge navigation.

## Planned Capabilities

- Offline-first audio recording with speaker attribution
- GPS-tagged land knowledge points (synced with PostGIS schema)
- Clan-scoped content access
- Elder approval queue (read-only for authorized keepers)

## Scaffold Status

This directory is reserved for the Flutter application. Initialize when ready:

```bash
cd apps/mobile
flutter create . --org com.kuttiomp --project-name kuttiomp_mobile
```

## Shared Types

Mobile will consume API contracts documented in `packages/types` and OpenAPI spec at `/docs` on the FastAPI backend.

## Cultural Protocol

All mobile recordings require speaker attribution and follow the 12 Cultural Governance Protocols in `docs/CULTURAL_PROTOCOLS.md`.