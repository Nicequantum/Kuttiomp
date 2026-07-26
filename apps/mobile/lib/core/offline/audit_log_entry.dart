/// Local audit log entry mirrored to Isar `audit_log` (Protocol 9).
class AuditLogEntry {
  AuditLogEntry({
    required this.timestamp,
    required this.protocolId,
    required this.operation,
    required this.outcome,
    this.payloadSummary,
  });

  final DateTime timestamp;
  final String protocolId;
  final String operation;
  final String outcome;
  final String? payloadSummary;
}

/// In-memory audit store; Component 2 migrates persistence to Isar collections.
class AuditLogStore {
  AuditLogStore._();
  static final AuditLogStore instance = AuditLogStore._();

  final List<AuditLogEntry> entries = <AuditLogEntry>[];

  Future<void> log(AuditLogEntry entry) async {
    entries.add(entry);
  }

  void clear() => entries.clear();
}