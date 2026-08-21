# FastAPI public deploy notes

The Knowledge Keeper admin on Vercel is the UI only. Learners call **this FastAPI service**. Vercel cannot host the Python API.

**Railway is the chosen production host.** This repo ships a Dockerfile and Railway config so the owner can attach `Nicequantum/Kuttiomp` and get a public HTTPS URL. **This change set does not deploy** — Railway credentials are not available here.

Local development is unchanged: `uvicorn` and PM2 (`apps/api/ecosystem.config.cjs`, `npm run pm2:*` in `apps/api`) still target port `8000` on your machine. See [Local check](#local-check) and [Local process manager (PM2)](#local-process-manager-pm2).

## CORS allowlist

Default `API_CORS_ORIGINS` (comma-separated):

| Origin | Surface |
|--------|---------|
| `http://localhost:3000` | Admin (Next.js) |
| `http://localhost:8080` | kuttiomp-learn (Vite) |
| `https://kuttiomp-learn.vercel.app` | Learn production |
| `https://kuttiomp-admin.vercel.app` | Admin production |

Production **must** include `https://kuttiomp-learn.vercel.app` and `https://kuttiomp-admin.vercel.app`. Override `API_CORS_ORIGINS` in the Railway service variables if you add preview domains.

## Public learner routes (unauthenticated, read-only)

- `GET /api/v1/public/health`
- `GET /api/v1/public/lexicon`
- `GET /api/v1/public/lexicon/{id}`

Do not point Learn at `/api/v1/lexicon` (keeper DTO, no publish gate).

Keeper/admin routes require `Authorization: Bearer <jwt>`. See `docs/API_AUTH.md`.

## Railway (chosen host)

Service root is **`apps/api`**. The image is `apps/api/Dockerfile` (Python 3.12 slim, non-root, API deps only — pytest and the rest of the monorepo stay out). Checked-in config:

| File | Role |
|------|------|
| `apps/api/Dockerfile` | Production image. Build context = `apps/api`. |
| `apps/api/.dockerignore` | Keeps `.venv`, tests, `.env`, PM2 files out of the image. |
| `railway.toml` (repo root) | Builder, watch path `apps/api/**`, start command, `/health`. |
| `apps/api/railway.toml` | Same deploy settings if you set Config File to `/apps/api/railway.toml`. |

Railway Config as Code may be ignored on brand-new services. **Set the same values in the dashboard** even if the files are present.

### Dashboard steps

1. In [Railway](https://railway.com), **New Project** → **Deploy from GitHub repo** → `Nicequantum/Kuttiomp` (grant GitHub access if prompted).
2. Create / select **one** service for the API (ignore any auto-detected Node workspaces for admin).
3. **Settings → Source**
   - Root Directory: `apps/api`
   - Watch Paths: `apps/api/**` (redeploy only when the API changes)
   - Config File (optional): `/railway.toml` or `/apps/api/railway.toml`
4. **Settings → Build**
   - Builder: **Dockerfile**
   - Leave Dockerfile path empty (Railway picks `apps/api/Dockerfile` because Root Directory is `apps/api`). Do not set Root Directory to `/` — that Dockerfile copies `requirements.txt` from the build context, which is only correct when the context is `apps/api`.
5. **Settings → Deploy**
   - Start command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
   - Healthcheck path: `/health` (alternate: `/api/v1/public/health`)
   - Railway injects `PORT`; do not hard-code `8000` in the start command.
6. **Settings → Networking**: generate a public domain. The public URL is `https://<service>.up.railway.app` (or your custom domain). **No trailing slash.**
7. **Variables**: add the names below. Copy values from your private `apps/api/.env` — **never commit secrets or paste real keys into git**.
8. Deploy, then open `https://<public-host>/health` and `https://<public-host>/api/v1/public/health`.

### Required environment variables (names only)

Values live in `apps/api/.env.example`. Set these on the Railway service:

| Name | Notes |
|------|--------|
| `SUPABASE_URL` | Required. Startup and `/health` use Supabase. |
| `SUPABASE_ANON_KEY` | Required. |
| `SUPABASE_SERVICE_ROLE_KEY` | Required. App refuses to start if missing. |
| `CLERK_SECRET_KEY` | Required. Keeper / admin JWT. |
| `GROK_API_KEY` | Required. App refuses to start if missing. |
| `API_CORS_ORIGINS` | Required in production. Must include `https://kuttiomp-learn.vercel.app` and `https://kuttiomp-admin.vercel.app`. Copy the comma-separated default from `.env.example` and add preview origins if needed. |
| `API_ENV` | Set `production` on Railway. |

Optional (same names as `.env.example`):

| Name | Notes |
|------|--------|
| `GROK_API_BASE_URL` | Defaults to `https://api.x.ai/v1`. |
| `CLERK_JWKS_URL` | Override only if you do not use the default Clerk JWKS. |
| `CLERK_ISSUER` | Optional issuer override. |
| `SUPABASE_JWT_SECRET` | Flutter FastAPI calls only. |
| `AUDIO_STORAGE_BUCKET` | Defaults to `kuttiomp-audio`. |
| `AUDIO_MAX_DURATION_SECONDS` | Defaults to `300`. |
| `SACRED_CONTENT_REQUIRES_ELDER_APPROVAL` | Defaults to `true`. |
| `DEFAULT_CONTENT_VISIBILITY` | Defaults to `clan`. |

Do **not** set on Railway:

| Name | Why |
|------|-----|
| `AUTH_DEV_SECRET` | Local/API tests only — never set in production. |
| `API_HOST` / `API_PORT` | Local `.env` helpers. The container binds `0.0.0.0:$PORT`. |

### After the API is public

Use the Railway HTTPS origin **with no trailing slash** (example shape only: `https://kuttiomp-api.up.railway.app`).

1. **kuttiomp-learn** (Vercel): set `VITE_API_BASE_URL` to that origin, then redeploy Learn.
2. **Admin** (Vercel, this repo): set `NEXT_PUBLIC_API_URL` to that same origin, then redeploy admin.
3. On **admin**, keep `NEXT_PUBLIC_LEARN_APP_URL` as the learner PWA (`http://localhost:8080` locally, `https://kuttiomp-learn.vercel.app` in production). The sidebar **Open learner demo** control uses it.

### Verify the image locally (no Railway credentials)

```bash
docker build -t kuttiomp-api ./apps/api
```

Do not `docker run` with real keys in the command line history if you can avoid it. Runtime still needs the variables above; `Settings()` and the FastAPI lifespan require `SUPABASE_*`, `CLERK_SECRET_KEY`, and `GROK_API_KEY`.

If Docker is not installed (this Cloud Agent workspace does not ship a daemon), the Dockerfile is still the deploy artifact — GitHub Actions job **API Docker build** compiles it on PRs.

## Local check

```bash
cd apps/api
uvicorn app.main:app --reload --port 8000
curl http://localhost:8000/api/v1/public/health
```

Or, without `--reload`, the same process manager used on a keeper workstation:

```bash
cd apps/api
npm run start
# Windows PM2 (see apps/api/scripts/pm2-setup.ps1):
# npm run pm2:setup && npm run pm2:start
```

See `docs/PUBLIC_LEXICON_CONTRACT.md` and `docs/BACKEND_IMPLEMENTATION_NOTES.md`.

## Local process manager (PM2)

`apps/api/ecosystem.config.cjs` starts `uvicorn app.main:app --host 0.0.0.0 --port 8000` from a local `.venv`. That path is for a Windows/desktop workstation, not Railway. Do not point PM2 at the Railway `$PORT` bind.
