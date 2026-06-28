#!/usr/bin/env bash
# Kuttiomp Local Environment Setup
# Narragansett Language Revitalization Platform v0.4

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "═══════════════════════════════════════════════════════════"
echo "  Kuttiomp — Local Environment Setup"
echo "  Narragansett Language Revitalization Platform v0.4.0"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ── Prerequisites ─────────────────────────────────────────────
check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "✗ Missing required command: $1"
    exit 1
  fi
  echo "✓ $1 found"
}

echo "Checking prerequisites..."
check_cmd node
check_cmd npm
check_cmd python3 || check_cmd python
PYTHON=$(command -v python3 || command -v python)
echo ""

# ── Environment files ───────────────────────────────────────
copy_env() {
  local src="$1" dest="$2"
  if [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    echo "✓ Created $dest from example"
  else
    echo "→ $dest already exists (skipped)"
  fi
}

echo "Setting up environment files..."
copy_env ".env.example" ".env"
copy_env "apps/api/.env.example" "apps/api/.env"
copy_env "apps/admin/.env.example" "apps/admin/.env"
echo ""
echo "⚠  Edit .env files with your Supabase, Clerk, and xAI (Grok) credentials."
echo ""

# ── Node dependencies ───────────────────────────────────────
echo "Installing Node dependencies (Turborepo workspaces)..."
npm install
echo "✓ Node dependencies installed"
echo ""

# ── Python virtual environment ──────────────────────────────
echo "Setting up Python backend..."
cd apps/api
if [ ! -d ".venv" ]; then
  $PYTHON -m venv .venv
  echo "✓ Created Python virtual environment"
fi

if [ -f ".venv/Scripts/activate" ]; then
  # Windows Git Bash
  source .venv/Scripts/activate
elif [ -f ".venv/bin/activate" ]; then
  source .venv/bin/activate
fi

pip install -q -r requirements.txt
echo "✓ Python dependencies installed"
cd "$ROOT"
echo ""

# ── Database reminder ───────────────────────────────────────
echo "═══════════════════════════════════════════════════════════"
echo "  Database Setup (manual — Supabase SQL Editor)"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  Apply migrations IN ORDER (see supabase/migrations/README.md):"
echo "    1. supabase/migrations/001_initial_schema.sql"
echo "    2. supabase/migrations/002_advanced_linguistic_schema.sql"
echo "    3. supabase/migrations/003_performance_indexes.sql"
echo "    4. supabase/migrations/004_final_hardening.sql"
echo ""
echo "  Also:"
echo "    • Enable PostGIS extension in Supabase Dashboard"
echo "    • Create storage bucket: kuttiomp-audio (private)"
echo ""
echo "  Verify: SELECT * FROM foundation_status;"
echo ""

# ── Done ────────────────────────────────────────────────────
echo "═══════════════════════════════════════════════════════════"
echo "  Setup complete. Start development:"
echo ""
echo "  Terminal 1 (API):"
echo "    cd apps/api && source .venv/bin/activate"
echo "    uvicorn app.main:app --reload --port 8000"
echo ""
echo "  Terminal 2 (Admin):"
echo "    npm run dev --workspace=@kuttiomp/admin"
echo ""
echo "  Or both: npm run dev"
echo ""
echo "  Admin:       http://localhost:3000"
echo "  API Docs:    http://localhost:8000/docs"
echo "  Health:      http://localhost:8000/health"
echo "  Grok Test:   http://localhost:8000/api/grok/test"
echo "═══════════════════════════════════════════════════════════"