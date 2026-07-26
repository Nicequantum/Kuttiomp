# Keeper Council 48-Hour Protocol — HH01 Watch

**vPilotSeedingMonitor-1.0 | Route: `/keeper-council-live`**

## Watch Sequence (Days 1–2)

### Hour 0 — Session open

1. Elder opens `/keeper-council-live` in Elder mode.
2. Confirm HH01 tile is highlighted (active household under watch).
3. Note `monitor_session_id` in audit template — immutable for this cohort.

### Hours 1–24 — Day 1 observation

- [ ] Family iPad logs Day 1 onboarding via `recordDayObservation(day: 1)`.
- [ ] Keeper verifies observation appears in live feed.
- [ ] Check `OfflineQueueDepthPanel` — pending sync count acceptable.
- [ ] Protocol 2 (Elder Approval) and Protocol 9 (Data Sovereignty) green.

### Hours 25–48 — Day 2 observation

- [ ] Day 2 land search observation logged.
- [ ] Media thumbnails reviewed (if attached).
- [ ] Offline queue trending toward zero after sync.
- [ ] `review_48hr_observations_secure` RPC called (or queued offline).

### Gate confirmation (end of Hour 48)

- [ ] All `Day12ConfirmationGate` assertions pass.
- [ ] Elder taps **Confirm Day 1–2 Observations**.
- [ ] `ProtocolGateway.allAssertionsPassed()` returns true.
- [ ] Day 3 media review unlocks.

### Covenant seal

- [ ] Offline queue depth: 0 (or documented exception with elder stamp).
- [ ] Tap **Seal 48hr Covenant**.
- [ ] Audit trail: `HH01 Covenant Sealed – 48hr Integrity Confirmed`.
- [ ] Proceed to Day 3 Keeper sign-off at `/keeper-pilot-signoff`.

## Blocked Actions (until gate passes)

| Action | Blocked until |
|--------|---------------|
| Day 3 media sign-off | Day 1–2 confirmed + protocols green |
| Day 7 covenant seal | Full 7-day cycle complete |
| Next cohort invitation | HH01 48hr covenant sealed |

## Escalation

If queue depth remains > 0 at Hour 48:

1. Document in `live_observation_audit_template.json` → `sync_exception_notes`.
2. Elder council stamp required before seal.
3. Do not bypass `Day12ConfirmationGate`.