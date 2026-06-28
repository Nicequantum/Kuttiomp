# Kuttiomp Local Development Setup

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 20+ | Admin dashboard, Turborepo |
| npm | 10+ | Workspace management |
| Python | 3.11+ | FastAPI backend |
| Supabase account | — | PostgreSQL + Storage + PostGIS |
| Clerk account | — | Admin authentication |

## Step 1: Clone & Install

```bash
git clone https://github.com/Nicequantum/Kuttiomp.git
cd Kuttiomp
npm install
```

## Step 2: Environment Configuration

```bash
# Root
cp .env.example .env

# Backend
cp apps/api/.env.example apps/api/.env

# Admin dashboard
cp apps/admin/.env.example apps/admin/.env
```

Fill in credentials from Supabase, Clerk, and xAI dashboards.

## Step 3: Database Migrations

Apply in order via Supabase SQL Editor:

1. `supabase/migrations/001_initial_schema.sql`
2. `supabase/migrations/002_advanced_linguistic_schema.sql`

Enable PostGIS extension in Supabase Dashboard → Database → Extensions if not auto-enabled.

Create storage bucket:
- Name: `kuttiomp-audio`
- Private bucket with RLS

## Step 4: Python Backend

```bash
cd apps/api
python -m venv .venv

# Windows
.venv\Scripts\activate

# macOS/Linux
source .venv/bin/activate

pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Verify: http://localhost:8000/docs

## Step 5: Admin Dashboard

```bash
# From repo root
npm run dev --workspace=@kuttiomp/admin
```

Verify: http://localhost:3000

## Step 6: Run Everything (Turborepo)

```bash
npm run dev
```

## Monorepo Structure

```
apps/
  admin/     → Next.js 15 Knowledge Keeper portal
  api/       → FastAPI REST backend
  mobile/    → Flutter scaffold (future)
packages/
  types/     → Shared TypeScript types
  ui/        → Shared UI components
  database/  → Re-exports @kuttiomp/types
  config/    → Shared TS config
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| API connection refused | Ensure uvicorn is running on port 8000 |
| Clerk auth errors | Verify publishable + secret keys match |
| Supabase RLS errors | Backend uses service role key in apps/api/.env |
| PostGIS errors | Enable postgis extension in Supabase |
| Empty speaker data | Run both SQL migrations |