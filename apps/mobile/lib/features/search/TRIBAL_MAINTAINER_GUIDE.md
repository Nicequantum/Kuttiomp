# Tribal Maintainer Guide – Search

**Onboarding:** &lt; 1 hour  
**Route:** `/search`

## Map

| Path | Role |
|------|------|
| `data/search_repository.dart` | Audited search across lexeme/phrase/lesson |
| `domain/search_result_model.dart` | Unified result + protocol fields |
| `presentation/search_page.dart` | Query UI |
| `presentation/search_result_card.dart` | KuttiompContentWidget + ApprovedContentGate |

## Rules

- Results must be elder-approved; unapproved return empty widget.
- Sacred results show badge; detail route still enforces SacredContentLocker.
- Oral-first player on every result.

## Verify

```bash
flutter test test/features/search/
```

**(Protocol 12 compliance verified)**