# Tribal Maintainer Guide – Design System

**Onboarding target:** one hour (Protocol 12)  
**Constitution:** Kuttiomp Master Architecture Document v2.0, §§2, 4, 8

---

## Cultural Acknowledgment

This directory is the **immediate enforcement layer** for every governed UI surface in Kuttiomp. No content may render without passing through these primitives.

---

## Directory Map (ratified §4)

| File | Protocols | Purpose |
|------|-----------|---------|
| `protocol_base_widget.dart` | 1, 2, 5, 7, 8, 10, 11 | Mandatory `assertCompliant` + `ProtocolGateway.assertSpeakerPresent` at render |
| `kuttiomp_content_widget.dart` | 1, 2, 5, 8 | Content-bearing base requiring `speakerMetadata`, `elderApproved`, `clanScope` |
| `buttons.dart` | 1, 8, 10, 11 | Dignified primary actions – 24pt min (32pt Elder) |
| `cards.dart` | 1, 8 | Attributed content cards with `AuthorityBadge` |
| `player.dart` / `audio_dominant_view.dart` | 7 | Oral-first audio; text is secondary |
| `approved_content_gate.dart` | 2 | Blocks unapproved async/detail content |
| `tier_aware_page.dart` | 3 | Generational tier enforcement for pages |
| `living_authority_decorator.dart` | 8 | Authority acknowledgment before interaction |
| `geo_context_badge.dart` | 6 | Land-based contextualization badge |
| `detail_view_shell.dart` | 1–3, 8 | Riverpod detail-route guard stack |
| `kuttiomp_design_system.dart` | 10 | Dignity registry – no playful assets |

**Backward-compatible re-exports:** `kuttiomp_button.dart`, `content_card.dart`, `oral_first_player.dart`

**Widgets barrel:** `lib/shared/widgets/` re-exports canonical design_system files.

---

## One-Hour Onboarding Path

1. **Read** `protocol_base_widget.dart` (10 min) – understand `mergedContext` and assertion order.
2. **Read** `kuttiomp_content_widget.dart` (5 min) – `buildContentContext()` factory for repositories.
3. **Trace** dashboard detail flow (15 min):
   - `detail_screens.dart` → `KuttiompDetailViewShell`
   - `ApprovedContentGate` → `ModeTierGuard` → `ContentRenderer.adaptForMode()` → `LivingAuthorityDecorator` → feature card
4. **Extend** a primitive (15 min): add a new button variant in `buttons.dart`, never bypass `ProtocolBaseWidget`.
5. **Verify** (15 min):

```bash
cd apps/mobile
flutter test test/protocol_compliance/design_system_protocol_test.dart
flutter test test/golden/design_system_golden_test.dart
flutter test test/mode_consistency/render_all_modes_test.dart
```

---

## Riverpod Detail Screen Pattern

```dart
ref.watch(lexemeDetailProvider(id)).when(
  data: (lexeme) => KuttiompDetailViewShell(
    title: 'Lexeme Detail',
    speakerMetadata: lexeme.speakerMetadata,
    contentContext: lexeme.toContentContext(),
    visibleToTiers: lexeme.visibleToTiers,
    child: LexemeCard.fromLexeme(lexeme: lexeme),
  ),
  loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
  error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
);
```

---

## Protocol Cross-References

| Protocol | Enforcement artifact in this folder |
|----------|-------------------------------------|
| 1 Speaker Attribution | `KuttiompContentWidget`, `ProtocolBaseWidget` |
| 2 Elder Approval | `ApprovedContentGate` |
| 3 Generational Tiers | `TierAwarePage`, `detail_view_shell` + `ModeTierGuard` |
| 4 Sacred Content | `ProtocolBaseWidget` sacred_flag assertion |
| 5 Clan Visibility | `KuttiompContentWidget.clanScope` |
| 6 Land Context | `GeoContextBadge` |
| 7 Oral Primacy | `AudioDominantView` |
| 8 Living Authority | `LivingAuthorityDecorator`, `AuthorityBadge` (widgets/) |
| 10 Dignity | `KuttiompDesignSystem.assertDignity()` |
| 11 Accessibility | Elder 32pt via `KuttiompThemeExtension` |
| 12 Long-Term Integrity | This guide + compliance tests |

---

## Rules (non-negotiable)

- Every primitive extends `ProtocolBaseWidget` or `KuttiompContentWidget`.
- Never import gamification, mascot, or confetti assets (Protocol 10).
- Minimum typography: 24pt base, 32pt Elder mode.
- Every major decision includes: *"This serves our people by [25-year benefit]"* in code comments.

**(Protocol 12 compliance verified)**