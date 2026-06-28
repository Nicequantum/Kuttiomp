# Architecture

*Technical architecture for the Kuttiomp platform*

---

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Knowledge Keepers                        │
│         (Grandmother Comus, Grandfather, Sharente)         │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│              Next.js 15 Admin Dashboard                      │
│         (Clerk Auth · shadcn/ui · Tailwind)                │
│  ┌─────────┬──────────┬─────────┬──────────┬────────────┐  │
│  │Dashboard│ Speakers │ Lexicon │  Audio   │ Approvals  │  │
│  └─────────┴──────────┴─────────┴──────────┴────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          │ REST API
┌─────────────────────────▼───────────────────────────────────┐
│                   FastAPI Backend                            │
│  ┌──────────┬──────────┬─────────┬──────────┬───────────┐  │
│  │ Speakers │  Lexicon │  Audio  │   Clans  │ Grok AI   │  │
│  └──────────┴──────────┴─────────┴──────────┴───────────┘  │
└──────────┬──────────────────────────────┬───────────────────┘
           │                              │
┌──────────▼──────────┐        ┌──────────▼──────────┐
│  Supabase PostgreSQL │        │  Supabase Storage   │
│  (RLS · Migrations)  │        │  (kuttiomp-audio)   │
└─────────────────────┘        └─────────────────────┘
```

---

## Monorepo Structure

```
kuttiomp/
├── apps/
│   ├── admin/                    # Next.js 15 frontend
│   │   ├── src/
│   │   │   ├── app/              # App Router pages
│   │   │   ├── components/       # UI + feature components
│   │   │   └── lib/              # API client, Supabase, utils
│   │   └── package.json
│   └── api/                      # FastAPI backend
│       ├── app/
│       │   ├── routers/          # Route handlers
│       │   ├── services/         # Business logic
│       │   ├── models/           # Pydantic schemas
│       │   ├── config.py         # Settings
│       │   ├── database.py       # Supabase client
│       │   └── main.py           # App entry
│       └── requirements.txt
├── packages/
│   └── database/                 # Shared TypeScript types
│       └── src/types.ts
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql
├── docs/
├── turbo.json
└── package.json
```

---

## Data Flow: Audio Recording

```
1. Knowledge Keeper opens Audio Studio
2. Selects speaker (required)
3. Browser MediaRecorder captures audio (WebM)
4. POST /api/v1/audio/upload (multipart form)
5. FastAPI uploads to Supabase Storage
6. Recording record created with speaker_id, status: pending
7. Elder reviews in Approvals page
8. POST /api/v1/audio/{id}/approve
9. Recording available at designated visibility level
```

---

## Authentication

- **Admin Dashboard:** Clerk (JWT-based session)
- **API:** Service role key for backend operations (server-to-server)
- **Database:** Supabase RLS policies enforce visibility at row level
- **Future:** Clerk JWT verification middleware on API routes

---

## Database Design Principles

1. **Speaker-centric** — `speaker_id` on all voice-related content
2. **Approval workflow** — `approval_status` enum on publishable content
3. **Visibility layers** — `content_visibility` enum with RLS enforcement
4. **Audit trail** — `audit_log` for governance
5. **Normalized search** — `word_normalized` with trigram index
6. **Hierarchical speakers** — `parent_speaker_id` self-reference

---

## API Design

- RESTful endpoints under `/api/v1/`
- Pydantic models for request/response validation
- OpenAPI documentation at `/docs`
- CORS configured for admin dashboard origin
- File uploads via `multipart/form-data`

---

## Deployment Considerations

| Component | Recommended Platform |
|-----------|---------------------|
| Admin Dashboard | Vercel |
| FastAPI Backend | Railway, Fly.io, or Render |
| Database | Supabase (managed) |
| Storage | Supabase Storage |
| Auth | Clerk |

### Environment Separation

- Production credentials in `.env` (not committed in production setups)
- `.env.example` documents all required variables
- Supabase migrations applied via SQL editor or CLI

---

## Shared Types

`@kuttiomp/database` package provides TypeScript types shared between:
- Admin dashboard components
- Future learner-facing applications
- API response typing (manual sync with Pydantic models)

---

## Future Architecture

Planned extensions (not yet implemented):
- Learner-facing application (separate from admin)
- Real-time collaborative editing for family sessions
- Mobile audio recording app
- Offline-first sync for field recordings
- Clerk JWT middleware on all API routes
- Webhook integration for approval notifications