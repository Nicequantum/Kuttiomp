# Kuttiomp Database Migrations

Apply these SQL files **in exact order** via the Supabase SQL Editor.

## Migration Order

| Order | File | Version | Description |
|-------|------|---------|-------------|
| 1 | `001_initial_schema.sql` | 001 | Core schema, speakers, lexicon, audio, seed data |
| 2 | `002_advanced_linguistic_schema.sql` | 002 | PostGIS, orthographies, cultural contexts, contributions |
| 3 | `003_performance_indexes.sql` | 003 | Performance indexes, integrity constraints |
| 4 | `004_final_hardening.sql` | 004 | Migration tracking, final constraints, foundation complete |

## Prerequisites

Before running migrations:

1. Create a Supabase project
2. Note your project URL and API keys

After migration 002:

- Enable **PostGIS** extension (Database → Extensions) if not auto-enabled
- Create storage bucket **`kuttiomp-audio`** (private, RLS enabled)

## How to Apply

1. Open Supabase Dashboard → SQL Editor
2. Paste contents of `001_initial_schema.sql` → Run
3. Repeat for `002`, `003`, `004` in order
4. Verify: `SELECT * FROM foundation_status;` should show `foundation_ready = true`

## Verify Foundation

```sql
SELECT * FROM schema_migrations ORDER BY version;
SELECT * FROM foundation_status;
```

Expected: `latest_migration = 004`, `foundation_ready = true`, `active_speakers >= 9`

## API Health Check

After migrations and API start:

```
GET http://localhost:8000/health
```

Should return `version: 0.4.0` and `database.migrations_current: true`