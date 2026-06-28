# Kuttiomp

**v0.3 — Narragansett Language Revitalization Platform**

> A sacred, living language deserves sacred tooling. Kuttiomp is the gathering place where Narragansett knowledge flows through generations — from Grandmother Comus and Grandfather, through Sharente, to parents, siblings, and clan members.

[![Repository](https://img.shields.io/badge/GitHub-Nicequantum%2FKuttiomp-2D5A3D)](https://github.com/Nicequantum/Kuttiomp)

---

## What Is Kuttiomp?

Kuttiomp (*family, home, gathering place*) is a PhD-grade language revitalization platform built by a Narragansett tribal member and family. It is not a dictionary app — it is infrastructure for **cultural sovereignty through language**.

| Capability | Description |
|------------|-------------|
| **Multi-speaker clan system** | Grandmother Comus, Grandfather, Sharente, parents, siblings, clan members |
| **PhD-grade lexicon** | Phonemic/IPA, morphology, TEK, seasonal usage, orthographic variants |
| **Speaker-attributed audio** | Waveform studio with elder approval workflow |
| **Land knowledge (PostGIS)** | Words anchored to place |
| **12 Cultural Protocols** | Governance encoded in schema, API, and UI |
| **Knowledge Keeper portal** | Academic admin dashboard for systematic input |

---

## Quick Start

```bash
git clone https://github.com/Nicequantum/Kuttiomp.git
cd Kuttiomp
chmod +x setup.sh && ./setup.sh
```

Edit `.env`, `apps/api/.env`, and `apps/admin/.env` with your credentials, then apply SQL migrations in Supabase (see [SETUP.md](SETUP.md)).

```bash
npm run dev
```

- **Admin Portal:** http://localhost:3000
- **API Docs:** http://localhost:8000/docs

---

## Monorepo Structure

```
kuttiomp/
├── apps/
│   ├── admin/          # Next.js 15 Knowledge Keeper Portal
│   ├── api/            # FastAPI REST Backend (v0.3)
│   └── mobile/         # Flutter scaffold (future)
├── packages/
│   ├── types/          # TypeScript domain types
│   ├── validation/     # Zod schemas (shared validation rules)
│   ├── ui/             # Shared UI components
│   ├── database/       # Re-exports @kuttiomp/types
│   └── config/         # Shared TS config
├── supabase/migrations/  # 001 → 002 → 003 (apply in order)
└── docs/               # Knowledge Keeper & cultural documentation
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Monorepo | Turborepo + npm workspaces |
| Frontend | Next.js 15, TypeScript, Tailwind, shadcn/ui, Zod |
| Backend | FastAPI, Pydantic v2, structured error responses |
| Database | Supabase PostgreSQL + PostGIS |
| Auth | Clerk |
| Storage | Supabase Storage (`kuttiomp-audio`) |
| AI | Grok/xAI (learning assistance only) |

---

## Documentation

| Document | Audience |
|----------|----------|
| [SETUP.md](SETUP.md) | Developers — installation & troubleshooting |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contributors — cultural protocols for code |
| [docs/KNOWLEDGE_KEEPERS_GUIDE.md](docs/KNOWLEDGE_KEEPERS_GUIDE.md) | Sharente & family — systematic knowledge input |
| [docs/CULTURAL_PROTOCOLS.md](docs/CULTURAL_PROTOCOLS.md) | All — Twelve Governance Protocols |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Developers — system design |

---

## API Overview

Base URL: `http://localhost:8000/api/v1`

| Resource | Endpoints |
|----------|-----------|
| Speakers | `GET /speakers`, `GET /speakers/tree` |
| Lexicon | `GET/POST/PATCH /lexicon`, sub-resources for spellings, examples, contexts |
| Audio | `POST /audio/upload`, `GET /audio/pending` |
| Cultural | `GET/POST /cultural/contexts` |
| Land | `GET/POST /land/sites` |
| Contributions | `GET/POST /contributions`, review workflow |

Full interactive documentation: http://localhost:8000/docs

---

## Cultural Governance

All platform activity is governed by **Twelve Cultural Governance Protocols**, including:

1. Speaker Sovereignty
2. Generational Respect
3. Two-Spirit Honor
4. Sacred Content Protection
5. Clan Boundaries
6. AI Boundaries
7. Audit & Accountability
8. Pronunciation Variation
9. External Sharing
10. Platform Modifications
11. Land Relationship
12. Orthographic Integrity

See [docs/CULTURAL_PROTOCOLS.md](docs/CULTURAL_PROTOCOLS.md).

---

## License & Cultural Ownership

Technical code is open for contribution under family guidance. **Cultural content belongs to the Narragansett people and their Knowledge Keepers.** Platform existence does not authorize external use of linguistic or cultural data.

---

## Acknowledgments

Built with deep respect for Grandmother Comus, Grandfather, Sharente, and all Knowledge Keepers who carry the language forward.

*Wunnegan.*