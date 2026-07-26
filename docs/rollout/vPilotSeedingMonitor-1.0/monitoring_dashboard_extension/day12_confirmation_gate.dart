// Canonical implementation: apps/mobile/lib/features/pilot_live/monitoring_dashboard_extension/day12_confirmation_gate.dart
// vPilotSeedingMonitor-1.0 — documentation mirror (do not import from docs/)

/// Blocks Day 3 media review until Day 1–2 confirmed + ProtocolGateway passes.
///
/// Gate flow:
/// 1. Keeper reviews Day 1–2 observations in live feed
/// 2. Taps "Confirm Day 1–2 Observations"
/// 3. `SeedingMonitorService.confirmDay12Gate()` asserts protocols 1,2,8,9,11,12
/// 4. Day 3 unlocks → `/keeper-pilot-signoff` accessible
///
/// Status indicators: Day 1–2 confirmed | Day 3 unlocked | 48hr covenant sealed