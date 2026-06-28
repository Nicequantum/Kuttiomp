# Contributing to Kuttiomp

Thank you for your interest in supporting Narragansett language revitalization. Contributing to Kuttiomp is not ordinary open-source work — you are touching infrastructure for a **sacred, living language**.

---

## Before You Write Code

1. Read [docs/CULTURAL_PROTOCOLS.md](docs/CULTURAL_PROTOCOLS.md) — all twelve protocols
2. Read [docs/KNOWLEDGE_KEEPERS_GUIDE.md](docs/KNOWLEDGE_KEEPERS_GUIDE.md) — understand what Knowledge Keepers need
3. Understand: **technology serves the language; the language does not serve technology**

---

## Who May Contribute

| Contributor Type | Scope |
|-----------------|-------|
| Narragansett family & tribal members | All areas, especially cultural content |
| Authorized Knowledge Keepers | Content review, cultural accuracy |
| Technical contributors | Code under family direction |

Unauthorized contributors may submit technical improvements but **must not add, modify, or infer cultural/linguistic content**.

---

## Cultural Protocols for Developers

### Protocol 1: Never Remove Speaker Attribution
- `speaker_id` must remain required on audio
- Do not add anonymous or synthetic voice paths

### Protocol 4: Protect Sacred Content
- Do not expose `visibility: sacred` or `is_sacred` via public endpoints
- Do not include sacred content in AI prompts or logs visible to learners

### Protocol 6: AI Boundaries
- AI assists learners only — never authoritative
- Do not auto-approve content
- Preserve cultural disclaimers on all AI output

### Protocol 10: Schema Changes Require Review
- Database migrations affecting cultural tables need family review
- New enums for visibility, roles, or spiritual significance need elder consultation

### Protocol 11: Land Relationship
- PostGIS coordinates for sacred sites may require restricted visibility
- Never expose precise ceremonial site coordinates without authorization

### Protocol 12: Orthographic Integrity
- Do not impose a single "correct" spelling
- Support multiple orthography systems equally

---

## Technical Standards

### TypeScript / Frontend
- Use `@kuttiomp/types` for domain types
- Use `@kuttiomp/validation` (Zod) for form validation
- Use `@kuttiomp/ui` for shared components
- Add loading and empty states for all data views
- Use `ApiError` from `@/lib/api` for error handling

### Python / Backend
- Pydantic v2 models must mirror Zod schemas in `packages/validation`
- Use `KuttiompAPIError` for structured errors
- Document endpoints with FastAPI `summary` and `description`
- Sacred content filtered from public list endpoints by default

### Database
- Apply migrations in order: `001` → `002` → `003`
- Add indexes for new query patterns
- RLS policies must respect visibility enums

### Validation Parity
When adding a field to the lexicon or speaker schema:
1. Add to `packages/types`
2. Add Zod schema in `packages/validation`
3. Add Pydantic model in `apps/api/app/models/`
4. Update Knowledge Keepers Guide field tables

---

## Development Workflow

```bash
# Setup
./setup.sh

# Development
npm run dev

# Typecheck
npm run typecheck

# Before PR
# 1. Test API at /docs
# 2. Test admin flows: lexicon editor, audio studio, approvals
# 3. Verify no secrets in committed files
```

### Branch Naming
```
feat/lexicon-orthography-support
fix/audio-upload-validation
docs/knowledge-keepers-guide
```

### Commit Messages
Use clear, complete sentences:
```
feat: add spelling variant validation to lexicon API
fix: filter sacred content from public lexicon list
docs: update SETUP troubleshooting for PostGIS
```

---

## Pull Request Checklist

- [ ] Read and respected all applicable Cultural Protocols
- [ ] No cultural/linguistic content added without authorization
- [ ] Zod and Pydantic validation aligned
- [ ] Loading/empty/error states for UI changes
- [ ] No secrets committed (`.env` files gitignored)
- [ ] Migration files numbered sequentially
- [ ] API endpoints documented in OpenAPI

---

## What Not to Contribute

- Automated scraping or bulk import of linguistic data
- AI-generated Narragansett content presented as authoritative
- Features that bypass elder approval for sacred content
- Single orthography imposed as "correct"
- External licensing of cultural content

---

## Questions

Technical questions: open a GitHub issue with the `technical` label.

Cultural questions: contact Knowledge Keepers directly — do not resolve cultural questions through code alone.

---

*Language lives in relationship. Code must honor that truth.*

*Wunnegan.*