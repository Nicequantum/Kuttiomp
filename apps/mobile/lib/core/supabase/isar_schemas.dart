import 'package:isar/isar.dart';

part 'isar_schemas.g.dart';

/// Embedded protocol metadata on every offline collection (§7, Protocols 1–12).
///
/// Aligned to Isar 4.0.0-dev.14 API. This serves our people by keeping
/// protocol-guarded offline mirrors compilable for 25 years of household use.
@collection
class ProtocolMetadata {
  /// Primary key; use [IsarCollection.autoIncrement] when inserting new rows.
  int id = 0;

  @Index()
  late String recordId;

  late String protocolId;
  late bool sacredFlag;
  late List<String> clanScope;
  late int visibleToTiers;
  late String speakerId;
  late bool elderApproved;
  late String authoritySource;
  late String? primaryAudioId;
  late bool requiresLandContext;
  late String schemaVersion;
  late DateTime lastSyncedAt;
}

/// Encrypted user profile mirror (§13, Protocol 9).
@collection
class UserProfileMirror {
  int id = 0;

  @Index(unique: true)
  late String userId;

  late String mode;
  late String clan;
  late String role;
  late int tier;
  late String encryptedPayload;
  late DateTime lastSyncedAt;
  late bool elderOverride;
}

/// Unified mastery record mirror – filtered per mode (§6).
@collection
class UserMasteryMirror {
  int id = 0;

  @Index(unique: true)
  late String userId;

  late String canonicalStage;
  late int wordCount;
  late String modeProgressJson;
  late DateTime lastSyncedAt;
}

/// Immutable audit log persisted locally (Protocol 9).
@collection
class IsarAuditLogEntry {
  int id = 0;

  @Index()
  late DateTime timestamp;

  late String protocolId;
  late String operation;
  late String outcome;
  String? payloadSummary;
}
