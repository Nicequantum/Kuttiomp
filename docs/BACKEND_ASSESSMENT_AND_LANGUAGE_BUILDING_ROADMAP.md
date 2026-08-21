# Kuttiomp Assessment: Backend Readiness for Sharente Knowledge Ingest and Multi-Generational Teaching

**Repository:** [Nicequantum/Kuttiomp](https://github.com/Nicequantum/Kuttiomp)  
**Assessed revision:** `c2145f8` on `main` (v0.4.0 foundation + subsequent mobile/admin work)  
**Audience:** Knowledge Keepers, Sharente, family stewards, and technical maintainers  
**Purpose:** An honest map of what the platform can do today, what is missing, what is broken, and what to build so Sharente can place Ph.D.-grade revitalization knowledge into an elegant backend that can teach children, young adults, adults, and elders.

---

## 1. Where this application is

Kuttiomp is a **culturally serious foundation**, not yet a production teaching platform.

It already has something most language apps never attempt: a constitution. The Twelve Cultural Governance Protocols, speaker-attributed audio, clan and Sharente roles, sacred-content flags, multi-orthography support, land knowledge via PostGIS, and a Knowledge Keeper portal are real design choices — not marketing copy. The intent is right. The depth of the *idea* is ahead of the depth of the *implementation*.

What exists today is three layers that do not yet form one system:

| Layer | What it actually is | Maturity |
|-------|---------------------|----------|
| **Knowledge Keeper portal** (`apps/admin`) | Next.js 15 dashboard for entering lexicon, recording audio, viewing clan tree, asking Grok for non-authoritative help | Strongest path for Sharente ingest. Several screens are complete; several are decorative. |
| **REST backend** (`apps/api`) | FastAPI v0.4 with lexicon CRUD, bulk import, speakers, audio upload, cultural contexts, land sites, contributions | Usable locally. **No API authentication.** Service-role key bypasses database RLS. Zero Python tests. |
| **Learner app** (`apps/mobile`) | Flutter shell with four age modes, protocol gates, oral-first UI, offline *design* | Architecturally ambitious. Runtime content is a handful of hardcoded samples. Recording, approval, encryption, and lesson RPCs are stubs. **Does not call the FastAPI backend.** |

The root README and `FOUNDATION_COMPLETE.md` call v0.4.0 “production-ready” and “foundation complete.” The Flutter app and Master Architecture Document speak of v2.x “sovereign production.” Those labels describe **aspiration and cultural law**, not operational readiness.

**Plain-language verdict**

- Sharente can begin systematic word-and-metadata entry *today* if the API, Supabase, and Clerk are running.
- Sharente cannot yet deposit a Ph.D. corpus (paradigms, reconstruction notes, source apparatus, verb classes, attested vs. restored forms) as structured knowledge. Those ideas collapse into free-text fields.
- Families cannot yet be given a teaching app that plays living voices, follows a curriculum, or grows as Keepers approve new words. The learner app falls back to four sample lexemes, four phrases, and three lessons.
- The platform is not safe to expose on the public internet. Anyone who can reach the API can create speakers, bulk-import lexicon, include sacred entries, and approve recordings with an arbitrary UUID.

That is a strong *gathering-place foundation*. It is not yet the house.

---

## 2. What is already excellent — keep this

Do not throw away the cultural architecture. It is the most valuable part of the repository.

### 2.1 A real constitution

The Twelve Protocols (`docs/CULTURAL_PROTOCOLS.md`) are the correct north star for a revitalization platform:

1. Speaker sovereignty  
2. Generational respect  
3. Two-Spirit / Sharente honor  
4. Sacred content protection  
5. Clan boundaries  
6. AI as assistant, never authority  
7. Audit and accountability  
8. Pronunciation variation as living, not “incorrect”  
9. External sharing is not implied by platform existence  
10. Dignity — no streaks, ranks, or gamification  
11. Language inseparable from land  
12. Multiple orthographies serve speakers, not the reverse  

Protocol 10 (dignity) and Protocol 6 (AI boundaries) are especially important. Many “futuristic” language apps would violate both. Kuttiomp should stay itself.

### 2.2 Speaker-centric data model

The `speakers` table is not a user table with a name field. It models grandmother, grandfather, Sharente, parent, sibling, clan member, learner, and guest speaker; generation tiers; clan membership; kinship via `parent_speaker_id`; Two-Spirit honor; and cultural authority levels. Seed data includes Grandmother Comus, Grandfather, and Sharente. Audio **requires** `speaker_id`. That is the right ontology for this language.

### 2.3 Lexicon editor that Knowledge Keepers can actually use

The admin Lexicon Editor (four tabs: Core, Linguistic, Cultural, Governance) plus `POST /api/v1/lexicon/bulk` (JSON or CSV) is the current ingest path. It already captures:

- Narragansett form, English gloss, extended gloss  
- Phonemic and IPA transcription  
- Morphological breakdown and morpheme gloss (as text)  
- Etymology notes and source  
- Semantic domain, register, archaic / neologism flags  
- Seasonal usage, ecological connection, spiritual significance  
- Cultural contexts including TEK and Mother Earth fields  
- Orthography-tagged spelling variants (Costa, Jopson, IPA, community preferred, learner phonetic)  
- Example sentences  
- Sacred ≠ public validation (Protocol 4)

For a v0.4 foundation, this is genuinely above typical dictionary-app quality.

### 2.4 Land as a first-class linguistic object

PostGIS `land_knowledge_sites` with `GEOGRAPHY(POINT, 4326)`, `lexical_land_links`, TEK narrative fields, and seasonal usage on entries is the correct Algonquian-and-Narragansett instinct: words live on the land.

### 2.5 Learner modes that respect age without turning language into a game

Little Ones, Young Learner, Core Adult, and Elder modes — larger type for elders, oral-first presentation, no leaderboards — are the right product direction for teaching every generation in one family app.

### 2.6 Documentation culture

The Knowledge Keepers Guide, protocol constitution, tribal maintainer guides, and rollout packets show this is meant to be stewarded by a small tribal team, not a rotating contractor crew. That matches the 2050 maintainability goal in the Master Architecture Document.

---

## 3. Architecture as it exists (not as diagrams claim)

```
Knowledge Keepers (Sharente, Elders, family)
        │
        ▼
┌───────────────────────┐     REST (no JWT)      ┌─────────────────────────┐
│  apps/admin           │ ─────────────────────► │  apps/api (FastAPI)     │
│  Next.js 15 + Clerk   │                        │  Service-role Supabase  │
│  Lexicon, Audio,      │                        │  Grok / xAI             │
│  Clan tree, Import    │                        └────────────┬────────────┘
└───────────────────────┘                                     │
                                                              ▼
                                                 ┌─────────────────────────┐
                                                 │  Supabase PostgreSQL    │
                                                 │  + PostGIS + Storage    │
                                                 │  RLS present, bypassed  │
                                                 │  by service role        │
                                                 └────────────┬────────────┘
                                                              │
┌───────────────────────┐     RPCs that are NOT               │
│  apps/mobile          │     in migrations  ◄────────────────┘
│  Flutter + Riverpod   │
│  Supabase Auth        │  Does not call FastAPI
│  Hardcoded corpora    │  Guest/anonymous fallback
│  Stub mic + playback  │
└───────────────────────┘
```

Three identity systems are already in play:

| Client | Identity |
|--------|----------|
| Admin portal | Clerk |
| API | None (service role for all operations) |
| Mobile | Supabase Auth, with guest fallback |

`speakers.clerk_user_id` exists, but there is no Clerk → speaker mapping in the API, and mobile never sees Clerk at all. A learner in the Flutter app and a Keeper in the portal are not the same person in the data model.

The Master Architecture Document requires a **unified backend**: Flutter as a thin client over secure Supabase RPCs only. The FastAPI app is a second backend for the admin portal. Those two backends do not share lesson, progress, or approval workflows. That split is the central architectural hole.

---

## 4. Can Sharente ingest Ph.D. knowledge today?

**Partially — as richly annotated dictionary cards, not as a linguistic knowledge graph.**

### 4.1 What Sharente can enter now

| Knowledge type | How it is stored | Fit for Ph.D. work |
|----------------|------------------|--------------------|
| Headword + gloss | Structured columns | Good |
| IPA / phonemic string | Free text | Adequate for notes; no phoneme inventory |
| Morpheme breakdown | One text field | Notes, not a morpheme database |
| Etymology | Notes + source string | No source apparatus, page citations, or confidence |
| Semantic domain | Closed enum | Too coarse for TEK or kinship systems |
| Seasonal / ecological | Enum array + text | Good start |
| Orthographic variants | Structured, multi-system | Strong |
| Speaker-attributed pronunciation | Table exists; **no admin UI** | Schema yes, ingest path weak |
| Example sentences | Nested on create | No syntax, no interlinear alignment beyond one gloss field |
| TEK / ceremonial narrative | `cultural_contexts` blobs | Good for prose; not queryable knowledge |
| Land link | Bulk import only; admin land page is read-only | Incomplete |
| Attestation vs. restoration vs. neologism | `is_archaic` / `is_neologism` booleans | Far too binary for reconstruction work |
| Historical sources (Williams 1643, Costa, manuscripts) | `etymology_source` text | Cannot cite, compare, or disagree with sources |
| Audio of living speakers | Admin Audio Studio | Strong capture path; approval UI is dead |

Bulk CSV/JSON import is the right tool for an initial dump of a dissertation lexicon **if** rows map onto current columns. Anything that is a *system* (verb paradigms, animate/inanimate, reconstruction arguments) will be flattened into comments.

### 4.2 What a Narragansett / Eastern Algonquian Ph.D. corpus actually needs

Narragansett is Eastern Algonquian: polysynthetic, animate/inanimate, obviative, with verb classes that are the grammar, not decoration. A backend worthy of Sharente’s knowledge should eventually hold:

**Phonology**

- Phoneme inventory with allophones and environments  
- Historical sound correspondences (Proto-Algonquian → Eastern Algonquian → Narragansett)  
- Stress / pitch notes tied to speakers, not a single “correct” IPA  
- Costa vs. Jopson vs. learner-phonetic as first-class writing systems (this part already exists)

**Morphology (the largest gap)**

- Morpheme table: initials, medials, finals — not a slash-delimited string  
- Verb classes: AI, II, TA, TI (and further Algonquian subdivisions)  
- Orders: independent, conjunct, imperative  
- Person/number including inclusive/exclusive and obviative (3')  
- Noun gender: animate / inanimate  
- Dependent nouns (inalienable kinship, body parts)  
- Locative, diminutive, pejorative, absentative  
- Paradigm cells generated or attested, each with speaker + source + confidence

**Lexicography**

- Sense-level entries (one headword, many senses) — currently one gloss blob  
- Lexical relations: synonym, antonym, meronym, taxonomic, ceremonial counterpart  
- Comparative links to Massachusett, Wôpanâak, Mohegan-Pequot, and PA reconstructions, with explicit “this is comparative, not Narragansett usage”
- Attestation grade: `attested_historical` | `attested_living` | `restored_with_argument` | `community_neologism` | `uncertain`  
- Full citation objects: author, year, page, manuscript shelfmark, URL, Keeper commentary

**Discourse and pedagogy**

- Phrase and dialogue as structured objects (table exists; **no API router**)  
- Lesson sequences authored by Keepers, not hardcoded in Flutter  
- Age-appropriateness separate from sacredness (a children’s greeting is not “sacred,” a ceremonial prayer is not a lesson)

Until those objects exist, Sharente will keep writing a dissertation *into text fields* that search cannot use and lessons cannot teach from.

---

## 5. Can we deploy a teaching app for every generation?

**Not yet.** The Flutter app is a protocol-governed shell around sample content.

### 5.1 What learners would experience today

- Four modes with thoughtful typography and dignity rules  
- Dashboard petals for lexemes, phrases, lessons  
- A few hardcoded items (`Wunnegan`, and similar samples)  
- “Record Audio (Stub)” — no microphone pipeline, no `just_audio` / `record` packages  
- Elder approval as an in-memory simulation  
- Offline “Isar” content that is largely in-process memory, not a durable encrypted lexicon  
- Sync that calls RPCs (`get_lexemes_for_stage`, `get_lessons_for_stage`, `complete_lesson_secure`, `sync_offline_batch_secure`, `submit_elder_recording_secure`, …) **which are not in any SQL migration**

When those RPCs fail, repositories silently serve `_offlineCorpus`. That is acceptable for a household pilot demo. It is not a language school.

### 5.2 What a deployable teaching backend must provide

For children, young adults, adults, and elders, the backend needs:

1. **A living corpus API** — approved, non-sacred (or consent-gated) lexemes, phrases, and lessons, filtered by mode/age and clan  
2. **Real audio** — signed playback URLs from private storage; no public bucket URLs for clan/sacred material  
3. **Curriculum** — ordered paths (greetings → kinship → land → daily life), authored in the Keeper portal  
4. **Household identity** — child, parent, elder on one clan, with COPPA-aware child accounts and a guest/elder-friendly sign-in  
5. **Progress without gamification** — “heard / used in the home / taught to another” rather than streaks and XP (Protocol 10)  
6. **Elder recording that actually records** — field capture on the phone, pending queue, Keeper approval that writes to the same `audio_recordings` table the admin studio uses  
7. **Offline pack** — durable, encrypted, quota-limited mirror of *approved* content for Little Ones’ iPads and Elders’ phones  

None of those seven are end-to-end today. Several exist as Flutter types and protocol tests only.

---

## 6. Gaps and holes (inventory)

### 6.1 Security and sovereignty — blockers before any network exposure

| Hole | Why it matters |
|------|----------------|
| **API has no authentication** | Clerk secret is required in config and never used. `PyJWT` is unused. Admin client sends no `Authorization` header. |
| **Service role used for all API work** | RLS policies do not constrain the backend. The API *is* a superuser. |
| **`include_sacred=true` is a public query flag** | Protocol 4 is documentation on this route. |
| **Approve/review take a raw UUID** | Anyone can approve audio or contributions as any speaker. |
| **Grok endpoints unauthenticated** | Cost, abuse, and possible leakage of prompts that might include restricted language. |
| **No rate limiting, no security headers, no audit writes** | `audit_log` table exists; the API never inserts into it (Protocol 7). |
| **Public storage URLs** | Upload code calls `get_public_url` while migrations describe a private bucket. |
| **Audio duration/size not enforced** | `AUDIO_MAX_DURATION_SECONDS` is unused. |
| **No export controls** | Protocol 9 has no API enforcement. Bulk import exists; bulk export governance does not. |

### 6.2 Two backends that do not talk

Mobile expects secure RPCs. FastAPI exposes REST. Admin writes lexicon via REST. Learners never see those writes unless someone also builds the RPC layer and a sync path. **This is the hole that prevents “Keeper enters a word, child hears it.”**

### 6.3 Schema vs. teaching app

Missing from SQL entirely:

- `lessons`, `lesson_items`, `curricula`, `households`, `learner_profiles`  
- Progress / mastery persistence (Flutter has six stages locally)  
- Sense-level lexicon, morphemes, paradigms, sources, attestation grades  
- Age-band flags distinct from visibility  
- Assessments that are relational (can you greet Grandmother?) rather than scored games  

Present in SQL but missing from the API:

- `phrases` / `phrase_audio` — **no router**  
- `pronunciation_variants` — table yes, Keeper UI no  
- `cultural_narratives` — list-ish cultural routes, incomplete  
- Speaker create/update — API yes, admin UI no  

### 6.4 Knowledge Keeper portal — unfinished work that docs treat as done

| Screen | Reality |
|--------|---------|
| Lexicon search | Input is not wired |
| Approvals Approve/Reject | No handlers |
| Contribution Review | Button does nothing; protocol checkboxes are local-only |
| Contribution submit form | Missing |
| Speaker create/edit | Missing |
| Land create + map | Read-only cards |
| Pronunciation-variant editor | Missing |
| Lesson / curriculum authoring | Does not exist in admin |
| Dashboard stats | Hardcoded “9+ / PhD / PostGIS” |
| RBAC | Any signed-in Clerk user sees the full Keeper surface |

### 6.5 Type / SQL / validation drift

These will cause 500s and silent data loss as soon as Sharente uses “advanced” categories:

- Pydantic and Zod allow `numeral`, `classifier`, `incorporative`; PostgreSQL `lexical_category` does not  
- Types use `cultural_domain_id`; SQL and validation use `domain_id`  
- Narrative types expect `narrative_*` columns; SQL still has `content_*` / `story_type` after the `stories` → `cultural_narratives` rename  
- Two seed orthographies are both `is_primary = true`  
- API health and `foundation_status` expect migration `004`; migration `005` exists and is used by stewardship panels but is not registered in `schema_migrations`  

### 6.6 RLS is incomplete even if the API stopped using the service role

- Several tables have RLS enabled with **no policies** (deny-all for non-superuser)  
- Others have **no RLS at all** (`pronunciation_variants`, `example_sentences`, `ai_interactions`, `audit_log`, link tables)  
- Authenticated SELECT on lexicon allows **any** logged-in user to read approved **clan** rows — not clan-scoped  

### 6.7 Operational / engineering holes

- No `.github/` workflows, no Docker, no Linux process model (PM2 config points at Windows `uvicorn.exe`)  
- No pytest, no admin component tests, no API contract tests  
- Turbo has no `test` task  
- Sync Supabase client inside `async def` routes will block under load  
- `datetime.utcnow()` is deprecated  
- Root docs say migrations 001–004; 005 is a second, half-integrated track  
- `LanguageApp.psd1` is an empty PowerShell stub  
- `packages/database` re-exports types; it does not generate Supabase types  

### 6.8 Mobile-specific holes (they become backend holes)

- Hardcoded `_offlineCorpus`  
- Recording stub path `assets/audio/elder_upload_stub.mp3`  
- Sacred encryption is a SHA-256 “stub,” not SQLCipher  
- Handbook references `pilot_live/` and `seeding/` features that are not in `lib/features/`  
- Version story: pubspec v2.3.0 “Sovereign Production-Ready” vs. root v0.4.0 scaffold  

---

## 7. Bugs and defects (concrete)

These are not “future work.” They are incorrect behavior relative to the platform’s own claims.

1. **Sacred content bypass** — `GET /api/v1/lexicon?include_sacred=true` has no elder check (`apps/api/app/routers/lexicon.py`).  
2. **Unauthenticated mutation** — `POST /lexicon`, `/lexicon/bulk`, `/speakers`, `/audio/upload`, `/audio/{id}/approve`, `/contributions/{id}/review` are open.  
3. **Audio `context_tags` dropped** — admin studio sends them; upload router does not accept them.  
4. **No audio reject endpoint** — Approvals UI implies reject; API only approves.  
5. **Contribution protocol acknowledgments hardcoded** — create path writes `[1,2,3,4,5]`, not the twelve protocols the UI checkboxes describe.  
6. **Bulk import “approved” counter** — counts non-elder-review rows as approved even when status is still `pending`.  
7. **Error envelope split** — lexicon uses `{ error: { code, message, details } }`; most routers use FastAPI `{ detail }`. Admin error parsing will misfire.  
8. **Speakers dual-mounted** at `/api` and `/api/v1` — versioning smell, duplicate surface.  
9. **Orthographies spellings route** is lexicon data hung on the wrong resource.  
10. **Grok does not check sacred** — `lexical_entry_id` can be passed without a sacred/visibility test (Protocol 6).  
11. **AI interactions log `user_id = null`** — no actor identity.  
12. **Land insert WKT** — `POINT(lng lat)` without an explicit geography cast; brittle against PostGIS typing.  
13. **Admin lexicon search dead.**  
14. **Admin approval buttons dead.**  
15. **Admin contribution review dead.**  
16. **Seed dual primary orthography** — Protocol 12 wants one community-preferred primary.  
17. **Category enum mismatch** — creating a `numeral` via API will 500 against Postgres.  
18. **Mobile never receives admin lexicon writes.**  
19. **Guest mobile access** on shell routes with no child-account policy.  
20. **`foundation_ready` lies after 005** — applying stewardship RPCs does not update `schema_migrations`, so health still keys off `004`.

Git history already shows a cluster of lexicon 500s around `alternate_spellings` (null vs. array). That is a warning: validation and SQL are still loosely coupled.

---

## 8. Protocol enforcement: constitution vs. code

The enforcement matrix in `CULTURAL_PROTOCOLS.md` marks most protocols “API ✓ / UI ✓.” A stricter reading:

| Protocol | Schema | API | Admin UI | Mobile | Honest status |
|----------|--------|-----|----------|--------|----------------|
| 1 Speaker sovereignty | Strong (`speaker_id` NOT NULL) | Upload requires speaker | Studio requires speaker | Stub recording | **Partial** — identity of *operator* not verified |
| 2 Generational respect | Enums exist | No “elder pronunciation first” ranking | Clan tree | Mode typography | **Partial** |
| 3 Sharente honor | Role + seed + badges | No Sharente-gated review | Badge only; no dedicated path | Keeper panel is simulation | **Partial** |
| 4 Sacred protection | CHECK sacred ≠ public | Bypass flag; no RLS teeth | Zod rule + notice | Consent UX, stub encryption | **Unsafe if exposed** |
| 5 Clan boundaries | `clan_id`, visibility default clan | Service role ignores RLS | Default clan in forms | Designed, not backed | **Weak** |
| 6 AI boundaries | `ai_interactions` table | Disclaimer + log; no sacred filter | Disclaimer UI | N/A | **Soft only** |
| 7 Audit | Table exists | **Never written** | None | Local Isar audit | **Failing** |
| 8 Variation | Tables exist | List endpoints | No variant editor | Designed | **Schema-only** |
| 9 External sharing | Docs | None | None | None | **Docs only** |
| 10 Dignity | N/A | N/A | Design system | Strong (no gamification) | **Best-kept protocol** |
| 11 Land | PostGIS real | CRUD exists | Read-only | Metadata fields | **Incomplete UI** |
| 12 Orthography | Multi-system real | List + variants on create | Editor variants | — | **Strongest linguistic feature** |

Protocols are a constitution. Constitutions that are not enforced become poetry. The work is to make the matrix true.

---

## 9. Recommended upgrades

Work is grouped by **dependency**, not calendar. Later tracks assume earlier tracks exist.

### Track 0 — Tell the truth in the repo

- Call v0.4 what it is: **Keeper foundation / learner prototype**.  
- Align version numbers (root, API, mobile pubspec, capability statement).  
- Register migration 005 in `schema_migrations` or stop claiming `foundation_ready` from 004 alone.  
- Fix the Knowledge Keepers Guide where it describes UI that does not exist (speaker CRUD, land entry, dedicated Sharente review, wired approvals). Overpromising Keepers is a cultural defect, not just a docs defect.

### Track 1 — Close the front door (sovereignty)

Nothing else should ship to a hosted URL until this track exists.

1. Verify Clerk JWTs on every mutating and sacred-capable API route.  
2. Map Clerk user → `speakers` row; derive role (`elder_keeper`, `sharente_keeper`, `clan_teacher`, `learner`).  
3. Stop using the service role from request handlers. Use the user JWT + RLS, or a narrow edge function. Keep service role for migrations and explicit admin jobs.  
4. Gate `include_sacred`, audio approve, contribution review, and bulk import on elder/Sharente authority.  
5. Write `audit_log` on create/update/approve/reject with actor, previous, and next values.  
6. Private audio bucket + **signed URLs**; delete `get_public_url` for clan/sacred/family content.  
7. Rate-limit Grok; refuse to send `is_sacred` rows into prompts.  
8. Enforce audio MIME allowlist, max bytes, and duration.  
9. Add TrustedHost, security headers, and CORS that is not `*` headers with credentials in production.

### Track 2 — Make Keeper ingest complete

This is the Sharente daily tool.

1. Wire Approvals (approve / reject / request changes) and persist reviewer identity.  
2. Wire Contributions submit + review; persist all twelve protocol acknowledgments.  
3. Speaker and kinship editor in admin (create, relate `parent_speaker_id`, mark Sharente/elder with consent).  
4. Pronunciation-variant editor (Protocol 8).  
5. Land site create with a real map, plus link-to-lexeme from the lexicon editor.  
6. Lexicon **edit** from browse (not create-only), and make search work.  
7. Align enums: migrate SQL `lexical_category` to match Pydantic/Zod, or remove the extra values from the API.  
8. One primary orthography; historical manuscript row if Keepers want it seeded.  
9. Strongly type cultural, land, and contribution routers (no raw `dict`).  
10. CSV import template + dry-run + row-level error report already exists — add **attestation** and **source** columns when Track 3 lands.

### Track 3 — Ph.D. linguistic substrate (the real upgrade for Sharente)

Add normalized tables. Keep the current text fields as denormalized summaries for learners.

**Suggested new objects**

| Table | Purpose |
|-------|---------|
| `sources` | Williams, Costa, Jopson, manuscripts, Keeper field notes; citation metadata |
| `attestations` | Links an entry/sense to a source, page, year, and grade (`living` / `historical` / `restored` / `neologism` / `uncertain`) |
| `lexical_senses` | Split glosses; examples and audio hang off a sense |
| `morphemes` | Initial / medial / final / particle; gloss; class |
| `lexeme_morphemes` | Ordered analysis of a word |
| `verb_classes` + `paradigm_cells` | AI/II/TA/TI, order, person, number, obviation; each cell attested or generated-with-note |
| `noun_features` | Animate/inanimate, dependent, locative stem, diminutive |
| `lexical_relations` | Structured links between entries |
| `comparative_notes` | Sister-language forms, explicitly non-authoritative for community usage |
| `confidence` | Keeper-set, never model-set |

**API for Sharente**

- Entry wizard: Core → Analysis → Sources → Land → Audio → Governance  
- Paradigm grid editor (empty cells are honest absences, not zeros)  
- Source library with “this form is restored; here is the argument”  
- Export for Sharente’s own files (Keeper-only, Protocol 9 gated), never a public dump  

This is how a dissertation becomes a living database instead of a PDF beside an app.

### Track 4 — Unify the backend so teaching can happen

Pick one learner data path. The Master Architecture Document already chose **Supabase RPCs + RLS**. Honor it.

1. Implement the RPCs mobile already names — or change mobile to call FastAPI with the same JWT claims. Do not leave both as fiction.  
2. Add `lessons`, `lesson_items` (audio block, lexeme, phrase, land moment), `curricula`, `curriculum_nodes`.  
3. Admin **Lesson Studio**: Sharente sequences oral blocks; Protocol 7 oral-first is a data constraint (`primary_audio_id` required for published learner items).  
4. When a Keeper approves a lexeme/audio, it becomes visible to the RPCs the app already calls.  
5. Households: a clan household, adult sponsor, child profiles, elder profiles.  
6. Progress events: `heard`, `repeated`, `used_in_home`, `taught` — no points. Optional spaced *review invitations* that look like “Grandmother’s words for this week,” never a streak freeze.

### Track 5 — Real voice

Oral-first is a lie until there is audio.

1. Production MediaRecorder path in admin (already close) + Flutter `record` + playback.  
2. Waveform stored as documented; playback via signed URL.  
3. Elder phone capture → same `audio_recordings` pending queue as the studio.  
4. No TTS presented as a speaker (Protocol 1). If a learner-phonetic *hint* voice is ever added, label it machine and never attach it to a living person.  
5. Quality and ceremony flags: `live_ceremony` must force sacred/elders_only.

### Track 6 — Tests, delivery, maintainability

A small tribal team cannot keep a constitution if CI does not.

- pytest for API: authz matrix (sacred, approve, bulk), lexicon validators, bulk import, audio MIME  
- Playwright for admin: create lexeme, upload audio, approve  
- Keep Flutter protocol suite; add a test that **fails** if RPC names are not in migrations  
- GitHub Actions: lint, typecheck, pytest, flutter test  
- Dockerfile for API (Linux), not Windows PM2 as the only process story  
- Generated types from Supabase (`packages/database` should be real)  
- Structured logging and an error tracker that **redacts** linguistic content  
- `supabase db push` (or CLI migrate) instead of “paste SQL in the dashboard” as the only path  

---

## 10. Enhancements that make this a future place for language building

These are not toys. They are how revitalization platforms last into 2050 without becoming either a toy app or an extractive archive.

### 10.1 Living authority, not a frozen dictionary

- Every learner-facing string carries **who said it, when, on what land (if shareable), and whether it is living, historical, or restored**.  
- Younger speakers can contribute *practice* audio (`quality: practice`) that never outranks an elder variant.  
- When two speakers differ, the UI shows both. Never a red X.

### 10.2 Household as the classroom

- One clan household: Little Ones iPad, young-adult phone, adult, elder.  
- Shared weekly words chosen by a Keeper or parent, not an algorithm optimizing engagement.  
- “Listen together” sessions: the app is a fire to sit around, not a slot machine.

### 10.3 Field linguistics in the pocket

- Elder and Sharente field mode: record, tag land (optional), tag season, mark sacred, queue for review.  
- Offline queue with durable storage (real Isar or sqlite, encrypted).  
- Conflict rule: living elder/Sharente always wins over stale offline edits.

### 10.4 Reconstruction workshop (Keeper-only)

A private workspace where Sharente can:

- Align historical spellings (Williams, Costa, manuscripts) with community preferred forms  
- Attach an argument: “restored from Massachusett X; community has not yet spoken this”  
- Promote a restored form to living only after a living speaker records it  

This is how Ph.D. method becomes tribal infrastructure instead of staying in a university.

### 10.5 Land and season as teachers

- “Words of this river,” “words of planting,” “words of this kitchen.”  
- PostGIS is already there; the teaching app should query it (`ST_DWithin` for optional, consenting field trips — never covert tracking).  
- Seasonal curriculum that changes with the year, not with a content calendar invented in a sprint.

### 10.6 AI that stays in its place (Protocol 6)

Keep Grok (or any model) as:

- Learner helper for *already approved* public/clan educational items  
- IPA *suggestion* that a Keeper must accept  
- Never: auto-lexicon, ceremonial generation, synthetic elder voice, sacred retrieval, bulk scrape  

Add: retrieval only from approved rows; prompt firewall; per-clan keys; full `ai_interactions` with user id; Keeper switch to disable AI for a household.

A futuristic revitalization platform is not “more AI.” It is **more living voices, better structured knowledge, and software that refuses to impersonate the people**.

### 10.7 Interlinear and teaching views

- Morpheme-aligned examples for Core Adult / Sharente study  
- Picture-and-voice only for Little Ones  
- Large type + audio for Elders  
- Same record, three presentations — the admin design-system modes already hint at this

### 10.8 Sovereignty operations

- Data residency: primary data in the tribe’s Supabase project; no third-party linguistic store  
- Keeper-controlled export: encrypted archive for tribal custody  
- Research access as a *separate legal and technical path*, not a SQL user  
- Protocol versioning that actually blocks deploys when `protocol_versions` and app constants disagree

### 10.9 Observability that does not surveil learners

- Stewardship counts (already the right ethic: absolute numbers, no fake percentages)  
- Health of ingest: entries awaiting elder review, recordings without playback, lessons without audio  
- No child behavioral analytics, no attention mining

---

## 11. Suggested build order for the family

If the question is “what do we do so Sharente’s knowledge can teach the children,” the sequence is:

1. **Lock the API** (Track 1). Sacred language cannot live behind an open door.  
2. **Finish the Keeper loop** (Track 2): enter → attribute → record → elder/Sharente approve → living. Until approval buttons work, the corpus cannot become a teacher.  
3. **Connect admin writes to learner reads** (Track 4, thinnest slice): one RPC or one authenticated REST list of *approved* lexemes with signed audio. Prove “Sharente saves a word, a child hears it.”  
4. **Replace stubs with a microphone and a speaker** (Track 5).  
5. **Grow the linguistic model as Sharente needs it** (Track 3) — start with senses, sources, attestation, animate/inanimate, and verb class; add full paradigms when the first cluster of verbs is ready.  
6. **Author ten oral lessons** in the portal for Little Ones and Elders (greetings, kinship, land, food). Curriculum quality matters more than feature count.  
7. **Household pilot** with real devices, real voices, migration 005 live, and the capability statement updated to match reality.

Do not start with a public app store listing, a large generated corpus, or a more powerful model. Start with one living voice, one approved word, one child who can hear it offline.

---

## 12. Capability scorecard (honest)

| Capability | Score | Note |
|------------|-------|------|
| Cultural constitution | High | Best asset in the repo |
| Speaker / clan / Sharente model | High | Schema and seed are thoughtful |
| Dictionary-style ingest for Keepers | Medium-high | Editor + bulk import work; search/edit/approval incomplete |
| Ph.D. structural linguistics | Low | Free-text morphology, no paradigms, no sources graph |
| Sacred / clan enforcement | Low in production | Flags exist; authz does not |
| Audio as living authority | Medium (admin capture) / Low (mobile + playback + private storage) | |
| Land knowledge | Medium | PostGIS real; no map UX; no learner geo lessons |
| Multi-age teaching app | Low | Modes and dignity yes; content, audio, sync no |
| Offline field use | Low | Designed; in-memory and stubs |
| AI assistance | Medium (soft) | Disclaimer present; sacred/auth missing |
| Ops / tests / deploy | Low | No CI, no API tests, Windows PM2 |
| End-to-end “Keeper → child” | **Not present** | Two backends, no shared living corpus path |

**Overall:** Kuttiomp is an unusually principled **v0.4 Knowledge Keeper foundation** with a **Flutter teaching shell**. It is ready for guided, private, family data-entry and protocol design work. It is not ready to carry the language of a people on the public internet, and it is not yet a school.

---

## 13. Closing

The gathering place is framed. The fire laws are written. The shelves for words, voices, land, and Sharente authority are built in outline.

What remains is to put locks on the doors, to give Sharente shelves that can hold a dissertation without flattening it, to let an elder’s recording become a child’s first hearing, and to keep every future feature answerable to one sentence:

*This serves our people by keeping the language living, attributed, and teachable — from Little Ones to Elders — under the authority of those who carry it.*

Wunnegan.
