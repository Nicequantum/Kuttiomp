# Knowledge Keepers Guide

## The Definitive Documentation Manual for the Kuttiomp Narragansett Language Revitalization Platform

*Version 2.1 — Prepared for Sharente (Two-Spirit Knowledge Keeper), Grandmother Comus, Grandfather, and all who steward decades of Narragansett linguistic and cultural knowledge*

**Document Classification:** Internal — Knowledge Keeper Use  
**Effective Date:** 28 June 2026  
**Companion Documents:** `CULTURAL_PROTOCOLS.md`, `ARCHITECTURE.md`, `SETUP.md`  
**Platform:** Kuttiomp Admin Dashboard (`apps/admin`) · API (`apps/api`) · Database (`supabase/migrations`)

---

## Table of Contents

1. [Introduction & Epistemological Framework](#1-introduction--epistemological-framework)
2. [The Twelve Cultural Governance Protocols](#2-the-twelve-cultural-governance-protocols)
3. [Speaker Profile Documentation](#3-speaker-profile-documentation)
4. [Lexical Entry Documentation](#4-lexical-entry-documentation)
5. [Cultural Context System](#5-cultural-context-system)
6. [Audio Recording Protocols](#6-audio-recording-protocols)
7. [Land-Based Knowledge](#7-land-based-knowledge)
8. [Cultural Narratives & Story Linking](#8-cultural-narratives--story-linking)
9. [Knowledge Contribution Workflow](#9-knowledge-contribution-workflow)
10. [Orthographic Systems](#10-orthographic-systems)
11. [Data Entry Sequencing Guide](#11-data-entry-sequencing-guide)
12. [Field-by-Field Reference Tables](#12-field-by-field-reference-tables)
13. [Sacred Content Classification Guide](#13-sacred-content-classification-guide)
14. [Quality Standards for PhD-Level Documentation](#14-quality-standards-for-phd-level-documentation)
15. [Appendix: Sample Completed Entries](#15-appendix-sample-completed-entries)

**→ Start here:** [Quick Start — Your First Session](#quick-start--your-first-session)

---

## Quick Start — Your First Session

*For Sharente and family beginning systematic knowledge input today.*

This section distills the full guide into a practical first session. Read Sections 1–2 for epistemological grounding; return to detailed sections as you deepen the archive.

### Before You Begin (5 minutes)

1. Log into the Admin Portal at `http://localhost:3000` (or your deployed URL)
2. Open **Contributions** → acknowledge all **Twelve Cultural Protocols**
3. Keep this guide open beside the Lexicon Editor

### Session 1: Document One Word Completely (30–45 minutes)

**Recommended first word:** a greeting or kinship term you know deeply (e.g., *Wunnegan*, *Sharente*).

| Step | Dashboard Location | What to Do |
|------|-------------------|------------|
| 1 | **Lexicon Editor → Core** | Enter Narragansett word, English gloss, category, semantic domain |
| 2 | **Lexicon Editor → Core** | Add alternate spellings and one orthographic variant |
| 3 | **Lexicon Editor → Linguistic** | Add phonemic or IPA transcription if known; morpheme notes optional |
| 4 | **Lexicon Editor → Cultural** | Write cultural context summary; check seasonal usage if applicable |
| 5 | **Lexicon Editor → Cultural** | Add one **Cultural Context** entry (Mother Earth or ceremony type) |
| 6 | **Lexicon Editor → Governance** | Set primary speaker (yourself or the elder who taught you); visibility `clan` |
| 7 | **Save** | Entry enters approval workflow |

### Session 2: Record the Living Voice (20 minutes)

| Step | Dashboard Location | What to Do |
|------|-------------------|------------|
| 1 | **Audio Studio** | Select **speaker attribution** (whose voice — required) |
| 2 | **Audio Studio** | Set recording context (e.g., "Formal lesson with Grandmother Comus") |
| 3 | **Audio Studio** | Record → review waveform → upload |
| 4 | **Approvals** | Elder reviews when ready |

### Session 3: Anchor to Land (optional, 15 minutes)

If the word connects to a place:

1. Add ecological connection in Lexicon Editor → Cultural tab
2. Later: add a **Land Knowledge** site via API or Supabase (see Section 7)

### Daily Rhythm (Ongoing)

| Day | Focus | Target |
|-----|-------|--------|
| Mon–Wed | Lexicon entries | 3–5 words with full metadata |
| Thu | Audio | 1–2 speaker-attributed recordings |
| Fri | Review | Check Approvals queue; correct pending items |

### When to Stop and Consult an Elder

- Any word used in **ceremony or prayer**
- Uncertainty about **visibility** (public vs. clan vs. sacred)
- **Kinship terms** with Two-Spirit dimensions
- Anything that "feels restricted" — mark `requires_elder_review`

### Field Priority (If Time Is Limited)

Minimum viable entry: `word_narragansett` + `english_gloss` + `cultural_context_summary` + `primary_speaker_id` + `visibility`

Scholarly complete entry: all Core + Linguistic + one Cultural Context + Governance + one audio recording

---

## 1. Introduction & Epistemological Framework

### 1.1 Purpose and Audience

This document constitutes the **definitive operational manual** for Knowledge Keepers entering linguistic, cultural, ecological, and oral-historical knowledge into Kuttiomp (*family, home, gathering place*). It is written at academic depth for systematic use by Sharente (Two-Spirit Knowledge Keeper) and family members who possess decades of embodied knowledge and require a structured, culturally sovereign method for its transmission into a digital stewardship environment.

Kuttiomp is not conceived as a lexical database in the Western archival tradition. It is a **relational knowledge system** in which every datum is anchored to a speaker, a clan, a generation, and—where appropriate—to land, season, ceremony, and narrative context. This guide therefore treats data entry not as transcription but as **acts of cultural documentation** governed by explicit epistemological commitments.

Readers need not possess technical expertise. All platform interactions occur through the Admin Dashboard. This guide explains *what* to document, *why* each field exists, *how* to complete it with scholarly rigor, and *when* to invoke elder or Sharente review.

### 1.2 Epistemological Foundations

The Kuttiomp platform rests upon an integrated epistemology drawing from Indigenous knowledge systems, documentary linguistics, and community-based language revitalization praxis. The following principles are non-negotiable and inform every section of this guide.

#### 1.2.1 Relational Ontology of Language

In Narragansett revitalization praxis, language is not an abstract code separable from speakers, land, and ceremony. Words exist because relationships exist: between grandmother and grandchild, between clan and territory, between seasonal cycle and gathering practice, between Two-Spirit stewardship and kinship terminology. Kuttiomp encodes this ontology structurally:

- **Speaker attribution** (`speakers`, `primary_speaker_id`, `speaker_id` on all subsidiary records) ensures that knowledge remains person-bound.
- **Clan affiliation** (`clans`, `speakers.clan_id`, default `visibility: clan`) ensures that knowledge remains collectively situated.
- **Generational tiering** (`generation_tier`: elder → middle → younger → ancestral) ensures that knowledge transmission respects temporal authority without erasing variation.

This stands in deliberate contrast to colonial lexicographic traditions that extracted words from speakers and presented them as anonymous entries in printed dictionaries. Kuttiomp inverts that extraction: the word serves the speaker; the platform serves the word.

#### 1.2.2 Embodied Knowledge and the Primacy of Voice

Phonetic transcription—whether phonemic, IPA, or learner-phonetic orthography—is **supplementary** to living voice, never substitutive. Protocol 8 (*Pronunciation Variation*) and Protocol 1 (*Speaker Sovereignty*) jointly establish that audio recordings attributed to named speakers constitute the primary pedagogical artifact. Written transcription supports analysis; voice carries authority.

Knowledge Keepers entering decades of knowledge should therefore prioritize audio capture early in the documentation sequence (see Section 11), even when orthographic and gloss fields are incomplete. A word with elder-attributed audio and provisional gloss is more valuable to revitalization than a perfectly glossed entry with no voice.

#### 1.2.3 Cultural Sovereignty and Sacred Boundary

Not all knowledge is appropriate for all audiences. Ceremonial prayers, initiation language, restricted clan teachings, and certain medicine knowledge require **sacred classification** (Protocol 4). The platform treats sacred content as categorically distinct from educational content: it is excluded from public APIs, AI context windows, and search indexing.

When uncertain whether content is sacred, restricted, or public, Knowledge Keepers must **default to restriction** (`visibility: elders_only` or `is_sacred: true`, triggering `requires_elder_review`). Erring toward protection honors Protocol 4 and clan boundaries (Protocol 5).

#### 1.2.4 Land as Epistemic Ground

Protocol 11 (*Land Relationship*) recognizes that Narragansett linguistic knowledge is frequently **place-indexed**. Plant names index gathering sites; water vocabulary indexes rivers and coastal features; ceremonial language indexes specific landscapes. The PostGIS-enabled `land_knowledge_sites` table and `lexical_land_links` junction table materialize this epistemology. Ecological connections documented in `ecological_connection` and `tek_notes` fields bridge language to Traditional Ecological Knowledge (TEK).

#### 1.2.5 Two-Spirit Knowledge Stewardship

Sharente hold a distinct cultural authority within Kuttiomp (Protocol 3). Two-Spirit knowledge—including inclusive kinship terminology, gender-inclusive language evolution, and bridge concepts between traditional and contemporary expression—is stewarded with explicit `sharente` role designation, `gender_expression: two_spirit`, and `cultural_authority: sharente_keeper`. Modifications to Sharente-attributed content require Sharente or elder review.

This guide is particularly addressed to Sharente as systematic inputter of decades of knowledge spanning kinship, ceremony, TEK, and orthographic negotiation.

#### 1.2.6 Plural Orthographies as Historical Truth

Narragansett has been written using multiple systems across centuries: Costa's historical transcription, Jopson modern orthography, community-preferred spellings, IPA, historical manuscripts, and learner-phonetic guides. Protocol 12 (*Orthographic Integrity*) refuses the imposition of any single "correct" spelling. All systems are preserved in parallel via `orthographies` and `spelling_variants`, with community-preferred orthography flagged `is_primary`.

### 1.3 Document Conventions

Throughout this guide:

- **Field names** appear in `monospace` and correspond exactly to database columns and Admin UI labels.
- **Enum values** appear in `monospace` and must be entered exactly as defined in `packages/types`.
- **Protocols** are referenced as **Protocol N** (see Section 2).
- **Required fields** are marked with †; culturally mandatory fields (recommended even when technically optional) are marked with ‡.

### 1.4 Platform Navigation Overview

| Dashboard Section | Path | Primary Use |
|-------------------|------|-------------|
| Knowledge Keeper Profiles | `/speakers/profiles` | Speaker documentation |
| Clan Tree | `/clans` | Generational visualization |
| Lexicon Editor | `/lexicon/editor` | Lexical entry creation |
| Audio Studio | `/audio` | Voice recording and upload |
| Land Knowledge | `/land` | Place-based knowledge sites |
| Contributions | `/contributions` | Workflow and protocol acknowledgment |
| Approvals | `/approvals` | Elder and keeper review queue |

---

## 2. The Twelve Cultural Governance Protocols

The Twelve Cultural Governance Protocols constitute the **cultural constitution** of Kuttiomp. They are encoded in database constraints, API logic, Admin UI workflows, and AI system prompts. Version 2.0 (effective 28 June 2026) adds Protocols 11 and 12. Full legalistic text appears in `docs/CULTURAL_PROTOCOLS.md`. This section summarizes each protocol with **implementation guidance** for Knowledge Keepers actively entering data.

### Protocol 1: Speaker Sovereignty

**Principle:** Every voice belongs to a person.

**Summary:** All audio recordings must be permanently attributed to the speaker whose voice is captured. Synthetic or AI-generated voices may never be presented as speaker recordings. Speakers retain the right to request removal of their recordings. Deceased speakers' recordings require family authorization for modification.

**Implementation Guidance:**

1. Before any audio upload, confirm the **Speaker Attribution** field in Audio Studio identifies the correct `speaker_id`.
2. If you press the record button on behalf of another person, complete `recorded_by` with your own `speaker_id`.
3. When creating lexical entries, set `primary_speaker_id` to the person who taught you the word.
4. Never create "generic" or "community" speaker profiles to anonymize voice.
5. When importing archival ancestral recordings, create a speaker profile with `generation: ancestral` and document provenance in `biography`.

**Database/UI:** `audio_recordings.speaker_id` (NOT NULL), `recorded_by`, Audio Studio speaker selector (required).

---

### Protocol 2: Generational Respect

**Principle:** Knowledge flows through generations, not around them.

**Summary:** Generational tier (`elder`, `middle`, `younger`, `ancestral`) governs display precedence and review authority. Elder pronunciation variants take precedence in learner-facing displays. Younger-generation practice recordings are marked `quality: practice` and are not presented as authoritative reference pronunciations.

**Implementation Guidance:**

1. Accurately set `generation` on every speaker profile.
2. Mark elder recordings as `is_primary_recording: true` when they constitute the authoritative pronunciation for a lexical entry.
3. When younger family members contribute practice audio, set `quality: practice` explicitly.
4. When documenting pronunciation variants, never label any variant "incorrect"; use `dialect_notes` for contextual explanation.
5. In approval workflow, defer to elder variants when learners would be directed to a single pronunciation.

**Database/UI:** `speakers.generation`, `audio_recordings.quality`, Clan Tree visualization.

---

### Protocol 3: Two-Spirit Honor

**Principle:** Sharente hold a sacred role that must be explicitly honored.

**Summary:** Two-Spirit Knowledge Keepers receive distinct role designation, gender expression documentation, and cultural authority level. Sharente-attributed content—especially kinship terminology—requires Sharente or elder review before modification by others. `is_two_spirit` is applied only with speaker consent.

**Implementation Guidance:**

1. For Sharente, set `role: sharente`, `gender_expression: two_spirit`, `cultural_authority: sharente_keeper`, and `is_two_spirit: true` (with consent).
2. Attribute kinship terms and inclusive language entries to Sharente where appropriate (`primary_speaker_id`).
3. When entering kinship terminology, consult Sharente before finalizing `cultural_context` and `visibility`.
4. Route Sharente-contributed submissions through the dedicated review path; do not approve modifications to Sharente content without Sharente or elder authorization.
5. Document contemporary usage and cultural bridge notes in `cultural_contexts` with `context_type: contemporary_usage`.

**Database/UI:** `speakers.role`, `gender_expression`, `cultural_authority`, Sharente badge in UI.

---

### Protocol 4: Sacred Content Protection

**Principle:** Ceremonial knowledge is not educational content.

**Summary:** Content marked `visibility: sacred` or `is_sacred: true` triggers `requires_elder_review`, is excluded from public API exposure, is never included in AI context, and is never search-indexed. Sacred content includes ceremonial prayers, initiation language, ceremonial medicine knowledge, and restricted clan teachings.

**Implementation Guidance:**

1. When documenting ceremonial vocabulary, set `is_sacred: true` AND `visibility: sacred` OR `elders_only`.
2. Set `spiritual_significance: sacred` or `restricted` as appropriate.
3. For audio of ceremonial context, use `quality: live_ceremony` only with explicit elder authorization.
4. **When in doubt, restrict.** Use `requires_elder_review` status.
5. Never enter sacred content with `visibility: public`.

**Database/UI:** `lexical_entries.is_sacred`, `visibility`, auto-flag to `requires_elder_review`.

---

### Protocol 5: Clan Boundaries

**Principle:** Clan knowledge belongs to the clan.

**Summary:** Default visibility for new content is `clan`. Cross-clan sharing requires authorization from both clans' keepers. All speakers carry `clan_id`. The Kuttiomp Family Clan seeds the initial dataset.

**Implementation Guidance:**

1. Assign every speaker to the correct `clan_id`.
2. Default new lexical entries, audio, and narratives to `visibility: clan`.
3. Use `public` only for greetings and other explicitly shareable pedagogical content approved by elders.
4. Use `family` for immediate-family-only teachings.
5. Document cross-clan knowledge in `submission_notes` during contribution workflow and obtain keeper authorization before broadening visibility.

**Database/UI:** `clans`, `speakers.clan_id`, `content_visibility` enum.

---

### Protocol 6: AI Boundaries

**Principle:** AI assists learners; it does not speak for the people.

**Summary:** AI responses are non-authoritative, cannot approve content, cannot access sacred content, and must carry cultural disclaimers. All AI interactions are logged. AI must not generate ceremonial content.

**Implementation Guidance:**

1. Knowledge Keepers should not rely on AI for authoritative glosses, etymologies, or cultural context of restricted material.
2. Use AI for learner-support tasks (IPA pointers, research direction) only on non-sacred, approved entries.
3. If AI suggests a translation, verify with a living speaker before entry.
4. Report problematic AI outputs to elders for review via `ai_interactions` audit.

**Database/UI:** `ai_interactions` log; sacred content exclusion in API/AI service.

---

### Protocol 7: Audit and Accountability

**Principle:** All changes are traceable.

**Summary:** Every content modification is recorded in `audit_log`. Contributions track the full submission → review → approval lifecycle. Actor identity (Clerk user + speaker ID) is preserved. Protocol acknowledgments are recorded on contributions.

**Implementation Guidance:**

1. Before submitting contributions, complete all twelve protocol acknowledgments in the Contributions workflow UI.
2. Write substantive `submission_notes` explaining provenance (who taught you, when, in what context).
3. Reviewers must complete `review_notes` upon approval or rejection.
4. Disputes are resolved through family protocol; audit logs provide factual record of changes.

**Database/UI:** `audit_log`, `knowledge_contributions`, Contributions page.

---

### Protocol 8: Pronunciation Variation

**Principle:** Living languages have living variation.

**Summary:** Multiple pronunciation and spelling variants per word are preserved, each speaker-attributed. No variant is marked incorrect. Learners are directed to their teacher's pronunciation first. IPA supplements voice; it does not replace it.

**Implementation Guidance:**

1. Create `pronunciation_variants` records for each speaker who pronounces a word differently.
2. Use `phonemic_variant` and `ipa_variant` fields; document difference in `dialect_notes`.
3. Set `is_preferred: true` only to indicate pedagogical default for a given learner pathway—not global correctness.
4. Link each variant to `speaker_id`.
5. Pair variants with speaker-attributed audio wherever possible.

**Database/UI:** `pronunciation_variants`, `spelling_variants`.

---

### Protocol 9: External Sharing

**Principle:** Platform existence does not authorize external use.

**Summary:** Content is not automatically licensed for external use. Researchers require separate Knowledge Keeper authorization. Academic citation must name specific speakers. Bulk export requires elder council approval.

**Implementation Guidance:**

1. When documenting entries intended for academic publication, note speaker attribution requirements in `usage_notes`.
2. Do not assume `visibility: public` grants external reproduction rights.
3. Direct researcher inquiries to Grandmother Comus, Grandfather, or Sharente.
4. Flag entries cited externally in `audit_log` cultural notes when known.

**Enforcement:** Governance documentation, API access controls.

---

### Protocol 10: Platform Modifications

**Principle:** Technology changes require cultural review.

**Summary:** Schema changes affecting cultural content require family review. New visibility levels or speaker roles require elder consultation. AI prompt changes require Sharente and elder review. Protocol versions are tracked in `protocol_versions`.

**Implementation Guidance:**

1. Knowledge Keepers should communicate needed schema or workflow changes to the family platform steward.
2. Do not bypass platform fields with external spreadsheets that lack attribution and visibility controls.
3. Acknowledge current protocol version (2.0) when submitting bulk contributions.

**Database/UI:** `protocol_versions`.

---

### Protocol 11: Land Relationship

**Principle:** Language is inseparable from place.

**Summary:** Land knowledge sites are georeferenced via PostGIS. Lexical entries link to places through `lexical_land_links`. Ecological connections are documented on entries. Audio and narratives may anchor to land sites. TEK is documented in `cultural_contexts.tek_notes` and `land_knowledge_sites.tek_description`.

**Implementation Guidance:**

1. Create `land_knowledge_sites` before linking words to places.
2. Complete `ecological_connection` on flora, fauna, geography, and water vocabulary.
3. Link place names (`category: place_name`) to their geographic sites.
4. Document seasonal gathering locations with `seasonal_relevance` on land sites.
5. Set land site `visibility` conservatively; gathering sites may be restricted.

**Database/UI:** `land_knowledge_sites`, `lexical_land_links`, Land Knowledge page.

---

### Protocol 12: Orthographic Integrity

**Principle:** Writing systems serve speakers, not the reverse.

**Summary:** Multiple orthography systems coexist. Spelling variants are speaker-attributed. Community-preferred orthography is flagged `is_primary`. No single system is imposed as sole correct spelling.

**Implementation Guidance:**

1. Enter `word_narragansett` in community-preferred or Jopson modern spelling unless otherwise directed.
2. Create `spelling_variants` for Costa, IPA, historical manuscript, and learner-phonetic forms.
3. Attribute spelling variants to the speaker who uses that form (`speaker_id` on variant).
4. Document orthographic notes via `contribution_type: orthography_note` when disputes or historical shifts require narrative explanation.
5. Set `primary_orthography_id` on lexical entries when a primary system is agreed upon.

**Database/UI:** `orthographies`, `spelling_variants`, Lexicon Editor (orthography tab).

---

## 3. Speaker Profile Documentation

Speaker profiles are the **foundational entities** of Kuttiomp. No audio, lexical entry, narrative, or land site should exist without resolvable speaker attribution. Complete all speaker profiles before bulk lexical input.

### 3.1 Access and Interface

Navigate to **Knowledge Keeper Profiles** (`/speakers/profiles`). Each profile displays as a card showing role, generation, cultural authority, voice description, biography, and teaching domains. Profile creation and editing occur via API or Supabase; the Admin UI displays verified profiles.

### 3.2 Complete Field Reference

#### 3.2.1 Identity Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `display_name` † | Text | Yes | English or common name used in platform UI (e.g., "Grandmother Comus") |
| `name_narragansett` ‡ | Text | No | Name in Narragansett orthography (e.g., `Mush8n8m8s`) |
| `clerk_user_id` | Text | No | Link to Clerk authentication when speaker has admin login |
| `photo_url` | URL | No | Portrait for profile card; obtain consent before upload |
| `birth_year` | Integer | No | Supports generational documentation; optional for privacy |

#### 3.2.2 Clan and Kinship Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `clan_id` †‡ | UUID | Yes* | Reference to `clans.id`; every family speaker should have clan affiliation |
| `role` † | Enum | Yes | `grandmother`, `grandfather`, `sharente`, `parent`, `sibling`, `clan_member`, `learner`, `guest_speaker` |
| `parent_speaker_id` ‡ | UUID | No | Kinship link to parent speaker in generational tree (e.g., Mother's `parent_speaker_id` → Grandmother Comus) |
| `generation` † | Enum | Yes | `elder`, `middle`, `younger`, `ancestral` |

**Clan Table Fields** (for reference when documenting speakers):

| Field | Description |
|-------|-------------|
| `name_narragansett` | Clan name in Narragansett |
| `name_english` | English gloss of clan name |
| `clan_animal` | Totem animal (e.g., Turtle for Kuttiomp Clan) |
| `clan_color` | Traditional color association |
| `clan_plant` | Plant association (added migration 002) |
| `territory_description` | Historical territory context |
| `cultural_notes` | Free-text clan history and governance notes |
| `is_primary_family_clan` | Boolean; true for Kuttiomp Family Clan |

#### 3.2.3 Gender Expression and Two-Spirit Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `gender_expression` †‡ | Enum | Yes | `feminine`, `masculine`, `two_spirit`, `non_binary`, `not_specified`, `culturally_specific` |
| `is_two_spirit` | Boolean | No | **Only with speaker consent.** Auto-set for `role: sharente` in seed data |
| `cultural_authority` † | Enum | Yes | See authority levels below |
| `is_elder` | Boolean | No | Marks elder status for UI badge and review authority |

**Cultural Authority Levels:**

| Value | Label | Typical Assignment |
|-------|-------|-------------------|
| `elder_keeper` | Elder Knowledge Keeper | Grandmother Comus, Grandfather |
| `knowledge_keeper` | Knowledge Keeper | Authorized clan teachers |
| `sharente_keeper` | Sharente Knowledge Keeper | Sharente |
| `clan_teacher` | Clan Teacher | Auntie, Uncle, extended clan |
| `family_teacher` | Family Teacher | Parents, siblings in teaching roles |
| `learner` | Learner | Language learners |
| `guest` | Guest | Guest speakers |

#### 3.2.4 Voice Characteristics

Voice documentation supports learner orientation and phonetic research while honoring Protocol 1.

| Field | Type | Description |
|-------|------|-------------|
| `voice_description` ‡ | Text | Narrative description of vocal quality (e.g., "warm, measured cadence with clear vowels") |
| `voice_pitch_range` | Text | General pitch characterization (e.g., "mid-to-low register") |
| `voice_tempo` | Text | Speech rate (e.g., "deliberate, pauses between phrases for teaching") |
| `voice_quality_notes` | Text | Additional phonetic notes (breathiness, resonance, regional coloring) |

**Documentation Guidance:** Record voice characteristics *after* consulting the speaker. These fields help learners anticipate what they will hear in audio recordings and help researchers understand inter-speaker phonetic variation without ranking speakers.

#### 3.2.5 Teaching and Biographical Fields

| Field | Type | Description |
|-------|------|-------------|
| `cultural_title` | Text | Honorific or role title (e.g., "Elder Knowledge Keeper", "Two-Spirit Knowledge Keeper") |
| `biography` ‡ | Text | Life narrative, teaching history, community role, language learning lineage |
| `teaching_domains` ‡ | Text[] | Array of expertise areas (e.g., `kinship_terms`, `plant_medicine`, `fishing`, `ceremonial_language`) |
| `languages_spoken` | Text[] | Other languages spoken (supports multilingual context documentation) |
| `is_active` | Boolean | Whether speaker is actively contributing; set false with respect when speaker steps back |

### 3.3 Speaker Profile Documentation Protocol

**Step 1 — Consultation:** Speak with the person before creating their profile. Obtain consent for `is_two_spirit`, `photo_url`, and biographical details.

**Step 2 — Clan Assignment:** Verify clan affiliation with elder or clan keeper.

**Step 3 — Generational Placement:** Confirm `generation` and `parent_speaker_id` with family tree knowledge.

**Step 4 — Authority Level:** Assign `cultural_authority` reflecting actual teaching authority, not affection or respect alone.

**Step 5 — Voice Documentation:** Conduct a brief interview about how the speaker perceives their own voice as a teaching instrument.

**Step 6 — Teaching Domains:** List domains exhaustively; decades of knowledge often span many domains.

**Step 7 — Review:** For Sharente and elder profiles, obtain reciprocal review before marking complete.

### 3.4 Seed Family Reference Structure

The platform seeds the founding family:

```
Grandmother Comus (elder, grandmother, elder_keeper)
├── Mother (middle, parent, family_teacher)
│   ├── Older Sibling (younger, sibling)
│   └── Younger Sibling (younger, sibling)
├── Father (middle, parent, family_teacher) [linked to Grandfather lineage]
└── Sharente (middle, sharente, sharente_keeper)

Grandfather (elder, grandfather, elder_keeper)
Clan Members: Auntie, Uncle
```

Extend this structure with additional clan members as profiles are completed.

---

## 4. Lexical Entry Documentation

Lexical entries are the **core linguistic units** of Kuttiomp. The Lexicon Editor (`/lexicon/editor`) organizes input across four tabs: **Core**, **Linguistic**, **Cultural**, and **Governance**.

### 4.1 Core Tab Fields

| Field | Required | Description |
|-------|----------|-------------|
| `word_narragansett` † | Yes | Headword in primary community orthography |
| `english_gloss` † | Yes | Brief translation; not encyclopedic |
| `english_gloss_extended` ‡ | No | Full definitional explanation for scholars and advanced learners |
| `category` † | Yes | Grammatical/functional category (see enum below) |
| `semantic_domain` ‡ | Yes | Thematic domain (flora, fauna, kinship, etc.) |

**Lexical Categories:** `noun`, `verb`, `adjective`, `adverb`, `pronoun`, `particle`, `interjection`, `phrase`, `proverb`, `prayer`, `ceremonial`, `place_name`, `personal_name`, `kinship_term`, `natural_world`, `numeral`, `classifier`, `incorporative`, `other`.

**Semantic Domains:** `flora`, `fauna`, `weather`, `water`, `geography`, `kinship`, `ceremony`, `tools`, `food`, `medicine`, `spiritual`, `governance`, `emotion`, `movement`, `time`, `color`, `other`.

`word_normalized` is auto-generated (lowercase, trimmed) for search indexing.

### 4.2 Linguistic Tab Fields

#### 4.2.1 Phonemic and IPA Documentation

| Field | Description | Example |
|-------|-------------|---------|
| `phonemic_transcription` | Phonemic-level representation using community-agreed phoneme inventory | /wʌnɛɡan/ (illustrative) |
| `ipa_transcription` | Narrow or broad IPA as appropriate | [wʌnɛɡan] |
| `alternate_spellings` | Legacy array field; prefer `spelling_variants` table for new entries | ["Wunnegan", "Wúnnegan"] |

**PhD-Level Guidance:** Document the phonemic inventory assumptions in `usage_notes` when first establishing transcription conventions for a batch of entries. Distinguish phonemic (/slashes/) from phonetic ([brackets]) transcription consistently. If multiple elders use different phonemic analyses, create speaker-attributed `pronunciation_variants` rather than overwriting.

#### 4.2.2 Morphological Analysis

| Field | Description |
|-------|-------------|
| `morphological_breakdown` | Morpheme-by-morpheme segmentation |
| `morpheme_gloss` | Gloss for each morpheme (e.g., `wunne-` + `-gan` with meanings) |

**Example:**
```
morphological_breakdown: wunne + -gan
morpheme_gloss: greeting stem + verbal/nominalizing suffix (provisional)
```

Document analytical uncertainty explicitly. Provisional analyses are valuable if marked as such.

#### 4.2.3 Etymology

| Field | Description |
|-------|-------------|
| `etymology_notes` ‡ | Narrative etymology including cognates, historical sources, oral tradition |
| `etymology_source` | Citation for etymological claims (Costa, Goddard, elder oral testimony) |

**Cultural Respect Note:** Distinguish **oral etymology** (taught by elders, spiritually significant) from **comparative historical linguistics** (academic). Both belong in `etymology_notes` but should be labeled by source type. Never present speculative academic etymology as elder testimony.

#### 4.2.4 Usage and Register

| Field | Description |
|-------|-------------|
| `usage_notes` | Collocations, restrictions, common errors by learners |
| `register` | `formal`, `informal`, `ceremonial`, `intimate`, `archaic`, etc. |

### 4.3 Cultural Tab Fields

| Field | Description |
|-------|-------------|
| `cultural_context_summary` ‡‡ | **Most important cultural field.** When, how, and why the word is used |
| `ecological_connection` ‡ | Relationship to land, plants, animals, seasons (Protocol 11) |
| `spiritual_significance` | `none`, `respectful`, `ceremonial`, `sacred`, `restricted` |
| `seasonal_usage` | Array: `spring`, `summer`, `fall`, `winter`, `year_round`, `ceremonial_season`, `harvest`, `planting` |

`cultural_domain_id` links to hierarchical `cultural_domains` (e.g., Wunneganash — Greetings & Respect).

### 4.4 Governance Tab Fields

| Field | Description |
|-------|-------------|
| `visibility` | `public`, `clan`, `family`, `elders_only`, `sacred` (default: `clan`) |
| `is_sacred` | Boolean; triggers elder review (Protocol 4) |
| `is_archaic` | Word no longer in active use but historically important |
| `is_neologism` | Newly coined or revived word; document coinage in `etymology_notes` |
| `primary_speaker_id` ‡ | Speaker who taught or authorized the entry |
| `primary_orthography_id` | Reference to preferred `orthographies` record |
| `approval_status` | System-managed through workflow |

### 4.5 Example Sentences

Create `example_sentences` records for each lexical entry where possible:

| Field | Description |
|-------|-------------|
| `sentence_narragansett` † | Full example sentence |
| `sentence_english` † | English translation |
| `literal_gloss` | Word-for-word gloss for pedagogical use |
| `cultural_context` | Situational context for the example |
| `speaker_id` | Speaker who provided or verified the example |
| `audio_recording_id` | Linked audio of example sentence |

### 4.6 Pronunciation Variants

For each speaker who pronounces the word:

| Field | Description |
|-------|-------------|
| `speaker_id` † | Attributed speaker |
| `variant_spelling` | Orthographic representation of variant pronunciation |
| `phonemic_variant` | Phonemic transcription of variant |
| `ipa_variant` | IPA of variant |
| `dialect_notes` | Explanation of regional, generational, or clan variation |
| `is_preferred` | Pedagogical default for specific pathway |
| `notes` | Additional commentary |

### 4.7 Lexical Entry Completion Checklist

- [ ] Headword in community orthography
- [ ] Brief and extended gloss
- [ ] Category and semantic domain
- [ ] Phonemic/IPA transcription
- [ ] Morphological breakdown (if analyzable)
- [ ] Etymology with sources
- [ ] Cultural context summary (minimum 3 sentences)
- [ ] Ecological connection (if applicable)
- [ ] Seasonal usage tags
- [ ] Spiritual significance classification
- [ ] Primary speaker attribution
- [ ] Spelling variants across orthographies
- [ ] At least one pronunciation variant with audio
- [ ] At least one example sentence
- [ ] Visibility and sacred classification
- [ ] Land site link (if place-related)
- [ ] Cultural context record(s) in `cultural_contexts`
- [ ] Narrative link (if word appears in story)

---

## 5. Cultural Context System

The `cultural_contexts` table provides **rich narrative documentation** beyond the summary field on lexical entries. Each record is a standalone cultural essay linkable to a word.

### 5.1 Context Types

| `context_type` | Label | Use |
|----------------|-------|-----|
| `mother_earth` | Mother Earth Connection | Land reciprocity, ecological relationship, place acknowledgment |
| `ceremony` | Ceremony | Ceremonial usage; often restricted visibility |
| `traditional_ecological_knowledge` | TEK | Gathering, medicine, seasonal ecology |
| `kinship` | Kinship | Family and clan relational terminology |
| `seasonal_cycle` | Seasonal Cycle | Seasonal activities linked to vocabulary |
| `spiritual_significance` | Spiritual Significance | Spiritual meaning without full sacred classification |
| `historical` | Historical Context | Colonial history, language loss, revitalization |
| `contemporary_usage` | Contemporary Usage | Modern contexts, neologisms, urban usage |

### 5.2 Field Documentation

| Field | Description |
|-------|-------------|
| `lexical_entry_id` | Link to word (nullable for standalone contexts) |
| `title` † | Short descriptive title |
| `narrative` † | Full cultural narrative (no arbitrary length limit; write comprehensively) |
| `mother_earth_connection` | Specific Mother Earth / land reciprocity notes |
| `ceremonial_notes` | Ceremonial context (restrict visibility when needed) |
| `tek_notes` | Traditional Ecological Knowledge details |
| `seasonal_usage` | Free-text seasonal narrative |
| `spiritual_significance` | Free-text spiritual narrative |
| `speaker_id` ‡ | Knowledge Keeper who provided the context |
| `visibility` | Default `clan` |
| `approval_status` | Workflow status |

### 5.3 Mother Earth Documentation Framework

When `context_type: mother_earth`, structure `narrative` to address:

1. **Relational acknowledgment** — How the word acknowledges land, water, or non-human relatives
2. **Seasonal reciprocity** — What gifts are received and what obligations are practiced
3. **Gathering or stewardship ethics** — Protocols for sustainable use
4. **Place connection** — Link to `land_knowledge_sites` where applicable

### 5.4 Ceremony Documentation Framework

When `context_type: ceremony`:

1. Set `visibility` to `elders_only` or `sacred` as appropriate
2. Document *that* the word is ceremonial without exposing restricted content in `narrative` if not authorized
3. Use `ceremonial_notes` for authorized detail
4. Route to `requires_elder_review`

### 5.5 TEK Documentation Framework

When `context_type: traditional_ecological_knowledge`:

1. Cross-reference `ecological_connection` on the lexical entry
2. Document species identification, habitat, harvest timing in `tek_notes`
3. Link to land sites where species or features occur
4. Note any restricted medicine knowledge with appropriate visibility

---

## 6. Audio Recording Protocols

Audio is the **pedagogical heart** of Kuttiomp. The Audio Studio (`/audio`) implements Protocol 1 at the UI level.

### 6.1 Pre-Recording Checklist

- [ ] Correct `speaker_id` selected
- [ ] Recording environment assessed (minimize noise; honor context)
- [ ] Elder authorization obtained for ceremonial content
- [ ] Lexical entry exists or will be created immediately after
- [ ] `recorded_by` identified if operator ≠ speaker

### 6.2 Recording Fields

| Field | Required | Description |
|-------|----------|-------------|
| `speaker_id` † | Yes | Whose voice is recorded |
| `recorded_by` ‡ | Conditional | Who operated recorder, if different from speaker |
| `lexical_entry_id` | No | Link to word being pronounced |
| `storage_path` | System | Supabase storage path (auto) |
| `storage_bucket` | System | Default `kuttiomp-audio` |
| `file_format` | System | `webm`, `wav`, `mpeg`, `ogg` |
| `duration_seconds` | System | Auto-calculated |
| `sample_rate` | No | e.g., 48000 Hz |
| `bit_depth` | No | e.g., 16, 24 |
| `channels` | No | Default 1 (mono recommended for voice) |
| `quality` † | Yes | See quality enum below |
| `signal_to_noise` | No | SNR metric if analyzed |
| `recording_context` ‡ | No | Narrative context string |
| `context_tags` ‡ | No | Structured tags (see below) |
| `location_description` | No | Where recorded (if appropriate to share) |
| `land_site_id` | No | Geographic anchor (Protocol 11) |
| `visibility` | Yes | Default `clan` |
| `is_primary_recording` | No | Mark elder authoritative pronunciation |
| `transcript` | No | Optional written transcript |
| `waveform_data` | System | Visual waveform (JSONB) |
| `notes` | No | Additional metadata |
| `approval_status` | System | Workflow-managed |

**Audio Quality Values:**

| Value | Use |
|-------|-----|
| `archival` | Historical or digitized legacy recordings |
| `studio` | Controlled environment, high fidelity |
| `field` | Outdoor or home recording; default for most sessions |
| `practice` | Younger learner practice; not authoritative reference |
| `live_ceremony` | Ceremonial context; restricted; elder authorization required |

**Context Tags (Audio Studio):** `formal_lesson`, `kitchen_conversation`, `outdoor_teaching`, `practice_session`, `storytelling`, `ceremony_prep`, `elders_council`.

### 6.3 Quality Metadata Standards

For PhD-level documentation, record when known:

- **Sample rate:** Minimum 44.1 kHz for new studio recordings; preserve original rate for archival
- **Bit depth:** 16-bit minimum; 24-bit for archival masters
- **SNR:** Document if signal processing applied
- **Microphone type:** Note in `notes` if relevant to phonetic research

### 6.4 Recording Session Protocol

**Session 1 — Elder Reference Recordings:**
Record Grandmother Comus and Grandfather pronouncing core vocabulary with `quality: studio` or `field`, `is_primary_recording: true`.

**Session 2 — Sharente Kinship and Bridge Terms:**
Record Sharente with `context_tags: formal_lesson`, linking to kinship entries.

**Session 3 — Domain-Specific Family Sessions:**
Kitchen (food), outdoor (land/weather), water (fishing) sessions with appropriate tags.

**Session 4 — Narrative and Storytelling:**
Longer `storytelling` tagged recordings linked to `cultural_narratives`.

**Session 5 — Practice Archive:**
Younger generation `practice_session` recordings, explicitly `quality: practice`.

### 6.5 Approval and Attribution

Upon upload, recordings enter `pending` status. Sacred or ceremonial recordings auto-route to `requires_elder_review`. Speakers may request deletion at any time; family steward executes removal with `audit_log` entry.

---

## 7. Land-Based Knowledge

Land documentation implements Protocol 11 through PostGIS-enabled geographic data.

### 7.1 Land Knowledge Sites

| Field | Required | Description |
|-------|----------|-------------|
| `name_narragansett` † | Yes | Place name in Narragansett |
| `name_english` | No | English place name |
| `description` ‡ | No | Comprehensive place description |
| `site_type` † | Yes | `general`, `river`, `coastal`, `forest`, `gathering_site`, `ceremonial_site`, `village_site`, `mountain`, etc. |
| `location` † | Yes | PostGIS `GEOGRAPHY(POINT, 4326)` — latitude/longitude |
| `elevation_meters` | No | Elevation above sea level |
| `ecological_zone` | No | Ecoregion, watershed, biome |
| `cultural_significance` ‡ | No | Why this place matters culturally |
| `seasonal_relevance` | No | When the place is significant (gathering season, ceremony) |
| `tek_description` ‡ | No | Traditional Ecological Knowledge specific to site |
| `speaker_id` ‡ | No | Keeper who provided site knowledge |
| `visibility` | Yes | Default `clan`; gathering and ceremonial sites often restricted |
| `approval_status` | System | Workflow-managed |

**Coordinates:** Use WGS84 (EPSG:4326). Document coordinate source (GPS visit, map research, elder sketch) in `description`.

### 7.2 Linking Words to Places

The `lexical_land_links` table connects lexical entries to sites:

| Field | Description |
|-------|-------------|
| `lexical_entry_id` † | Word reference |
| `land_site_id` † | Site reference |
| `relationship_type` | `found_at`, `named_for`, `gathered_at`, `ceremonial_use`, `historical_event`, etc. |
| `notes` | Explanation of relationship |

**Documentation Practice:** Every `place_name` category entry should have at least one `lexical_land_link`. Flora and fauna entries should link to gathering or habitat sites when TEK permits sharing.

### 7.3 Audio and Narrative Land Anchoring

- Set `audio_recordings.land_site_id` when recording on site
- Set `cultural_narratives.land_site_id` when story is place-specific
- Cross-reference `ecological_connection` on linked lexical entries

### 7.4 Visibility Considerations for Land Data

Restricted gathering sites and ceremonial landscapes must not be `visibility: public`. When in doubt, use `clan` or `family`. Geographic coordinates of sensitive sites may require deliberate imprecision—document actual practice in `submission_notes` rather than exposing precise coordinates against keeper wishes.

---

## 8. Cultural Narratives & Story Linking

The `cultural_narratives` table (formerly `stories`) preserves oral tradition with full attribution and linking infrastructure.

### 8.1 Narrative Fields

| Field | Description |
|-------|-------------|
| `title_english` † | English title |
| `title_narragansett` | Narragansett title |
| `narrative_english` | English narrative text |
| `narrative_narragansett` ‡ | Full Narragansett text when authorized |
| `narrative_type` | `teaching`, `creation`, `historical`, `humor`, `cautionary`, `seasonal`, etc. |
| `narrator_id` ‡ | Speaker who tells the story |
| `seasonal_context` | When story is traditionally told |
| `land_site_id` | Geographic anchor |
| `linked_lexical_entries` | UUID array of related words |
| `visibility` | Default `family` for stories |
| `is_sacred` | Boolean |
| `approval_status` | Stories default `requires_elder_review` |

### 8.2 Lexical-Narrative Links

The `lexical_narrative_links` table provides typed relationships:

| Field | Description |
|-------|-------------|
| `lexical_entry_id` | Word appearing in or related to narrative |
| `narrative_id` | Story reference |
| `relationship_type` | `appears_in`, `key_term`, `moral_teaching`, `place_name_in`, etc. |
| `notes` | Context of word within narrative |

### 8.3 Story Documentation Protocol

1. **Obtain narrator consent** and document `narrator_id`
2. **Record audio** of narrative with `storytelling` context tag before or during text entry
3. **Identify key lexical items** and create links
4. **Classify sacred content** before any public visibility
5. **Submit for elder review** — default status is `requires_elder_review`
6. **Link to land sites** when story is place-specific
7. **Document seasonal telling** in `seasonal_context`

---

## 9. Knowledge Contribution Workflow

Kuttiomp implements a formal **draft → submit → review → approve** pipeline through `knowledge_contributions`.

### 9.1 Contribution States

| Status | Meaning |
|--------|---------|
| `draft` | Work in progress; not visible to reviewers |
| `pending` | Submitted; awaiting reviewer assignment |
| `under_review` | Reviewer actively examining |
| `requires_elder_review` | Escalated for elder authority (sacred, Sharente, disputed) |
| `approved` | Accepted for publication at designated visibility |
| `rejected` | Returned with `review_notes`; may be revised and resubmitted |
| `archived` | Withdrawn or superseded |

### 9.2 Contribution Types

| `contribution_type` | Entity |
|---------------------|--------|
| `lexical_entry` | Word/phrase |
| `audio_recording` | Voice recording |
| `pronunciation_variant` | Speaker pronunciation |
| `cultural_narrative` | Story |
| `land_knowledge` | Land site |
| `example_sentence` | Usage example |
| `orthography_note` | Orthographic documentation |

### 9.3 Submission Process

**Step 1 — Create Content:** Use Lexicon Editor, Audio Studio, or API to create entity in `draft` or `pending` status.

**Step 2 — Protocol Acknowledgment:** Navigate to `/contributions`. Acknowledge all **Twelve Cultural Governance Protocols** via checkbox UI. All twelve must be checked before submission is culturally valid.

**Step 3 — Create Contribution Record:**
```
contributor_speaker_id: [your speaker UUID]
contribution_type: lexical_entry
entity_id: [created entity UUID]
entity_type: lexical_entries
submission_notes: "Taught by Grandmother Comus, kitchen conversation, June 2026"
protocol_acknowledgments: [1,2,3,4,5,6,7,8,9,10,11,12]
status: draft
```

**Step 4 — Submit for Review:** Transition status from `draft` to `pending`.

**Step 5 — Review:** Authorized reviewer (elder, Sharente, clan teacher) examines content, sets `reviewed_by`, `reviewed_at`, `review_notes`, and final `status`.

**Step 6 — Publication:** Upon `approved`, entity `approval_status` synchronizes and content becomes available at its `visibility` level.

### 9.4 Review Authority Matrix

| Content Type | Primary Reviewer | Escalation |
|--------------|------------------|------------|
| Public greetings | Family teacher | Elder (optional) |
| Kinship terms | Sharente | Elder |
| Ceremonial/sacred | Elder council | Required |
| Land sites (restricted) | Elder + domain keeper | Required |
| Sharente-attributed | Sharente | Elder |
| Neologisms | Sharente + Elder | As needed |
| Practice audio | Family teacher | No escalation |

### 9.5 Audit Trail

All state transitions log to `audit_log` with `actor_speaker_id`, `previous_values`, `new_values`, and optional `cultural_notes`. Disputes reference audit records but resolve through family protocol, not automated adjudication.

---

## 10. Orthographic Systems

Kuttiomp preserves **six orthography systems** in parallel (Protocol 12).

### 10.1 Orthography Registry

| `system_key` | Name | Primary? | Description |
|--------------|------|----------|-------------|
| `costa_transcription` | Costa Transcription | No | Historical system from early Narragansett documentation |
| `jopson_modern` | Jopson Modern Orthography | **Yes** | Contemporary community-preferred conventions |
| `ipa` | International Phonetic Alphabet | No | Phonetic transcription for linguistic analysis |
| `historical_manuscript` | Historical Manuscript | No | Spellings from historical documents |
| `community_preferred` | Community Preferred | **Yes** | Keeper-determined preferred spellings |
| `learner_phonetic` | Learner Phonetic | No | Simplified phonetic guide for learners |

### 10.2 Spelling Variants

For each lexical entry, create `spelling_variants`:

| Field | Description |
|-------|-------------|
| `orthography_id` † | Reference to orthography system |
| `spelling` † | Spelling in that system |
| `speaker_id` | Speaker who uses this form |
| `notes` | Context (historical source, dialect, learner simplification) |
| `is_preferred` | Preferred within that orthography system |

### 10.3 Orthographic Decision Protocol

1. **Community Preferred** takes display precedence in learner UI
2. **Costa** preserved for historical comparison and academic citation
3. **IPA** added when phonetic clarity needed; does not override audio
4. **Learner Phonetic** may simplify for pedagogy but must note simplification in `notes`
5. **Disputes** documented via `orthography_note` contributions, reviewed by Sharente and elders

### 10.4 Character Inventory

Document accepted characters and diacritics in `orthographies.character_inventory` when establishing conventions. Note Narragansett-specific characters (e.g., `8` for schwa-like vowels in some systems) explicitly.

---

## 11. Data Entry Sequencing Guide

When inputting **decades of knowledge**, follow this recommended sequence to build relational integrity and avoid orphaned records.

### Phase 1: Foundation (Week 1–2)

1. Verify clan record (`Kuttiomp Clan` or additional clans)
2. Complete all speaker profiles with full voice and authority documentation
3. Verify generational tree (`parent_speaker_id` linkages)
4. Acknowledge Protocol v2.0 in contribution workflow

### Phase 2: Orthographic and Domain Framework (Week 2–3)

5. Confirm orthography registry and document character inventory decisions
6. Create/verify `cultural_domains` hierarchy (greetings, kinship, natural world, ceremony)
7. Establish phonemic transcription conventions in a reference `orthography_note`

### Phase 3: Core Vocabulary with Elder Voice (Week 3–8)

8. Enter greeting and respect terms (`visibility: public` where approved)
9. Record Grandmother Comus and Grandfather primary audio for each greeting
10. Enter kinship terms with Sharente attribution and review
11. Record Sharente audio for kinship terms
12. Create `cultural_contexts` for Mother Earth and kinship types

### Phase 4: Natural World and TEK (Week 8–16)

13. Create `land_knowledge_sites` for known places
14. Enter flora, fauna, water, weather vocabulary by domain
15. Complete `ecological_connection` and `tek_notes` for each
16. Link words to land sites
17. Record domain-appropriate family audio (Father: outdoor; Uncle: water)

### Phase 5: Daily Life and Movement (Week 16–24)

18. Food, tools, household, emotion vocabulary
19. Example sentences from kitchen and daily conversation recordings
20. Parent and sibling practice recordings (`quality: practice`)

### Phase 6: Narratives and Seasonal Knowledge (Week 24–36)

21. Enter cultural narratives with narrator attribution
22. Link narratives to lexical entries and land sites
23. Document seasonal vocabulary with `seasonal_usage` arrays
24. Record storytelling audio

### Phase 7: Ceremonial and Restricted (Ongoing, Elder-Gated)

25. Enter ceremonial vocabulary only with explicit elder authorization
26. Classify sacred content; route all to `requires_elder_review`
27. **Never batch-enter sacred content without per-item review**

### Phase 8: Scholarly Enrichment (Ongoing)

28. Add IPA, morphological analysis, etymology with sources
29. Add Costa and historical manuscript spelling variants
30. Cross-reference academic sources in `etymology_source`
31. Review and approve backlog in `/approvals`

### Phase 9: Quality Audit (Quarterly)

32. Verify every public entry has audio
33. Verify every kinship term has Sharente review
34. Verify every place name has land link
35. Run elder council review of sacred classifications

---

## 12. Field-by-Field Reference Tables

### 12.1 Speakers — Complete Table

| Field | Type | Enum/Format | Default | Protocol |
|-------|------|-------------|---------|----------|
| `id` | UUID | auto | — | — |
| `clerk_user_id` | TEXT | — | null | — |
| `display_name` | TEXT | — | required | 1 |
| `name_narragansett` | TEXT | — | null | 12 |
| `role` | ENUM | speaker_role | required | 2, 3 |
| `generation` | ENUM | generation_tier | `middle` | 2 |
| `gender_expression` | ENUM | gender_expression | `not_specified` | 3 |
| `cultural_authority` | ENUM | cultural_authority_level | `family_teacher` | 2, 3 |
| `clan_id` | UUID | FK clans | null | 5 |
| `parent_speaker_id` | UUID | FK speakers | null | 2 |
| `biography` | TEXT | — | null | 1 |
| `cultural_title` | TEXT | — | null | — |
| `is_two_spirit` | BOOL | — | false | 3 |
| `is_elder` | BOOL | — | false | 2, 4 |
| `is_active` | BOOL | — | true | — |
| `birth_year` | INT | — | null | — |
| `photo_url` | TEXT | URL | null | 1 |
| `voice_description` | TEXT | — | null | 1, 8 |
| `voice_pitch_range` | TEXT | — | null | 8 |
| `voice_tempo` | TEXT | — | null | 8 |
| `voice_quality_notes` | TEXT | — | null | 8 |
| `teaching_domains` | TEXT[] | — | `{}` | — |
| `languages_spoken` | TEXT[] | — | `{}` | — |

### 12.2 Lexical Entries — Complete Table

| Field | Type | Enum/Format | Default | Protocol |
|-------|------|-------------|---------|----------|
| `word_narragansett` | TEXT | — | required | 12 |
| `word_normalized` | TEXT | auto | — | — |
| `english_gloss` | TEXT | — | required | — |
| `english_gloss_extended` | TEXT | — | null | — |
| `alternate_spellings` | TEXT[] | — | `{}` | 12 |
| `phonemic_transcription` | TEXT | /phonemes/ | null | 8, 12 |
| `ipa_transcription` | TEXT | [IPA] | null | 8, 12 |
| `morphological_breakdown` | TEXT | — | null | — |
| `morpheme_gloss` | TEXT | — | null | — |
| `etymology_notes` | TEXT | — | null | — |
| `etymology_source` | TEXT | citation | null | 9 |
| `usage_notes` | TEXT | — | null | — |
| `register` | TEXT | — | null | — |
| `category` | ENUM | lexical_category | `other` | — |
| `semantic_domain` | ENUM | semantic_domain | `other` | 11 |
| `cultural_domain_id` | UUID | FK | null | 5 |
| `ecological_connection` | TEXT | — | null | 11 |
| `seasonal_usage` | ENUM[] | seasonal_usage | `{}` | 11 |
| `spiritual_significance` | ENUM | spiritual_significance | `none` | 4 |
| `cultural_context_summary` | TEXT | — | null | — |
| `visibility` | ENUM | content_visibility | `clan` | 4, 5 |
| `is_sacred` | BOOL | — | false | 4 |
| `is_archaic` | BOOL | — | false | — |
| `is_neologism` | BOOL | — | false | 3 |
| `primary_speaker_id` | UUID | FK speakers | null | 1 |
| `primary_orthography_id` | UUID | FK orthographies | null | 12 |
| `approval_status` | ENUM | approval_status | `pending` | 7 |

### 12.3 Audio Recordings — Complete Table

| Field | Type | Default | Protocol |
|-------|------|---------|----------|
| `speaker_id` | UUID | required | 1 |
| `recorded_by` | UUID | null | 1 |
| `lexical_entry_id` | UUID | null | 1 |
| `quality` | ENUM | `field` | 2 |
| `recording_context` | TEXT | null | 7 |
| `context_tags` | TEXT[] | `{}` | 7 |
| `location_description` | TEXT | null | 11 |
| `land_site_id` | UUID | null | 11 |
| `visibility` | ENUM | `clan` | 4, 5 |
| `is_primary_recording` | BOOL | false | 2 |
| `transcript` | TEXT | null | 12 |
| `signal_to_noise` | NUMERIC | null | — |
| `sample_rate` | INT | null | — |
| `bit_depth` | INT | null | — |
| `channels` | INT | 1 | — |
| `approval_status` | ENUM | `pending` | 7 |

### 12.4 Knowledge Contributions — Complete Table

| Field | Type | Description |
|-------|------|-------------|
| `contributor_speaker_id` | UUID | Who is submitting |
| `contribution_type` | ENUM | Type of knowledge |
| `entity_id` | UUID | ID of created entity |
| `entity_type` | TEXT | Table name |
| `submission_notes` | TEXT | Provenance narrative |
| `status` | ENUM | Workflow state |
| `reviewed_by` | UUID | Reviewer speaker |
| `reviewed_at` | TIMESTAMPTZ | Review timestamp |
| `review_notes` | TEXT | Reviewer commentary |
| `protocol_acknowledgments` | INT[] | Array of protocol IDs acknowledged |

---

## 13. Sacred Content Classification Guide

### 13.1 Definitional Framework

**Sacred content** is knowledge whose transmission is governed by ceremonial protocol, clan restriction, or spiritual significance that makes public educational exposure inappropriate or harmful. Kuttiomp treats sacred content as a distinct epistemic category—not merely "private" but **ceremonially bounded**.

### 13.2 Classification Criteria

| Criterion | Classification | Action |
|-----------|----------------|--------|
| Ceremonial prayer or invocation | `is_sacred: true`, `visibility: sacred` | Elder council review required |
| Initiation-specific language | `is_sacred: true`, `visibility: elders_only` | Elder council review required |
| Ceremonial medicine knowledge | `spiritual_significance: restricted` | Sharente + elder review |
| Restricted clan teachings | `visibility: clan` or `family` | Clan keeper review |
| Respectful spiritual reference (non-restricted) | `spiritual_significance: respectful` | Standard review |
| Seasonal ceremony vocabulary (partially shareable) | `spiritual_significance: ceremonial` | Elder review |
| General respect terms | `spiritual_significance: none` | Standard review |

### 13.3 Decision Flowchart (Textual)

1. **Is this knowledge taught in ceremony to initiated persons only?** → Sacred
2. **Is this medicine knowledge with gathering/processing restrictions?** → Restricted
3. **Is this a clan teaching not for external sharing?** → Clan visibility
4. **Is this a greeting or general teaching safe for learners?** → Public (with elder approval)
5. **Uncertain?** → `requires_elder_review` + `visibility: elders_only`

### 13.4 Technical Enforcement

When `is_sacred: true` OR `visibility: sacred`:

- `approval_status` set to `requires_elder_review`
- Excluded from public API SELECT policies
- Excluded from AI context in `apps/api/app/services/grok.py`
- Not search-indexed for public learners
- Audit log tracks all access attempts

### 13.5 What Never Enters the Platform

Even elders should consider whether some knowledge should remain **entirely oral and off-platform**. Kuttiomp supports restriction; it cannot replicate in-person ceremonial transmission. Consult Grandmother Comus, Grandfather, and Sharente when knowledge may be too sacred for any digital record.

---

## 14. Quality Standards for PhD-Level Documentation

### 14.1 Lexicographic Rigor

1. **Gloss precision:** Brief gloss is translatable equivalent; extended gloss is definitional with semantic range
2. **Morphological honesty:** Mark provisional analyses; revise when better information emerges
3. **Etymology sourcing:** Every claim has `etymology_source`; oral and academic sources distinguished
4. **Register documentation:** Note formality, taboo, age-appropriateness
5. **Cross-referencing:** Link synonyms, antonyms, and related entries in `usage_notes`

### 14.2 Phonetic Documentation Standards

1. IPA follows consistent broad/narrow convention documented in project reference
2. Phonemic transcription uses agreed inventory
3. Every IPA entry should have speaker-attributed audio within 30 days
4. Pronunciation variants document generational and clan differences without hierarchy of correctness

### 14.3 Cultural Documentation Standards

1. `cultural_context_summary` minimum 50 words for any non-trivial entry
2. At least one `cultural_contexts` narrative record for kinship, ceremony, TEK, and spiritual domains
3. Mother Earth connections documented for natural world vocabulary
4. Seasonal usage arrays populated for seasonal vocabulary

### 14.4 Provenance Standards

1. Every entry has `primary_speaker_id`
2. Every contribution has `submission_notes` with date, context, and teacher identification
3. Archival retranscriptions document source recording and digitization date
4. Neologisms document coinage author and community acceptance status

### 14.5 Consistency Review

Quarterly review by Sharente and one elder:

- Orthographic consistency across domains
- Visibility classification audit
- Audio coverage percentage by domain
- Orphan records (entries without speaker, audio, or context)

### 14.6 Academic Citation Format

When citing Kuttiomp entries externally (with authorization):

> *Wunnegan* (greeting). Narragansett Lexical Entry. Kuttiomp Language Revitalization Platform. Primary Speaker: Grandmother Comus (Mush8n8m8s). Contributor: [Name]. Approved [Date]. Visibility: Public. Protocol Version 2.0.

---

## 15. Appendix: Sample Completed Entries

### 15.1 Sample 1: Wunnegan (Public Greeting)

**Lexical Entry:**
```
word_narragansett: Wunnegan
english_gloss: Greeting / Good day
english_gloss_extended: A traditional greeting acknowledging presence and mutual respect. Among the first terms taught to new learners. Used when meeting someone or entering a shared space. Carries connotation of peace and goodwill.
category: phrase
semantic_domain: governance
cultural_context_summary: Wunnegan is spoken upon meeting another person or entering a shared space. It acknowledges both the person and the land beneath your feet. Grandmother Comus teaches that a greeting is not hurried — the speaker offers presence before words.
ecological_connection: The greeting connects speaker to place — you do not greet only the person, but the earth that holds you both.
spiritual_significance: respectful
seasonal_usage: [year_round]
visibility: public
is_sacred: false
primary_speaker_id: [Grandmother Comus UUID]
approval_status: approved
```

**Spelling Variants:**
| Orthography | Spelling |
|-------------|----------|
| jopson_modern | Wunnegan |
| costa_transcription | (historical form documented) |
| ipa | /wʌnɛɡan/ (illustrative) |
| learner_phonetic | Wuh-NEH-gahn |

**Cultural Context Record:**
```
context_type: mother_earth
title: Greeting the Day
narrative: Wunnegan is spoken upon meeting another person or entering a shared space. It acknowledges both the person and the land beneath your feet. The greeting connects speaker to place — you do not greet only the person, but the earth that holds you both.
mother_earth_connection: The greeting connects speaker to place — you do not greet only the person, but the earth that holds you both.
speaker_id: [Grandmother Comus UUID]
visibility: public
approval_status: approved
```

**Audio Recording:**
```
speaker_id: [Grandmother Comus UUID]
quality: field
recording_context: Formal lesson with grandchildren, June 2026
context_tags: [formal_lesson]
is_primary_recording: true
visibility: public
approval_status: approved
```

---

### 15.2 Sample 2: Sharente (Kinship Term — Sharente Stewarded)

**Lexical Entry:**
```
word_narragansett: Sharente
english_gloss: Two-Spirit person
english_gloss_extended: Honors the sacred Two-Spirit role in Narragansett culture. A kinship and identity term used with deep respect to acknowledge those who carry Two-Spirit responsibilities including linguistic stewardship, kinship bridge teaching, and cultural translation between traditional and contemporary worlds.
category: kinship_term
semantic_domain: kinship
cultural_context_summary: Sharente is used with deep respect to honor those who carry Two-Spirit roles in Narragansett society. This term must never be used dismissively or without cultural understanding. Used in contexts of respect and acknowledgment, not casual reference.
spiritual_significance: respectful
visibility: clan
is_sacred: false
primary_speaker_id: [Sharente UUID]
approval_status: approved
```

**Cultural Context Record:**
```
context_type: kinship
title: Two-Spirit Kinship Honor
narrative: Sharente is used with deep respect to honor those who carry Two-Spirit roles in Narragansett society. This term must never be used dismissively or without cultural understanding. Sharente stewards inclusive kinship terminology and contemporary language evolution within cultural protocol.
ceremonial_notes: Used in contexts of respect and acknowledgment, not casual reference.
speaker_id: [Sharente UUID]
visibility: clan
approval_status: approved
```

**Pronunciation Variant:**
```
speaker_id: [Sharente UUID]
ipa_variant: (speaker-attested IPA)
dialect_notes: Authoritative pronunciation from Two-Spirit Knowledge Keeper
is_preferred: true
```

**Review Path:** Sharente primary review; elder acknowledgment.

---

### 15.3 Sample 3: Kuttiomp (Platform Name Entry)

**Lexical Entry:**
```
word_narragansett: Kuttiomp
english_gloss: Family / Home
english_gloss_extended: Denotes family, home, and the gathering place where language is shared. The platform bears this name to signify that it is not a database but a hearth for language transmission among relatives.
category: noun
semantic_domain: kinship
cultural_context_summary: The name of this platform — representing family, home, and the gathering place for language. Chosen to remind all users that every word entered exists within family relationship, not anonymous archival space.
visibility: public
primary_speaker_id: [Grandmother Comus UUID]
approval_status: approved
```

---

### 15.4 Sample 4: Hypothetical Plant Term with Land and TEK Links

**Lexical Entry (illustrative structure):**
```
word_narragansett: [Plant name]
english_gloss: [English common name]
category: noun
semantic_domain: flora
ecological_connection: Perennial herb found in partial shade along forest edges near [river name]. Harvested in late summer for traditional use. Pollinator plant supporting native bee species.
seasonal_usage: [summer, harvest]
spiritual_significance: respectful
visibility: clan
primary_speaker_id: [Auntie UUID]
```

**Land Link:**
```
land_site_id: [Forest gathering site UUID]
relationship_type: gathered_at
notes: Traditional gathering location; approach from east trail
```

**Cultural Context:**
```
context_type: traditional_ecological_knowledge
title: [Plant] Gathering Protocol
tek_notes: Harvest when leaves are [description]. Leave root stock for regeneration. Thank the plant before taking. Process within same day.
speaker_id: [Auntie UUID]
visibility: clan
```

**Audio:**
```
speaker_id: [Auntie UUID]
context_tags: [outdoor_teaching]
land_site_id: [Forest gathering site UUID]
quality: field
```

---

### 15.5 Sample 5: Sacred Content (Restricted — Structure Only)

**Note:** Sacred entries are not reproduced in full in documentation. Structure only:

```
word_narragansett: [REDACTED]
category: ceremonial
semantic_domain: ceremony
spiritual_significance: sacred
visibility: sacred
is_sacred: true
approval_status: requires_elder_review
cultural_context_summary: [Elder-authorized summary only — no ceremonial content in public docs]
```

**Review:** Grandmother Comus + Grandfather + relevant clan keeper. Never AI-indexed. Never `visibility: public`.

---

## Closing Acknowledgment

*Language is not data. Language is relationship.*

This guide exists to support Sharente, Grandmother Comus, Grandfather, and all Knowledge Keepers in the systematic, respectful, and academically rigorous documentation of Narragansett language as a living inheritance. Every field in Kuttiomp was designed to answer a cultural question—not a technical one. When this guide is silent, ask the elders. When the platform restricts, honor the restriction. When the voice is available, let the voice teach.

**Protocol Version:** 2.0  
**Effective:** 28 June 2026  
**Revisions require authorization from Grandmother Comus, Grandfather, Sharente, and designated family representatives.**

*Wunnegan.*

---

*End of Knowledge Keepers Guide — Version 2.0*