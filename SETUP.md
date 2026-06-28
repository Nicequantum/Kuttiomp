# Kuttiomp Local Development Setup

**Version 0.3** — Production-ready foundation

## Automated Setup

```bash
git clone https://github.com/Nicequantum/Kuttiomp.git
cd Kuttiomp
chmod +x setup.sh
./setup.sh
```

The script installs Node and Python dependencies and creates `.env` files from examples.

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 20+ | Admin dashboard, Turborepo |
| npm | 10+ | Workspace management |
| Python | 3.11+ | FastAPI backend |
| Supabase account | — | PostgreSQL + Storage + PostGIS |
| Clerk account | — | Admin authentication |

---

## Manual Setup

### 1. Environment Configuration

```bash
cp .env.example .env
cp apps/api/.env.example apps/api/.env
cp apps/admin/.env.example apps/admin/.env
```

| Variable | Where to get it |
|----------|----------------|
| `SUPABASE_*` | Supabase Dashboard → Settings → API |
| `CLERK_*` | Clerk Dashboard → API Keys |
| `GROK_API_KEY` | xAI Console → API Keys |

**Never commit filled `.env` files** — GitHub push protection blocks secrets.

### 2. Database Migrations

Apply **in order** via Supabase SQL Editor:

| # | File | Purpose |
|---|------|---------|
| 1 | `001_initial_schema.sql` | Core tables, speakers, lexicon, audio |
| 2 | `002_advanced_linguistic_schema.sql` | PostGIS, orthographies, cultural contexts |
| 3 | `003_performance_indexes.sql` | Performance indexes, integrity constraints |

Also:
- Enable **PostGIS** extension (Database → Extensions)
- Create storage bucket **`kuttiomp-audio`** (private, RLS enabled)

### 3. Start Development

```bash
# API (Terminal 1)
cd apps/api
source .venv/bin/activate   # Windows: .venv\Scripts\activate
uvicorn app.main:app --reload --port 8000

# Admin (Terminal 2)
npm run dev --workspace=@kuttiomp/admin

# Or both via Turborepo
npm run dev
```

| Service | URL |
|---------|-----|
| Admin Portal | http://localhost:3000 |
| API Docs | http://localhost:8000/docs |
| API Health | http://localhost:8000/health |

---

## Monorepo Structure

```
apps/
  admin/        → Next.js 15 Knowledge Keeper Portal
  api/          → FastAPI REST Backend
  mobile/       → Flutter scaffold (future)
packages/
  types/        → TypeScript domain types
  validation/   → Zod schemas
  ui/           → Shared UI components
  database/     → Re-exports types
  config/       → Shared TS config
```

---

## Troubleshooting

### API & Connectivity

| Symptom | Cause | Fix |
|---------|-------|-----|
| `API connection refused` | Backend not running | Start uvicorn on port 8000 |
| `CORS error` in browser | Origin mismatch | Set `API_CORS_ORIGINS=http://localhost:3000` in `apps/api/.env` |
| `422 VALIDATION_ERROR` | Schema mismatch | Ensure migration 002 applied; check request body against `/docs` |
| `500` on lexicon create | Missing columns | Apply migration 002 before 003 |

### Authentication

| Symptom | Fix |
|---------|-----|
| Clerk redirect loop | Verify `NEXT_PUBLIC_CLERK_*_URL` paths match admin routes |
| `Invalid publishable key` | Keys in `apps/admin/.env` must match Clerk dashboard |
| Middleware blocks all routes | Ensure `/sign-in` and `/sign-up` routes exist |

### Database

| Symptom | Fix |
|---------|-----|
| Empty speakers/lexicon | Run migrations 001 and 002 |
| `postgis` extension error | Enable PostGIS in Supabase Dashboard |
| `relation does not exist` | Migrations applied out of order — reset and re-apply |
| `spelling_variants` insert fails | Migration 002 not applied |
| RLS permission denied | Backend must use `SUPABASE_SERVICE_ROLE_KEY` |

### Audio

| Symptom | Fix |
|---------|-----|
| Upload fails | Create `kuttiomp-audio` bucket in Supabase Storage |
| Microphone denied | Browser permission; use HTTPS or localhost |
| Waveform empty | Record at least 1 second of audio before stopping |

### Frontend

| Symptom | Fix |
|---------|-----|
| `@kuttiomp/validation` not found | Run `npm install` from repo root |
| Type errors after pull | Run `npm run typecheck` |
| Lexicon save fails silently | Check browser console; verify API is running |

### Environment

| Symptom | Fix |
|---------|-----|
| `Settings` validation error on API start | All required vars in `apps/api/.env` must be set |
| Admin shows blank data | `NEXT_PUBLIC_API_URL=http://localhost:8000` |

---

## Verification Checklist

After setup, confirm:

- [ ] http://localhost:8000/health returns `version: 0.3.0`
- [ ] http://localhost:8000/docs shows all API tags
- [ ] Admin dashboard loads at http://localhost:3000
- [ ] Clan Tree shows seeded speakers (Grandmother Comus, Sharente, etc.)
- [ ] Lexicon Editor saves without validation errors
- [ ] Audio Studio records and shows waveform

---

## Production Deployment Notes

| Component | Suggested Platform |
|-----------|-------------------|
| Admin | Vercel |
| API | Railway, Fly.io, Render |
| Database | Supabase (managed) |
| Auth | Clerk |

Set environment variables in each platform's dashboard — never in committed files.