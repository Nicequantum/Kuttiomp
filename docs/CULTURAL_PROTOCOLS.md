# The Twelve Cultural Governance Protocols

*Version 2.0 — Effective 28 June 2026*

---

## Preamble

These twelve protocols govern all content, technology, and human interaction within the Kuttiomp Narragansett Language Revitalization Platform. They are encoded in database schema constraints, API logic, admin UI workflows, and AI system prompts. They are not suggestions — they are the cultural constitution of this platform.

Protocol versions are tracked in the `protocol_versions` table. Modifications require authorization from Knowledge Keepers.

---

## Protocol 1: Speaker Sovereignty

**Principle:** Every voice belongs to a person.

**Requirements:**
- All audio recordings MUST have `speaker_id` (NOT NULL)
- `recorded_by` required when operator ≠ speaker
- Speakers may request removal of their recordings at any time
- Deceased speakers' recordings require family authorization for modification
- No synthetic or AI-generated voices presented as speaker recordings

**Database:** `audio_recordings.speaker_id`, `speakers` table
**UI:** Audio Studio speaker selector (required field)

---

## Protocol 2: Generational Respect

**Principle:** Knowledge flows through generations, not around them.

**Requirements:**
- `generation_tier`: elder → middle → younger → ancestral
- Elder pronunciation variants take precedence in learner display
- Younger generation practice recordings marked `quality: practice`
- Ancestral recordings distinguished from living speakers

**Database:** `speakers.generation`, `audio_recordings.quality`
**UI:** Clan Tree visualization by generation

---

## Protocol 3: Two-Spirit Honor

**Principle:** Sharente hold a sacred role that must be explicitly honored.

**Requirements:**
- Distinct `sharente` speaker role and `gender_expression: two_spirit`
- `cultural_authority: sharente_keeper` for Sharente knowledge
- Sharente or elder review before others modify Sharente content
- Inclusive kinship terms stewarded by Sharente authority
- `is_two_spirit` applied only with speaker consent

**Database:** `speakers.role`, `speakers.gender_expression`, `speakers.cultural_authority`
**UI:** Sharente badge, dedicated review path

---

## Protocol 4: Sacred Content Protection

**Principle:** Ceremonial knowledge is not educational content.

**Requirements:**
- `visibility: sacred` OR `is_sacred: true` triggers `requires_elder_review`
- Sacred content NEVER exposed via public API
- Sacred content NEVER in AI context
- Sacred content NEVER search-indexed
- Requires explicit elder authorization beyond `elders_only`

**Sacred content includes:** ceremonial prayers, initiation language, ceremonial medicine knowledge, restricted clan teachings

**When in doubt:** mark `requires_elder_review`

---

## Protocol 5: Clan Boundaries

**Principle:** Clan knowledge belongs to the clan.

**Requirements:**
- Default visibility: `clan`
- Cross-clan sharing requires both clans' keeper authorization
- `clan_id` on all speakers
- Primary family clan seeds initial dataset

**Database:** `clans`, `speakers.clan_id`, `content_visibility` enum

---

## Protocol 6: AI Boundaries

**Principle:** AI assists learners; it does not speak for the people.

**Requirements:**
- AI responses marked non-authoritative
- AI cannot approve content
- AI cannot access sacred content
- All interactions logged in `ai_interactions`
- Cultural disclaimers on all AI output
- No AI-generated ceremonial content

**Database:** `ai_interactions`, Grok system prompt in `apps/api/app/services/grok.py`

---

## Protocol 7: Audit and Accountability

**Principle:** All changes are traceable.

**Requirements:**
- `audit_log` records all content modifications
- `knowledge_contributions` tracks submission → review → approval
- Actor identity preserved (Clerk user + speaker ID)
- Previous/new values stored for disputes
- Protocol acknowledgments recorded on contributions

**Database:** `audit_log`, `knowledge_contributions`

---

## Protocol 8: Pronunciation Variation

**Principle:** Living languages have living variation.

**Requirements:**
- Multiple variants per word, each speaker-attributed
- No variant marked "incorrect"
- `pronunciation_variants` and `spelling_variants` tables
- Learners directed to their teacher's pronunciation first
- IPA supplementary to living voice, not replacement

**Database:** `pronunciation_variants`, `spelling_variants`

---

## Protocol 9: External Sharing

**Principle:** Platform existence does not authorize external use.

**Requirements:**
- Content not automatically licensed externally
- Researchers require separate Knowledge Keeper authorization
- Academic citation must name specific speaker
- Bulk export requires elder council approval

**Enforcement:** Governance documentation, API access controls

---

## Protocol 10: Platform Modifications

**Principle:** Technology changes require cultural review.

**Requirements:**
- Schema changes affecting cultural content require family review
- New visibility levels or speaker roles require elder consultation
- AI prompt changes require Sharente and elder review
- No automated ingestion without speaker attribution
- Protocol version tracked in `protocol_versions`

---

## Protocol 11: Land Relationship

**Principle:** Language is inseparable from place.

**Requirements:**
- `land_knowledge_sites` with PostGIS `GEOGRAPHY(POINT)` locations
- Lexical entries linkable to land sites via `lexical_land_links`
- `ecological_connection` field on lexical entries
- Audio recordings may reference `land_site_id`
- Cultural narratives may anchor to land sites
- TEK (Traditional Ecological Knowledge) documented in `cultural_contexts.tek_notes`

**Database:** `land_knowledge_sites`, `lexical_land_links`, PostGIS extension
**UI:** Land Knowledge page in admin dashboard

---

## Protocol 12: Orthographic Integrity

**Principle:** Writing systems serve speakers, not the reverse.

**Requirements:**
- Multiple orthography systems supported simultaneously
- `orthographies` table: Costa, Jopson, IPA, community preferred, learner phonetic
- `spelling_variants` per orthography per entry
- No orthography imposed as sole "correct" spelling
- Community preferred orthography flagged `is_primary`
- Speaker-attributed spelling variants preserved

**Database:** `orthographies`, `spelling_variants`
**UI:** Lexicon Editor orthography tab (future), API `/orthographies`

---

## Enforcement Matrix

| Protocol | Database | API | UI | AI |
|----------|----------|-----|----|----|
| 1 Speaker Sovereignty | ✓ | ✓ | ✓ | — |
| 2 Generational Respect | ✓ | ✓ | ✓ | — |
| 3 Two-Spirit Honor | ✓ | ✓ | ✓ | — |
| 4 Sacred Content | ✓ | ✓ | ✓ | ✓ |
| 5 Clan Boundaries | ✓ | ✓ | ✓ | — |
| 6 AI Boundaries | ✓ | ✓ | — | ✓ |
| 7 Audit | ✓ | ✓ | ✓ | — |
| 8 Pronunciation | ✓ | ✓ | ✓ | — |
| 9 External Sharing | — | — | docs | — |
| 10 Platform Mods | ✓ | — | — | ✓ |
| 11 Land Relationship | ✓ | ✓ | ✓ | — |
| 12 Orthographic | ✓ | ✓ | ✓ | — |

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-01 | Initial 10 protocols |
| 2.0 | 2026-06-28 | Added Protocol 11 (Land Relationship), Protocol 12 (Orthographic Integrity) |

*Revisions require authorization from Grandmother Comus, Grandfather, Sharente, and designated family representatives.*