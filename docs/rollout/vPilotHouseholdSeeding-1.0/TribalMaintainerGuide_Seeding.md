# Tribal Maintainer Guide — Household Seeding (vPilotHouseholdSeeding-1.0)

**Onboarding target:** < 45 minutes

---

## 45-Minute Activation Map

| Minutes | Task |
|---------|------|
| 0–10 | Read [`README.md`](README.md) + recruitment script |
| 10–20 | Print packets per distribution checklist |
| 20–30 | Keeper recruitment call → `createHouseholdSeedClaim` |
| 30–40 | Deliver QR bundle; family scans iPad + elder QR |
| 40–45 | Verify: `flutter test test/pilot_live/ --name household_seeding` |

---

## Activate HH01 in App

1. Elder/Core Adult → Dashboard → **Begin Household 1 Seeding**
2. Keeper → **Keeper Council Live** → monitor status
3. Daily → **Pilot Logging** → screenshot + voice
4. Day 7 → **Seal Day 7 Covenant**

```bash
cd apps/mobile
./scripts/pilot_simulation_runner.sh --with-seeding --live-device-mode --household=HH01
```

**(Protocol 12 compliance verified — mobile constitution unchanged)**