# FastAPI public deploy notes

The Knowledge Keeper admin on Vercel is the UI only. Learners call **this FastAPI service**. Vercel cannot host the Python API.

This repo configures CORS and env examples. **Provisioning Railway / Fly / Render requires the project owner’s hosting credentials** and is not done from this change set.

## CORS allowlist

Default `API_CORS_ORIGINS` (comma-separated):

| Origin | Surface |
|--------|---------|
| `http://localhost:3000` | Admin (Next.js) |
| `http://localhost:8080` | kuttiomp-learn (Vite) |
| `https://kuttiomp-learn.vercel.app` | Learn production |
| `https://kuttiomp-admin.vercel.app` | Admin production |

Override in the API host’s env if you add preview domains.

## Public learner routes (unauthenticated, read-only)

- `GET /api/v1/public/health`
- `GET /api/v1/public/lexicon`
- `GET /api/v1/public/lexicon/{id}`

Do not point Learn at `/api/v1/lexicon` (keeper DTO, no publish gate).

## Host FastAPI (Railway, Fly, or Render)

1. Create a service from `Nicequantum/Kuttiomp` with root **`apps/api`** (or a start command from that directory).
2. Start command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
3. Copy secrets from `apps/api/.env.example` into the host dashboard (`SUPABASE_*`, `CLERK_SECRET_KEY`, `GROK_API_KEY`, `API_CORS_ORIGINS`).
4. Health check path: `/health` or `/api/v1/public/health`.
5. On the **admin** Vercel project, set `NEXT_PUBLIC_API_URL` to the public API origin (no trailing slash).
6. On **admin**, set `NEXT_PUBLIC_LEARN_APP_URL` to the learner PWA (`http://localhost:8080` locally, `https://kuttiomp-learn.vercel.app` in production). The sidebar **Open learner demo** control uses it.
7. Learn (`kuttiomp-learn`) later sets `VITE_API_BASE_URL` to that same FastAPI origin — not part of this Kuttiomp change.

## Local check

```bash
cd apps/api
uvicorn app.main:app --reload --port 8000
curl http://localhost:8000/api/v1/public/health
```

See `docs/PUBLIC_LEXICON_CONTRACT.md` and `docs/BACKEND_IMPLEMENTATION_NOTES.md`.
