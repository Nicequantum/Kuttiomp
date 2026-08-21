# FastAPI authentication

Keeper and admin routes require a verified identity. Learners and uptime checks do not.

## Header

```
Authorization: Bearer <jwt>
```

| Client | Token | How to get it |
|--------|--------|----------------|
| Knowledge Keeper admin | Clerk session JWT | `window.Clerk.session.getToken()` (browser) or `auth().getToken()` (Next.js server). `apiFetch` / `apiUpload` / `serverApiFetch` attach this automatically. |
| Flutter (if it later calls FastAPI) | Supabase access token | `Supabase.instance.client.auth.currentSession?.accessToken`. Set `SUPABASE_JWT_SECRET` on the API so the token can be verified. |
| Local/API tests | Dev HS256 JWT | `iss` must be `kuttiomp-dev`. Sign with `AUTH_DEV_SECRET`. Never set this in production (`API_ENV=production` disables it). |

## Unauthenticated (public)

- `GET /`
- `GET /health`
- `GET /api/v1/public/health`
- `GET /api/v1/public/lexicon`
- `GET /api/v1/public/lexicon/{id}`
- OpenAPI docs (`/docs`, `/redoc`, `/openapi.json`)

`GET /api/v1/public/*` applies the publish gate: `approval_status=approved`, `visibility=public`, `is_sacred=false`, conservative `spiritual_significance`, non-empty gloss. Sacred, elders-only, clan-only, and family rows are never returned.

## Authenticated (everything else)

All other `/api` and `/api/v1` routes return `401 UNAUTHORIZED` without a valid Bearer token.

Writes, bulk import, approvals, AI, Grok test, and sacred mutations additionally require a **keeper** actor (`403` for learners and unlinked Clerk sessions).

Keeper/elder is **not** “has a Clerk cookie.” It comes from a `speakers` row (`clerk_user_id` + `role` / `is_elder`):

- `is_keeper` — speaker role in grandmother / grandfather / sharente / parent / sibling / clan_member (or `is_elder`)
- `is_elder` — `speakers.is_elder`, elder generation, or grandmother / grandfather / sharente
- `include_sacred` and sacred-by-id reads are **elder-only**. A keeper or random Clerk account gets `403` and never the row.

Approvals take the actor from the token. A client-supplied `approved_by` / `reviewed_by` UUID is ignored. The Clerk user must be linked on `speakers.clerk_user_id`.

## Environment

See `.env.example` and `apps/api/.env.example`.

| Variable | Purpose |
|----------|---------|
| `CLERK_SECRET_KEY` | Existing Clerk secret; used to fetch JWKS from `https://api.clerk.com/v1/jwks` |
| `CLERK_JWKS_URL` | Optional override (e.g. `{issuer}/.well-known/jwks.json`) |
| `CLERK_ISSUER` | Optional issuer check for Clerk tokens |
| `SUPABASE_JWT_SECRET` | Optional. JWT secret from Supabase Settings → API. Needed to accept Flutter tokens. |
| `AUTH_DEV_SECRET` | Test-only HS256 secret. Leave unset in production. |
| `API_ENV` | Set `production` to disable `AUTH_DEV_SECRET` even if present. |
| `API_CORS_ORIGINS` | Comma-separated browser origins (admin + Learn local/prod). |

## Database roles

- Public lexicon reads use the **anon** key so RLS can constrain rows.
- Writes and approvals after a verified identity use the **service role** (privileged server job).
- User-scoped reads with a Supabase JWT use the anon client plus that JWT.
- Clerk-authenticated keeper reads still use the service role: Supabase RLS cannot see Clerk users yet.

## Learn frontend

CORS includes `https://kuttiomp-learn.vercel.app` and `http://localhost:8080`. Pointing Learn at this API (`VITE_API_BASE_URL`) is a separate cutover and is not done in this repo.
