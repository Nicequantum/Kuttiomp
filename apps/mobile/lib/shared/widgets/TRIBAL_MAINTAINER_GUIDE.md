# Tribal Maintainer Guide – Shared Protocol Widgets (v2.0)

**Onboarding target:** < 20 minutes.

## Cultural Enforcement Points

Search **`ProtocolBaseWidget`** or **`KuttiompThemeExtension.forMode`** to locate cultural enforcement points.

## Widget Index

| Widget | Protocol | File |
|--------|----------|------|
| `ProtocolBaseWidget` | 1,2,8,10,11 | `protocol_base_widget.dart` |
| `ApprovedContentGate` | 2 | `approved_content_gate.dart` |
| `TierAwarePage` | 3 | `tier_aware_page.dart` |
| `AuthorityBadge` | 8 | `authority_badge.dart` |
| `GeoContextBadge` | 6 | `geo_context_badge.dart` |
| `LivingAuthorityDecorator` | 8 | `living_authority_decorator.dart` |
| `ElderModeOverlay` | 11 | `elder_mode_overlay.dart` |
| `AccessibilityEngine` | 11 | `accessibility_engine.dart` |

## Adding a New Shared Widget

1. Extend `ProtocolBaseWidget` with `speakerMetadata` + `contentContext`.
2. Call `KuttiompDesignSystem.assertDignity()` if using assets.
3. Add mode-consistency test in `test/mode_consistency/`.

**(Protocol 12 compliance verified)**