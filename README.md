# Kuttiomp

**v0.2 — A Culturally Sacred Narragansett Language Revitalization Platform**

> PhD-grade linguistic documentation · Twelve Cultural Governance Protocols · PostGIS land knowledge · Multi-orthography support

*Wunnegan — Greetings and respect to all who come to learn.*

---

## For Knowledge Keepers, Sharente, and Family

Kuttiomp (*family, home, gathering place*) is a language revitalization platform built by a Narragansett tribal member and his family, in partnership with Knowledge Keepers across generations. This platform exists to honor, preserve, and transmit the Narragansett language through the living voices of those who carry it — not as an archive of the past, but as a hearth for the future.

Every word entered into Kuttiomp carries cultural context. Every audio recording is permanently attributed to the speaker whose voice was captured. Every teaching flows through the clan structure that has always governed how knowledge moves: from Grandmother Comus and Grandfather, through Sharente (Two-Spirit keepers), to parents, siblings, and extended clan members.

**This technology serves the language. The language does not serve the technology.**

---

## Table of Contents

1. [Cultural Foundations](#cultural-foundations)
2. [The Speaker System](#the-speaker-system)
3. [Architecture Overview](#architecture-overview)
4. [Getting Started](#getting-started)
5. [Database Schema](#database-schema)
6. [API Reference](#api-reference)
7. [Admin Dashboard](#admin-dashboard)
8. [Cultural Protocols & Governance](#cultural-protocols--governance)
9. [Contributing with Respect](#contributing-with-respect)
10. [Acknowledgments](#acknowledgments)

---

## Cultural Foundations

### Why Kuttiomp Exists

Narragansett is a living Indigenous language of the Narragansett people, whose homelands encompass present-day Rhode Island and surrounding regions. Language revitalization is an act of **cultural sovereignty** — reclaiming what colonization attempted to sever.

Kuttiomp was designed with these principles:

| Principle | Implementation |
|-----------|----------------|
| **Speaker Attribution** | Every audio recording links to a named speaker |
| **Generational Structure** | Elder → Middle → Younger generation tiers |
| **Clan Organization** | Knowledge organized by clan affiliation |
| **Two-Spirit Honor** | Sharente role explicitly recognized and stewarded |
| **Sacred Content Protection** | Ceremonial knowledge requires elder approval |
| **Living Variation** | Pronunciation variants per speaker are preserved |

### The Name

**Kuttiomp** means family, home, and the gathering place where language is shared. The platform is named for what it aspires to be: not a database, but a home for the language to live among family.

---

## The Speaker System

Kuttiomp implements a multi-speaker, clan-based knowledge transmission model reflecting the project's founding family:

```
                    ┌─────────────────────┐
                    │  Grandmother Comus  │  Elder · Knowledge Keeper
                    │    (Mush8n8m8s)      │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
    ┌─────────▼────────┐  ┌───▼────┐  ┌───────▼───────┐
    │     Mother       │  │ Father │  │   Sharente    │  Two-Spirit Keeper
    └─────────┬────────┘  └────────┘  └───────────────┘
              │
    ┌─────────┴─────────┐
    │                   │
┌───▼──────┐    ┌───────▼──────┐
│  Older   │    │   Younger    │
│ Sibling  │    │   Sibling    │
└──────────┘    └──────────────┘

    Clan Members: Auntie · Uncle · Extended family
```

### Speaker Roles

| Role | Description |
|------|-------------|
| `grandmother` | Elder matriarchs (Grandmother Comus) |
| `grandfather` | Elder patriarchs |
| `sharente` | Two-Spirit knowledge keepers |
| `parent` | Parents, aunties, uncles in teaching roles |
| `sibling` | Siblings and cousins |
| `clan_member` | Extended clan members |
| `learner` | Language learners (separate attribution) |
| `guest_speaker` | Honored guests with limited attribution |

---

## Architecture Overview

Kuttiomp is a **Turborepo monorepo** with three primary components:

```
kuttiomp/
├── apps/
│   ├── admin/          # Next.js 15 Knowledge Keeper Portal
│   ├── api/            # FastAPI REST Backend
│   └── mobile/         # Flutter scaffold (future)
├── packages/
│   ├── types/          # Shared TypeScript domain types
│   ├── ui/             # Shared UI components
│   ├── database/       # Re-exports @kuttiomp/types
│   └── config/         # Shared TypeScript config
├── supabase/
│   └── migrations/     # PostgreSQL + PostGIS schema
└── docs/               # Knowledge Keeper documentation
```

See **SETUP.md** for local development instructions.

### Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | Next.js 15, TypeScript, Tailwind, shadcn/ui | Admin dashboard |
| Backend | FastAPI, Python 3.11+ | REST API, audio processing |
| Database | Supabase (PostgreSQL) | Linguistic + cultural data |
| Auth | Clerk | Identity for admin users |
| Storage | Supabase Storage | Audio recordings |
| AI | Grok (xAI) | Linguistic learning assistance |
| Monorepo | Turborepo | Workspace orchestration |

---

## Getting Started

### Prerequisites

- Node.js 20+
- Python 3.11+
- npm 10+
- Supabase project (configured)
- Clerk application (configured)

### Installation

```bash
# Clone the repository
git clone https://github.com/Nicequantum/Kuttiomp.git
cd Kuttiomp

# Install Node dependencies
npm install

# Set up Python backend
cd apps/api
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cd ../..

# Apply database migration
# Run supabase/migrations/001_initial_schema.sql in your Supabase SQL editor
# Create storage bucket: kuttiomp-audio
```

### Running Locally

```bash
# Terminal 1: Start API
cd apps/api
uvicorn app.main:app --reload --port 8000

# Terminal 2: Start Admin Dashboard
npm run dev --workspace=@kuttiomp/admin

# Or run both via Turborepo
npm run dev
```

- **Admin Dashboard:** http://localhost:3000
- **API Documentation:** http://localhost:8000/docs
- **API Health:** http://localhost:8000/health

### Environment Variables

Copy `.env.example` to `.env` and configure. See `.env.example` for all variables.

---

## Database Schema

The schema (`supabase/migrations/001_initial_schema.sql`) includes:

### Core Tables

| Table | Purpose |
|-------|---------|
| `clans` | Clan identity, totem, territory |
| `speakers` | Multi-generational knowledge keepers |
| `cultural_domains` | Knowledge areas (greetings, kinship, ceremony) |
| `lexical_entries` | Words/phrases with cultural context |
| `pronunciation_variants` | Speaker-specific pronunciation |
| `audio_recordings` | Speaker-attributed audio |
| `phrases` | Extended sentence-level content |
| `stories` | Oral tradition records |
| `ai_interactions` | AI assistance audit log |
| `audit_log` | Content governance trail |

### Visibility Levels

Content is governed by visibility:

- `public` — Open educational content
- `clan` — Clan members and enrolled family
- `family` — Immediate family only
- `elders_only` — Requires elder authority
- `sacred` — Restricted ceremonial knowledge

Row Level Security (RLS) enforces these boundaries at the database level.

---

## API Reference

Base URL: `http://localhost:8000/api/v1`

### Speakers

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/speakers` | List all speakers |
| GET | `/speakers/tree` | Hierarchical clan tree |
| GET | `/speakers/{id}` | Single speaker |
| POST | `/speakers` | Create speaker |
| GET | `/speakers/{id}/recordings` | Speaker's audio |

### Lexicon

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/lexicon` | Search/list entries |
| GET | `/lexicon/{id}` | Single entry |
| POST | `/lexicon` | Create entry |
| GET | `/lexicon/{id}/audio` | Entry audio recordings |

### Audio

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/audio/upload` | Upload with speaker attribution |
| GET | `/audio/pending` | Pending approvals |
| POST | `/audio/{id}/approve` | Elder approval |

### AI Assistance

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/ai/linguistic` | Grok linguistic help |

Full interactive documentation: http://localhost:8000/docs

---

## Admin Dashboard

The admin dashboard (`apps/admin`) provides:

- **Dashboard** — Overview and cultural protocols
- **Speakers** — Clan tree and speaker profiles
- **Clans** — Clan information and associations
- **Lexicon** — Word/phrase management with cultural context
- **Audio Studio** — Browser-based recording with speaker attribution
- **AI Assistant** — Learning support (not authoritative)
- **Approvals** — Elder review queue

Authentication is handled by Clerk. Only authorized family and clan members should receive accounts.

---

## Cultural Protocols & Governance

### Content Approval Workflow

1. **Create** — Family member adds lexical entry or records audio
2. **Attribute** — Speaker is identified on every recording
3. **Review** — Content enters `pending` or `requires_elder_review` status
4. **Approve** — Knowledge Keeper or Elder approves for publication
5. **Audit** — All changes logged in `audit_log`

### Sacred Content

Content marked `is_sacred: true` or visibility `sacred`:
- Automatically requires elder review
- Never exposed via public API endpoints
- Never used as AI training context
- Access restricted to authorized elders

### AI Usage Policy

The Grok AI integration is a **learning tool only**:
- Does not replace Knowledge Keeper authority
- Does not generate ceremonial content
- All interactions are logged
- Responses include cultural disclaimers

See `docs/CULTURAL_PROTOCOLS.md` for complete protocols.

---

## Contributing with Respect

### Who May Contribute

Contributions are welcomed from:
- Narragansett tribal members and enrolled family
- Authorized Knowledge Keepers
- Technical contributors working under family direction

### Before Contributing

1. Read `docs/KNOWLEDGE_KEEPERS_GUIDE.md`
2. Read `docs/CULTURAL_PROTOCOLS.md`
3. Understand that linguistic content requires speaker attribution
4. Never add ceremonial or sacred content without elder authorization

### Code Contributions

```bash
git checkout -b feature/your-feature
# Make changes
git commit -m "Description of changes"
git push origin feature/your-feature
```

Technical changes should not alter cultural content without family review.

---

## Acknowledgments

Kuttiomp is built with deep respect for:

- **Grandmother Comus** — Elder Knowledge Keeper
- **Grandfather** — Elder Knowledge Keeper
- **Sharente** — Two-Spirit Knowledge Keeper
- All parents, siblings, and clan members who share their voices
- The Narragansett people and their ancestors
- The land that has always held this language

*Language lives in relationship. Kuttiomp exists to honor those relationships.*

---

## License

This project is developed for the Narragansett language revitalization effort. Cultural content within this repository belongs to the Narragansett people and their Knowledge Keepers. Technical code is open for community contribution under family guidance.

---

## Contact & Support

- **Repository:** https://github.com/Nicequantum/Kuttiomp
- **Documentation:** See `docs/` directory
- **API Docs:** http://localhost:8000/docs (when running locally)