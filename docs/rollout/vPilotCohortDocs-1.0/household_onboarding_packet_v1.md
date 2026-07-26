# Household Onboarding Packet — v1

**Kuttiomp Pilot Cohort | Printable + voice-narrated PDF-ready**

*This serves our people by ensuring every elder can guide their grandchildren without technical friction for the next quarter-century.*

**Protocols enforced:** 2 (Elder Approval), 7 (Oral Tradition Primacy), 11 (Accessibility), 3 (Generational Tiers)

---

## Before You Begin

- [ ] Household tribal consent signed (Keeper provides form)
- [ ] Device charged; Wi‑Fi available for first sync
- [ ] One adult designated as **Household Observer** (parent, elder, or tribal member)
- [ ] Screenshot consent acknowledged (UI only — no sacred/ceremonial screens)

**QR — Mode selection audio:** Scan to hear onboarding welcome in the app  
`kuttiomp://first-launch?audio=onboardingWelcome`

---

## Step-by-Step (All Households)

### Day 0 — Install & First Launch

1. Install Kuttiomp from tribal distribution channel.
2. Open app → audio-guided onboarding plays automatically (Protocol 7).
3. Select learning path matching household member:
   - **Little Ones** — youngest learners (family iPad)
   - **Young Learner** — youth tablet/phone
   - **Core Adult** — daily tribal member use
   - **Elder** — contribution + Keeper paths
4. Confirm mode persists after closing app (restart test).

### Day 1 — Dashboard & Discovery

1. Open **Dashboard** → review mode petals and progress radial.
2. Tap **Discover Language** → search `land` → hear oral-first preview.
3. Log observation: Dashboard → **Pilot Logging** → submit with screenshot + voice.

### Days 2–6 — Learning Path

Follow device-specific template in `device_logging_templates/` for your generation.

### Day 7 — Reflection & Keeper Handoff

1. Complete journey debrief in Pilot Logging.
2. Household Observer signs below.
3. Keeper receives logs via `/keeper-pilot-signoff`.

---

## One-Page Visual Checklist by Generation

| Generation | Device | Key actions | Logging template |
|------------|--------|-------------|------------------|
| Little Ones | Family iPad | Hear words by sound; parent logs voice | `little_ones_ipad_template.pdfspec.md` |
| Young Learner | Youth phone/tablet | Phrases + lessons; self or parent log | `young_learner_phone_template.md` |
| Core Adult | Android phone | Search, lessons, pilot logging | `core_adult_template.md` |
| Elder | Elder phone | Contribute, seeding, Keeper review | `elder_phone_template.md` |

---

## Elder / Keeper Signature (Required)

**Protocol 2 — Elder Approval before cohort data enters tribal archives**

| Field | Value |
|-------|-------|
| Household ID | `________________________` |
| Observer name | `________________________` |
| Keeper witness | `________________________` |
| Date (UTC) | `________________________` |
| Digital signature | Submit via Keeper sign-off → triggers `recordKeeperSignoffWithMedia()` |

```
I affirm this household completed onboarding under Kuttiomp Cultural Governance Protocols.
Signature: ________________________  Date: ________________
```

---

## Steward Contacts

| Role | Action |
|------|--------|
| Pilot Coordinator | Device distribution, consent collection |
| Technology Steward | `flutter run`, audit log review |
| Keeper Council | 7-day calendar in `keeper_7day_review_calendar.md` |

**Related:** [`../pilot_playbook.md`](../pilot_playbook.md) · [`../keeper_signoff_workflow.md`](../keeper_signoff_workflow.md)