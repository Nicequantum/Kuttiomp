# Kuttiomp Mobile (Flutter)

**v0.4.0** — Foundation scaffold for field audio recording, offline lexicon access, and land-based knowledge navigation.

## Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Speaker, LexicalEntry
├── screens/               # Home, Speakers, Lexicon
├── services/              # ApiService, AudioService
└── utils/                 # AppConstants
```

## Dependencies

- `http` — API client
- `provider` — state management
- `record` / `audioplayers` — field audio capture and playback
- `geolocator` — land knowledge GPS tagging (future)
- `flutter_dotenv` — environment configuration

## Getting Started

```bash
cd apps/mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

Ensure the FastAPI backend is running (`uvicorn app.main:app --reload --port 8000`).

## API Integration

Mobile consumes the same REST API as the admin portal:

| Endpoint | Purpose |
|----------|---------|
| `GET /health` | API version and database status |
| `GET /api/v1/speakers` | Clan speakers |
| `GET /api/v1/lexicon` | Lexical entries |

Shared types are documented in `packages/types` and the OpenAPI spec at `/docs`.

## Cultural Protocol

All mobile recordings require speaker attribution and follow the 12 Cultural Governance Protocols in `docs/CULTURAL_PROTOCOLS.md`.