# Tribal Maintainer Guide – Elder Recording & Approval (v2.0)

**Onboarding target:** < 30 minutes.

## Purpose

Mobile-side elder audio upload stub with Keeper approval chain simulation (Protocol 2 crown jewel, Protocol 8 living authority).

## Quick Navigation

**Search `recording_service` to see submit flow; onboarding <30 minutes.**

1. Open `lib/features/profile/domain/recording_service.dart` → `captureRecording()` + `submitForApproval()`.
2. Open `lib/features/profile/domain/approval_simulation.dart` → `approveRecording()` Keeper chain.
3. Open `lib/features/profile/domain/approved_contributions_store.dart` → corpus mirror after approval.
4. Open `lib/features/profile/presentation/elder_recording_page.dart` → Elder tier recording UI.
5. Open `lib/features/profile/presentation/keeper_approval_panel.dart` → Profile approval queue.
6. Open `lib/features/profile/presentation/pending_approval_gate.dart` → Protocol 2 pending gate.
7. Open `lib/features/profile/elder_recording_providers.dart` → Riverpod wiring.

## Data Flow

1. Dashboard **Contribute** petal (Elder mode) or Profile → `/contribute`.
2. Elder records audio stub → submits → `Recording submitted | Protocol 2 pending elder review`.
3. Profile **Keeper Approval Queue** → Approve → `Recording approved | Protocols 2,8 enforced`.
4. Approved content mirrors into lexeme/phrase/search offline corpora via `ApprovedContributionsStore`.
5. RPCs: `submit_elder_recording_secure`, `approve_elder_recording_secure`.

## Verify

```bash
cd apps/mobile
flutter test test/features/profile/elder_recording_protocol_test.dart
flutter run
```

Expected: Switch to Elder → Contribute → record → submit → Profile approve → word appears in /learn.

**(Protocol 12 compliance verified)**