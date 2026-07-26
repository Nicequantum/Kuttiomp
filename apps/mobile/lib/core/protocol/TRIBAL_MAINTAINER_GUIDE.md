# Tribal Maintainer Guide – Protocol Layer (v2.0)

**Onboarding target:** < 30 minutes (within Core Infrastructure guide).

## Files in This Folder

| File | Protocol | Purpose |
|------|----------|---------|
| `protocol_service.dart` | All 12 | Singleton enforcement; call `init()` at app start |
| `protocol_gateway.dart` | All 12 | Gateway for repositories and widgets |
| `guards/speaker_attribution_guard.dart` | 1 | Speaker metadata required |
| `guards/elder_approval_guard.dart` | 2 | Elder-approved content only |
| `guards/mode_tier_guard.dart` | 3 | Generational tier bitmask |
| `guards/sacred_content_locker.dart` | 4 | Sacred consent gate |
| `guards/clan_scope_filter.dart` | 5 | Clan visibility |
| `guards/land_context_guard.dart` | 6 | Land/season context |
| `guards/oral_tradition_guard.dart` | 7 | Primary audio required |
| `guards/living_authority_guard.dart` | 8 | Authority source badge |
| `guards/data_sovereignty_guard.dart` | 9 | No direct table access |
| `guards/dignity_guard.dart` | 10 | No gamification |
| `guards/accessibility_guard.dart` | 11 | Elder-centric typography |
| `guards/cultural_integrity_guard.dart` | 12 | Schema versioning |
| `attribution_renderer.dart` | 1 | Base for content widgets |
| `approved_content_gate.dart` | 2 | Blocks unapproved render |
| `tier_aware_page.dart` | 3 | Tier-gated pages |
| `ceremonial_vault.dart` | 4 | Sacred local encryption |

## Run Tests

```bash
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
```

**(Protocol 12 compliance verified)**