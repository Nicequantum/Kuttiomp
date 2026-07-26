# Stewardship Live RPC Confirmation Checklist

**RPCs (migration 005):**

- `speaker_stewardship_summary(p_speaker_id uuid)`
- `corpus_continuity_metrics()`

**Clients:**

| Client | Primary path | Fallback |
|--------|--------------|----------|
| Flutter `StewardshipRepository` | `AuditedSupabaseClient.rawClient.rpc(...)` | Absolute counts from approved non-sacred offline lexemes |
| Admin `fetchStewardshipBundle` / `ContinuityPanelLive` | `supabase.rpc(...)` | Sample absolute counts |

**Targets:** Always force `target_lexemes = null` and `continuity_pct = null` until Keepers configure a target. Do not invent values.

## After applying 005

1. Run SQL confirmation in `docs/MIGRATION_005_APPLY.md`.
2. Admin → Stewardship page: status line should read  
   **Data source: Live database (RPC after migration 005)**  
   when network and env keys work.
3. Flutter Core Adult/Elder → Profile or dashboard stewardship card: counts load without error; if network fails, offline absolute counts still appear.
4. Re-test with airplane mode: status/fallback remains absolute counts, never invented percentages.

## Sacred exclusion

Stewardship counts exclude sacred content (Protocol 4). Confirmed in SQL functions (`is_sacred = false`) and Flutter filter (`!l.sacredFlag`).