// Canonical implementation: apps/mobile/lib/features/pilot_live/monitoring_dashboard_extension/offline_queue_depth_widget.dart
// vPilotSeedingMonitor-1.0 — documentation mirror (do not import from docs/)

/// Real-time Isar → Supabase offline queue depth panel.
///
/// Displays pending sync count, synced count, and total observations for HH01.
/// Integrated into `/keeper-council-live` via [OfflineQueueDepthPanel].
///
/// Provider: `offlineQueueDepthProvider(householdId)` → [OfflineQueueDepthSnapshot]
/// Service: `SeedingMonitorService.getOfflineQueueDepth()`