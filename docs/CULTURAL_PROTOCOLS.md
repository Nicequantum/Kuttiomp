# Cultural Protocols

*Governance framework for Kuttiomp content and access*

---

## Purpose

This document establishes the cultural protocols that govern all content within the Kuttiomp platform. These protocols are not technical constraints alone — they reflect the values of Narragansett knowledge transmission and must be upheld by all contributors, developers, and users.

---

## Protocol 1: Speaker Sovereignty

**Every voice belongs to a person.**

- All audio recordings MUST be attributed to a specific speaker
- No anonymous or generic voice recordings are permitted
- The `recorded_by` field must be used when someone other than the speaker operates the recording device
- Speakers may request removal of their recordings at any time
- Deceased speakers' recordings require family authorization for any changes

---

## Protocol 2: Generational Respect

**Knowledge flows through generations, not around them.**

- Elder voices (`generation: elder`) carry primary authority for pronunciation and usage
- Middle generation speakers (`parent`, `sharente`) bridge traditional and contemporary
- Younger generation recordings are marked as `practice` quality unless elder-approved
- Ancestral/archival recordings are preserved but distinguished from living speakers

---

## Protocol 3: Two-Spirit Honor

**Sharente hold a sacred role that must be explicitly honored.**

- The `sharente` speaker role is distinct from all other roles
- Two-Spirit kinship terms receive dedicated stewardship
- Content created by Sharente requires Sharente or elder review before modification by others
- Inclusive language evolution is guided by Sharente authority, not external assumptions
- The `is_two_spirit` flag is applied with the speaker's consent

---

## Protocol 4: Sacred Content Protection

**Ceremonial knowledge is not educational content.**

Content classified as sacred:
- `visibility: sacred` OR `is_sacred: true`
- Automatically receives `approval_status: requires_elder_review`
- Is NEVER exposed through public API endpoints
- Is NEVER included in AI training or generation context
- Is NEVER indexed by search engines (when web-facing components are added)
- Requires explicit elder authorization for any access beyond `elders_only`

### What Constitutes Sacred Content

- Ceremonial prayers and songs
- Initiation or rite-specific language
- Medicine plant knowledge with ceremonial application
- Clan-specific sacred teachings not authorized for broader sharing

**When in doubt, mark content as `requires_elder_review`.**

---

## Protocol 5: Clan Boundaries

**Clan knowledge belongs to the clan.**

- Default visibility for new content: `clan`
- Clan-specific teachings use `visibility: clan` or `visibility: family`
- Cross-clan sharing requires explicit authorization from both clans' keepers
- The primary family clan (`is_primary_family_clan: true`) seeds the initial dataset

---

## Protocol 6: AI Boundaries

**Artificial intelligence assists learners; it does not speak for the people.**

- AI responses are marked as non-authoritative
- AI cannot approve content
- AI cannot access sacred content
- AI interactions are logged in `ai_interactions` for elder review
- AI system prompts enforce cultural protocols (see `apps/api/app/services/grok.py`)
- No AI-generated content is published without human Knowledge Keeper review

---

## Protocol 7: Audit and Accountability

**All changes are traceable.**

- The `audit_log` table records all content modifications
- Actor identity (Clerk user ID and/or speaker ID) is preserved
- Previous and new values are stored for dispute resolution
- Cultural notes can be attached to audit entries for context

---

## Protocol 8: Pronunciation Variation

**Living languages have living variation.**

- Multiple pronunciation variants per word are expected and welcomed
- Each variant is attributed to a specific speaker
- No variant is marked "incorrect" — dialect variation is cultural richness
- Learners are encouraged to learn their teacher's pronunciation first
- IPA transcriptions are supplementary, not authoritative over living voice

---

## Protocol 9: External Sharing

**The platform's existence does not authorize external use of content.**

- Content within Kuttiomp is not automatically licensed for external use
- Researchers must obtain separate authorization from Knowledge Keepers
- Academic citation must name the specific speaker, not "Kuttiomp database"
- Bulk export of content requires elder council approval

---

## Protocol 10: Platform Modifications

**Technology changes require cultural review.**

- Database schema changes affecting cultural content require family review
- New visibility levels or speaker roles require elder consultation
- AI prompt modifications require Sharente and elder review
- No automated content ingestion without speaker attribution

---

## Enforcement

These protocols are enforced through:

1. **Database design** — RLS policies, approval workflows, visibility enums
2. **API logic** — Sacred content filtering, approval requirements
3. **Admin UI** — Speaker attribution requirements, visibility selectors
4. **AI system prompts** — Cultural protocol instructions
5. **Human governance** — Elder approval queue, family oversight

---

## Revision

This document may be revised only with authorization from Knowledge Keepers (Grandmother Comus, Grandfather, Sharente, and designated family representatives).

*Last established: Project founding*