import 'package:isar/isar.dart';

part 'isar_schemas.g.dart';

/// Embedded protocol metadata on every offline collection (§7, Protocols 1–12).
@Collection()
class ProtocolMetadata {
  Id id = Isar.autoIncrement;

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
@Collection()
class UserProfileMirror {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
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
@Collection()
class UserMasteryMirror {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String userId;

  late String canonicalStage;
  late int wordCount;
  late String modeProgressJson;
  late DateTime lastSyncedAt;
}

/// Immutable audit log persisted locally (Protocol 9).
@Collection()
class IsarAuditLogEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late String protocolId;
  late String operation;
  late String outcome;
  String? payloadSummary;
}

