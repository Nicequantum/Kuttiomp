# 7-Day Keeper Review Calendar

**vPilotCohortDocs-1.0 | Tied to `PilotLiveLogStore` + `KeeperLiveSignoffNotifier`**

**Protocols:** 2 (Elder Approval), 8 (Living Authority), 9 (Data Sovereignty)

---

## Calendar Overview

```yaml
Day 1–2: Receive & acknowledge cohort logs (audit trail auto-written)
Day 3: Group media review session (via /keeper-pilot-signoff)
Day 4–5: Approve / request revision with LivingAuthorityDecorator stamp
Day 6: Export "Ready for Scale" bundle → Supabase RPC
Day 7: Community circle reflection entry (seeded into vSeeding-1.0)
```

---

## Printable Grid

| Day | Keeper action | Mobile route / API | Audit operation |
|-----|---------------|-------------------|-----------------|
| **1** | Acknowledge cohort start; verify household consents | Profile → Keeper Dashboard | `pilot_live:submit_observation` (incoming) |
| **2** | Review offline queue depth per household | `PilotLiveLogStore.pendingSync()` | `pilot_live:sync_queue` on reconnect |
| **3** | **Group media review** — screenshots + voice notes | `/keeper-pilot-signoff` | `pilot_live:keeper_signoff` (draft) |
| **4** | Approve observations; request revision if needed | `KeeperLiveSignoffView` | Protocol 2 gate |
| **5** | Living authority stamp on approved corpus entries | `recordKeeperSignoffWithMedia()` | `pilot:keeper_signoff` mirror |
| **6** | Export Ready for Scale bundle | `submit_live_pilot_observation_secure` RPC | `approved_ready_for_scale` |
| **7** | Community reflection → seeding campaign note | `/seeding` optional | `seeding:trigger_campaign` |

---

## Day 3 — Media Review Checklist

- [ ] Every observation has `speaker_id` (Protocol 1)
- [ ] Screenshots are UI-only (no sacred/ceremonial content)
- [ ] Voice notes have `primary_audio_id` (Protocol 7)
- [ ] Elder households show contribution chain if applicable
- [ ] `KeeperLiveSignoffNotifier.pendingReviewCount` reviewed

---

## Day 6 — Export Bundle

```dart
final signoff = await PilotLiveService().recordKeeperSignoffWithMedia(
  cohortId: 'pilot-cohort-live-2026',
  keeperId: '{keeper_id}',
  keeperName: '{keeper_name}',
  status: PilotSignoffStatus.approvedReadyForScale,
  protocolCoverage: '100%',
);
```

Isar sync hook: observations marked `synced: true` after successful RPC.  
Offline entries remain in queue until `syncPendingObservations()` succeeds.

---

## Day 7 — Seeding Reflection

Optional: launch **Land Stewardship Phrases** campaign with community circle insights:

```dart
await CorpusSeedingService().triggerSeedingCampaign(
  campaign: ElderCampaign.landStewardshipPhrases,
);
```

---

## Related Documents

- [`../keeper_signoff_workflow.md`](../keeper_signoff_workflow.md)
- [`templates/keeper_signoff_checklist.json`](templates/keeper_signoff_checklist.json)
- `apps/mobile/lib/features/pilot_live/pilot_live_TRIBAL_MAINTAINER_GUIDE.md`