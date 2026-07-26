# Device Pairing QR Bundle — HH01

**Zipspec | iPad + Elder phone paired via Supabase claim**

## Bundle Contents

```
hh01-qr-bundle/
├── ipad_little_ones.qr.png      → kuttiomp://first-launch?household=HH01&mode=little_ones
├── elder_phone_pair.qr.png      → kuttiomp://profile?household=HH01&pair=elder
├── onboarding_audio.qr.png      → kuttiomp://first-launch?audio=hh01WelcomeGreeting
└── manifest.json
```

## Pairing Flow

1. Family scans **ipad_little_ones.qr** on family iPad → auto-enters Little Ones mode
2. Elder scans **elder_phone_pair.qr** → receives paired claim on elder device
3. `HouseholdSeedingService.pairDevices(householdId: 'HH01')` confirms link
4. Dashboard shows **Begin Household 1 Seeding** → transitions to active Day 1

## RPC

```dart
await HouseholdSeedingService().createHouseholdSeedClaim(
  keeperId: 'keeper-hh01-council',
  householdId: 'HH01',
  seedingCohort: 'pilot-household-1-2026',
);
```