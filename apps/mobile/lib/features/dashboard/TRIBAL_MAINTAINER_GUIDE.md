# Tribal Maintainer Guide – Dashboard

**Onboarding:** &lt; 1 hour  
**Routes:** `/dashboard` (shell), lists via petals

## Map

| File | Role |
|------|------|
| `presentation/dashboard_screen.dart` | Home: mastery petal, phrases, lessons, stewardship (gated) |
| `presentation/content_section_petal.dart` | Unified petal chrome (absolute counts) |
| `presentation/phrase_card.dart` / `lesson_card.dart` / `lexeme_card.dart` | Petals → `/phrases` `/lessons` `/lexemes` |
| `presentation/content_list_screens.dart` | Re-exports feature list screens |
| `presentation/detail_screens.dart` | Re-exports feature detail screens |

## Rules

- Petals show **absolute counts only** (Protocol 10).
- Content lives in `features/lexeme|phrases|lessons` — do not re-implement cards here.
- Stewardship on dashboard is Core Adult / Elder only.

## Verify

```bash
flutter test test/features/dashboard/
```

**(Protocol 12 compliance verified)**