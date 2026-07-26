// GENERATED CODE - DO NOT MODIFY BY HAND
// Regenerate: dart run build_runner build --delete-conflicting-outputs

part of 'isar_schemas.dart';

extension GetProtocolMetadataCollection on Isar {
  IsarCollection<ProtocolMetadata> get protocolMetadatas => this.collection();
}

extension GetIsarAuditLogEntryCollection on Isar {
  IsarCollection<IsarAuditLogEntry> get isarAuditLogEntrys => this.collection();
}

extension GetUserProfileMirrorCollection on Isar {
  IsarCollection<UserProfileMirror> get userProfileMirrors => this.collection();
}

extension GetUserMasteryMirrorCollection on Isar {
  IsarCollection<UserMasteryMirror> get userMasteryMirrors => this.collection();
}

const ProtocolMetadataSchema = CollectionSchema(
  name: r'ProtocolMetadata',
  id: 638572194732421740,
  properties: {
    r'recordId': PropertySchema(id: 0, name: r'recordId', type: IsarType.string),
    r'protocolId': PropertySchema(id: 1, name: r'protocolId', type: IsarType.string),
    r'sacredFlag': PropertySchema(id: 2, name: r'sacredFlag', type: IsarType.bool),
    r'clanScope': PropertySchema(id: 3, name: r'clanScope', type: IsarType.stringList),
    r'visibleToTiers': PropertySchema(id: 4, name: r'visibleToTiers', type: IsarType.long),
    r'speakerId': PropertySchema(id: 5, name: r'speakerId', type: IsarType.string),
    r'elderApproved': PropertySchema(id: 6, name: r'elderApproved', type: IsarType.bool),
    r'authoritySource': PropertySchema(id: 7, name: r'authoritySource', type: IsarType.string),
    r'primaryAudioId': PropertySchema(id: 8, name: r'primaryAudioId', type: IsarType.string),
    r'requiresLandContext': PropertySchema(id: 9, name: r'requiresLandContext', type: IsarType.bool),
    r'schemaVersion': PropertySchema(id: 10, name: r'schemaVersion', type: IsarType.string),
    r'lastSyncedAt': PropertySchema(id: 11, name: r'lastSyncedAt', type: IsarType.dateTime),
  },
  estimateSize: _protocolMetadataEstimateSize,
  serialize: _protocolMetadataSerialize,
  deserialize: _protocolMetadataDeserialize,
  getId: _protocolMetadataGetId,
  getLinks: _protocolMetadataGetLinks,
  attach: _protocolMetadataAttach,
  version: 0,
);

int _protocolMetadataEstimateSize(
  ProtocolMetadata object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.protocolId.length * 3;
  bytesCount += 3 + object.clanScope.length * 3;
  {
    for (var i = 0; i < object.clanScope.length; i++) {
      final value = object.clanScope[i];
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.speakerId.length * 3;
  bytesCount += 3 + object.authoritySource.length * 3;
  {
    final value = object.primaryAudioId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.schemaVersion.length * 3;
  return bytesCount;
}

void _protocolMetadataSerialize(
  ProtocolMetadata object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.recordId);
  writer.writeString(offsets[1], object.protocolId);
  writer.writeBool(offsets[2], object.sacredFlag);
  writer.writeStringList(offsets[3], object.clanScope);
  writer.writeLong(offsets[4], object.visibleToTiers);
  writer.writeString(offsets[5], object.speakerId);
  writer.writeBool(offsets[6], object.elderApproved);
  writer.writeString(offsets[7], object.authoritySource);
  writer.writeString(offsets[8], object.primaryAudioId);
  writer.writeBool(offsets[9], object.requiresLandContext);
  writer.writeString(offsets[10], object.schemaVersion);
  writer.writeDateTime(offsets[11], object.lastSyncedAt);
}

ProtocolMetadata _protocolMetadataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProtocolMetadata();
  object.id = id;
  object.recordId = reader.readString(offsets[0]);
  object.protocolId = reader.readString(offsets[1]);
  object.sacredFlag = reader.readBool(offsets[2]);
  object.clanScope = reader.readStringList(offsets[3]) ?? [];
  object.visibleToTiers = reader.readLong(offsets[4]);
  object.speakerId = reader.readString(offsets[5]);
  object.elderApproved = reader.readBool(offsets[6]);
  object.authoritySource = reader.readString(offsets[7]);
  object.primaryAudioId = reader.readString(offsets[8]);
  object.requiresLandContext = reader.readBool(offsets[9]);
  object.schemaVersion = reader.readString(offsets[10]);
  object.lastSyncedAt = reader.readDateTime(offsets[11]);
  return object;
}

Id _protocolMetadataGetId(ProtocolMetadata object) => object.id;

List<IsarLinkBase<dynamic>> _protocolMetadataGetLinks(ProtocolMetadata object) => [];

void _protocolMetadataAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProtocolMetadata object,
) {
  object.id = id;
}

const IsarAuditLogEntrySchema = CollectionSchema(
  name: r'IsarAuditLogEntry',
  id: -892451234567890123,
  properties: {
    r'timestamp': PropertySchema(id: 0, name: r'timestamp', type: IsarType.dateTime),
    r'protocolId': PropertySchema(id: 1, name: r'protocolId', type: IsarType.string),
    r'operation': PropertySchema(id: 2, name: r'operation', type: IsarType.string),
    r'outcome': PropertySchema(id: 3, name: r'outcome', type: IsarType.string),
    r'payloadSummary': PropertySchema(id: 4, name: r'payloadSummary', type: IsarType.string),
  },
  estimateSize: _isarAuditLogEntryEstimateSize,
  serialize: _isarAuditLogEntrySerialize,
  deserialize: _isarAuditLogEntryDeserialize,
  getId: _isarAuditLogEntryGetId,
  getLinks: _isarAuditLogEntryGetLinks,
  attach: _isarAuditLogEntryAttach,
  version: 0,
);

int _isarAuditLogEntryEstimateSize(
  IsarAuditLogEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.protocolId.length * 3;
  bytesCount += 3 + object.operation.length * 3;
  bytesCount += 3 + object.outcome.length * 3;
  {
    final value = object.payloadSummary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarAuditLogEntrySerialize(
  IsarAuditLogEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.timestamp);
  writer.writeString(offsets[1], object.protocolId);
  writer.writeString(offsets[2], object.operation);
  writer.writeString(offsets[3], object.outcome);
  writer.writeString(offsets[4], object.payloadSummary);
}

IsarAuditLogEntry _isarAuditLogEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAuditLogEntry();
  object.id = id;
  object.timestamp = reader.readDateTime(offsets[0]);
  object.protocolId = reader.readString(offsets[1]);
  object.operation = reader.readString(offsets[2]);
  object.outcome = reader.readString(offsets[3]);
  object.payloadSummary = reader.readString(offsets[4]);
  return object;
}

Id _isarAuditLogEntryGetId(IsarAuditLogEntry object) => object.id;

List<IsarLinkBase<dynamic>> _isarAuditLogEntryGetLinks(IsarAuditLogEntry object) => [];

void _isarAuditLogEntryAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarAuditLogEntry object,
) {
  object.id = id;
}

const UserProfileMirrorSchema = CollectionSchema(
  name: r'UserProfileMirror',
  id: 482910374651283947,
  properties: {
    r'userId': PropertySchema(id: 0, name: r'userId', type: IsarType.string),
    r'mode': PropertySchema(id: 1, name: r'mode', type: IsarType.string),
    r'clan': PropertySchema(id: 2, name: r'clan', type: IsarType.string),
    r'role': PropertySchema(id: 3, name: r'role', type: IsarType.string),
    r'tier': PropertySchema(id: 4, name: r'tier', type: IsarType.long),
    r'encryptedPayload': PropertySchema(id: 5, name: r'encryptedPayload', type: IsarType.string),
    r'lastSyncedAt': PropertySchema(id: 6, name: r'lastSyncedAt', type: IsarType.dateTime),
    r'elderOverride': PropertySchema(id: 7, name: r'elderOverride', type: IsarType.bool),
  },
  estimateSize: _userProfileMirrorEstimateSize,
  serialize: _userProfileMirrorSerialize,
  deserialize: _userProfileMirrorDeserialize,
  getId: _userProfileMirrorGetId,
  getLinks: _userProfileMirrorGetLinks,
  attach: _userProfileMirrorAttach,
  version: 0,
);

int _userProfileMirrorEstimateSize(
  UserProfileMirror object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.mode.length * 3;
  bytesCount += 3 + object.clan.length * 3;
  bytesCount += 3 + object.role.length * 3;
  bytesCount += 3 + object.encryptedPayload.length * 3;
  return bytesCount;
}

void _userProfileMirrorSerialize(
  UserProfileMirror object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.userId);
  writer.writeString(offsets[1], object.mode);
  writer.writeString(offsets[2], object.clan);
  writer.writeString(offsets[3], object.role);
  writer.writeLong(offsets[4], object.tier);
  writer.writeString(offsets[5], object.encryptedPayload);
  writer.writeDateTime(offsets[6], object.lastSyncedAt);
  writer.writeBool(offsets[7], object.elderOverride);
}

UserProfileMirror _userProfileMirrorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileMirror();
  object.id = id;
  object.userId = reader.readString(offsets[0]);
  object.mode = reader.readString(offsets[1]);
  object.clan = reader.readString(offsets[2]);
  object.role = reader.readString(offsets[3]);
  object.tier = reader.readLong(offsets[4]);
  object.encryptedPayload = reader.readString(offsets[5]);
  object.lastSyncedAt = reader.readDateTime(offsets[6]);
  object.elderOverride = reader.readBool(offsets[7]);
  return object;
}

Id _userProfileMirrorGetId(UserProfileMirror object) => object.id;

List<IsarLinkBase<dynamic>> _userProfileMirrorGetLinks(UserProfileMirror object) => [];

void _userProfileMirrorAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProfileMirror object,
) {
  object.id = id;
}

const UserMasteryMirrorSchema = CollectionSchema(
  name: r'UserMasteryMirror',
  id: -374829105647382910,
  properties: {
    r'userId': PropertySchema(id: 0, name: r'userId', type: IsarType.string),
    r'canonicalStage': PropertySchema(id: 1, name: r'canonicalStage', type: IsarType.string),
    r'wordCount': PropertySchema(id: 2, name: r'wordCount', type: IsarType.long),
    r'modeProgressJson': PropertySchema(id: 3, name: r'modeProgressJson', type: IsarType.string),
    r'lastSyncedAt': PropertySchema(id: 4, name: r'lastSyncedAt', type: IsarType.dateTime),
  },
  estimateSize: _userMasteryMirrorEstimateSize,
  serialize: _userMasteryMirrorSerialize,
  deserialize: _userMasteryMirrorDeserialize,
  getId: _userMasteryMirrorGetId,
  getLinks: _userMasteryMirrorGetLinks,
  attach: _userMasteryMirrorAttach,
  version: 0,
);

int _userMasteryMirrorEstimateSize(
  UserMasteryMirror object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.canonicalStage.length * 3;
  bytesCount += 3 + object.modeProgressJson.length * 3;
  return bytesCount;
}

void _userMasteryMirrorSerialize(
  UserMasteryMirror object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.userId);
  writer.writeString(offsets[1], object.canonicalStage);
  writer.writeLong(offsets[2], object.wordCount);
  writer.writeString(offsets[3], object.modeProgressJson);
  writer.writeDateTime(offsets[4], object.lastSyncedAt);
}

UserMasteryMirror _userMasteryMirrorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserMasteryMirror();
  object.id = id;
  object.userId = reader.readString(offsets[0]);
  object.canonicalStage = reader.readString(offsets[1]);
  object.wordCount = reader.readLong(offsets[2]);
  object.modeProgressJson = reader.readString(offsets[3]);
  object.lastSyncedAt = reader.readDateTime(offsets[4]);
  return object;
}

Id _userMasteryMirrorGetId(UserMasteryMirror object) => object.id;

List<IsarLinkBase<dynamic>> _userMasteryMirrorGetLinks(UserMasteryMirror object) => [];

void _userMasteryMirrorAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserMasteryMirror object,
) {
  object.id = id;
}