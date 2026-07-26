// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_schemas.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetProtocolMetadataCollection on Isar {
  IsarCollection<int, ProtocolMetadata> get protocolMetadatas =>
      this.collection();
}

const ProtocolMetadataSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ProtocolMetadata',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'recordId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'protocolId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'sacredFlag',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'clanScope',
        type: IsarType.stringList,
      ),
      IsarPropertySchema(
        name: 'visibleToTiers',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'speakerId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'elderApproved',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'authoritySource',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'primaryAudioId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'requiresLandContext',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'schemaVersion',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lastSyncedAt',
        type: IsarType.dateTime,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'recordId',
        properties: [
          "recordId",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, ProtocolMetadata>(
    serialize: serializeProtocolMetadata,
    deserialize: deserializeProtocolMetadata,
    deserializeProperty: deserializeProtocolMetadataProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeProtocolMetadata(IsarWriter writer, ProtocolMetadata object) {
  IsarCore.writeString(writer, 1, object.recordId);
  IsarCore.writeString(writer, 2, object.protocolId);
  IsarCore.writeBool(writer, 3, object.sacredFlag);
  {
    final list = object.clanScope;
    final listWriter = IsarCore.beginList(writer, 4, list.length);
    for (var i = 0; i < list.length; i++) {
      IsarCore.writeString(listWriter, i, list[i]);
    }
    IsarCore.endList(writer, listWriter);
  }
  IsarCore.writeLong(writer, 5, object.visibleToTiers);
  IsarCore.writeString(writer, 6, object.speakerId);
  IsarCore.writeBool(writer, 7, object.elderApproved);
  IsarCore.writeString(writer, 8, object.authoritySource);
  {
    final value = object.primaryAudioId;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  IsarCore.writeBool(writer, 10, object.requiresLandContext);
  IsarCore.writeString(writer, 11, object.schemaVersion);
  IsarCore.writeLong(
      writer, 12, object.lastSyncedAt.toUtc().microsecondsSinceEpoch);
  return object.id;
}

@isarProtected
ProtocolMetadata deserializeProtocolMetadata(IsarReader reader) {
  final object = ProtocolMetadata();
  object.id = IsarCore.readId(reader);
  object.recordId = IsarCore.readString(reader, 1) ?? '';
  object.protocolId = IsarCore.readString(reader, 2) ?? '';
  object.sacredFlag = IsarCore.readBool(reader, 3);
  {
    final length = IsarCore.readList(reader, 4, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        object.clanScope = const <String>[];
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        object.clanScope = list;
      }
    }
  }
  object.visibleToTiers = IsarCore.readLong(reader, 5);
  object.speakerId = IsarCore.readString(reader, 6) ?? '';
  object.elderApproved = IsarCore.readBool(reader, 7);
  object.authoritySource = IsarCore.readString(reader, 8) ?? '';
  object.primaryAudioId = IsarCore.readString(reader, 9);
  object.requiresLandContext = IsarCore.readBool(reader, 10);
  object.schemaVersion = IsarCore.readString(reader, 11) ?? '';
  {
    final value = IsarCore.readLong(reader, 12);
    if (value == -9223372036854775808) {
      object.lastSyncedAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.lastSyncedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeProtocolMetadataProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readBool(reader, 3);
    case 4:
      {
        final length = IsarCore.readList(reader, 4, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <String>[];
          } else {
            final list = List<String>.filled(length, '', growable: true);
            for (var i = 0; i < length; i++) {
              list[i] = IsarCore.readString(reader, i) ?? '';
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readBool(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8) ?? '';
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      return IsarCore.readBool(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11) ?? '';
    case 12:
      {
        final value = IsarCore.readLong(reader, 12);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ProtocolMetadataUpdate {
  bool call({
    required int id,
    String? recordId,
    String? protocolId,
    bool? sacredFlag,
    int? visibleToTiers,
    String? speakerId,
    bool? elderApproved,
    String? authoritySource,
    String? primaryAudioId,
    bool? requiresLandContext,
    String? schemaVersion,
    DateTime? lastSyncedAt,
  });
}

class _ProtocolMetadataUpdateImpl implements _ProtocolMetadataUpdate {
  const _ProtocolMetadataUpdateImpl(this.collection);

  final IsarCollection<int, ProtocolMetadata> collection;

  @override
  bool call({
    required int id,
    Object? recordId = ignore,
    Object? protocolId = ignore,
    Object? sacredFlag = ignore,
    Object? visibleToTiers = ignore,
    Object? speakerId = ignore,
    Object? elderApproved = ignore,
    Object? authoritySource = ignore,
    Object? primaryAudioId = ignore,
    Object? requiresLandContext = ignore,
    Object? schemaVersion = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (recordId != ignore) 1: recordId as String?,
          if (protocolId != ignore) 2: protocolId as String?,
          if (sacredFlag != ignore) 3: sacredFlag as bool?,
          if (visibleToTiers != ignore) 5: visibleToTiers as int?,
          if (speakerId != ignore) 6: speakerId as String?,
          if (elderApproved != ignore) 7: elderApproved as bool?,
          if (authoritySource != ignore) 8: authoritySource as String?,
          if (primaryAudioId != ignore) 9: primaryAudioId as String?,
          if (requiresLandContext != ignore) 10: requiresLandContext as bool?,
          if (schemaVersion != ignore) 11: schemaVersion as String?,
          if (lastSyncedAt != ignore) 12: lastSyncedAt as DateTime?,
        }) >
        0;
  }
}

sealed class _ProtocolMetadataUpdateAll {
  int call({
    required List<int> id,
    String? recordId,
    String? protocolId,
    bool? sacredFlag,
    int? visibleToTiers,
    String? speakerId,
    bool? elderApproved,
    String? authoritySource,
    String? primaryAudioId,
    bool? requiresLandContext,
    String? schemaVersion,
    DateTime? lastSyncedAt,
  });
}

class _ProtocolMetadataUpdateAllImpl implements _ProtocolMetadataUpdateAll {
  const _ProtocolMetadataUpdateAllImpl(this.collection);

  final IsarCollection<int, ProtocolMetadata> collection;

  @override
  int call({
    required List<int> id,
    Object? recordId = ignore,
    Object? protocolId = ignore,
    Object? sacredFlag = ignore,
    Object? visibleToTiers = ignore,
    Object? speakerId = ignore,
    Object? elderApproved = ignore,
    Object? authoritySource = ignore,
    Object? primaryAudioId = ignore,
    Object? requiresLandContext = ignore,
    Object? schemaVersion = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (recordId != ignore) 1: recordId as String?,
      if (protocolId != ignore) 2: protocolId as String?,
      if (sacredFlag != ignore) 3: sacredFlag as bool?,
      if (visibleToTiers != ignore) 5: visibleToTiers as int?,
      if (speakerId != ignore) 6: speakerId as String?,
      if (elderApproved != ignore) 7: elderApproved as bool?,
      if (authoritySource != ignore) 8: authoritySource as String?,
      if (primaryAudioId != ignore) 9: primaryAudioId as String?,
      if (requiresLandContext != ignore) 10: requiresLandContext as bool?,
      if (schemaVersion != ignore) 11: schemaVersion as String?,
      if (lastSyncedAt != ignore) 12: lastSyncedAt as DateTime?,
    });
  }
}

extension ProtocolMetadataUpdate on IsarCollection<int, ProtocolMetadata> {
  _ProtocolMetadataUpdate get update => _ProtocolMetadataUpdateImpl(this);

  _ProtocolMetadataUpdateAll get updateAll =>
      _ProtocolMetadataUpdateAllImpl(this);
}

sealed class _ProtocolMetadataQueryUpdate {
  int call({
    String? recordId,
    String? protocolId,
    bool? sacredFlag,
    int? visibleToTiers,
    String? speakerId,
    bool? elderApproved,
    String? authoritySource,
    String? primaryAudioId,
    bool? requiresLandContext,
    String? schemaVersion,
    DateTime? lastSyncedAt,
  });
}

class _ProtocolMetadataQueryUpdateImpl implements _ProtocolMetadataQueryUpdate {
  const _ProtocolMetadataQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ProtocolMetadata> query;
  final int? limit;

  @override
  int call({
    Object? recordId = ignore,
    Object? protocolId = ignore,
    Object? sacredFlag = ignore,
    Object? visibleToTiers = ignore,
    Object? speakerId = ignore,
    Object? elderApproved = ignore,
    Object? authoritySource = ignore,
    Object? primaryAudioId = ignore,
    Object? requiresLandContext = ignore,
    Object? schemaVersion = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (recordId != ignore) 1: recordId as String?,
      if (protocolId != ignore) 2: protocolId as String?,
      if (sacredFlag != ignore) 3: sacredFlag as bool?,
      if (visibleToTiers != ignore) 5: visibleToTiers as int?,
      if (speakerId != ignore) 6: speakerId as String?,
      if (elderApproved != ignore) 7: elderApproved as bool?,
      if (authoritySource != ignore) 8: authoritySource as String?,
      if (primaryAudioId != ignore) 9: primaryAudioId as String?,
      if (requiresLandContext != ignore) 10: requiresLandContext as bool?,
      if (schemaVersion != ignore) 11: schemaVersion as String?,
      if (lastSyncedAt != ignore) 12: lastSyncedAt as DateTime?,
    });
  }
}

extension ProtocolMetadataQueryUpdate on IsarQuery<ProtocolMetadata> {
  _ProtocolMetadataQueryUpdate get updateFirst =>
      _ProtocolMetadataQueryUpdateImpl(this, limit: 1);

  _ProtocolMetadataQueryUpdate get updateAll =>
      _ProtocolMetadataQueryUpdateImpl(this);
}

class _ProtocolMetadataQueryBuilderUpdateImpl
    implements _ProtocolMetadataQueryUpdate {
  const _ProtocolMetadataQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ProtocolMetadata, ProtocolMetadata, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? recordId = ignore,
    Object? protocolId = ignore,
    Object? sacredFlag = ignore,
    Object? visibleToTiers = ignore,
    Object? speakerId = ignore,
    Object? elderApproved = ignore,
    Object? authoritySource = ignore,
    Object? primaryAudioId = ignore,
    Object? requiresLandContext = ignore,
    Object? schemaVersion = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (recordId != ignore) 1: recordId as String?,
        if (protocolId != ignore) 2: protocolId as String?,
        if (sacredFlag != ignore) 3: sacredFlag as bool?,
        if (visibleToTiers != ignore) 5: visibleToTiers as int?,
        if (speakerId != ignore) 6: speakerId as String?,
        if (elderApproved != ignore) 7: elderApproved as bool?,
        if (authoritySource != ignore) 8: authoritySource as String?,
        if (primaryAudioId != ignore) 9: primaryAudioId as String?,
        if (requiresLandContext != ignore) 10: requiresLandContext as bool?,
        if (schemaVersion != ignore) 11: schemaVersion as String?,
        if (lastSyncedAt != ignore) 12: lastSyncedAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension ProtocolMetadataQueryBuilderUpdate
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QOperations> {
  _ProtocolMetadataQueryUpdate get updateFirst =>
      _ProtocolMetadataQueryBuilderUpdateImpl(this, limit: 1);

  _ProtocolMetadataQueryUpdate get updateAll =>
      _ProtocolMetadataQueryBuilderUpdateImpl(this);
}

extension ProtocolMetadataQueryFilter
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QFilterCondition> {
  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      protocolIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      sacredFlagEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeIsEmpty() {
    return not().clanScopeIsNotEmpty();
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      clanScopeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 4, value: null),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      visibleToTiersBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      speakerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      elderApprovedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      authoritySourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 9,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      primaryAudioIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      requiresLandContextEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      schemaVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension ProtocolMetadataQueryObject
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QFilterCondition> {}

extension ProtocolMetadataQuerySortBy
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QSortBy> {
  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy> sortByRecordId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByRecordIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByProtocolIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySacredFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySacredFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByVisibleToTiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByVisibleToTiersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySpeakerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySpeakerIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByElderApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByElderApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByAuthoritySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByAuthoritySourceDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByPrimaryAudioId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByPrimaryAudioIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByRequiresLandContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByRequiresLandContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySchemaVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortBySchemaVersionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension ProtocolMetadataQuerySortThenBy
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QSortThenBy> {
  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy> thenByRecordId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByRecordIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByProtocolIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySacredFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySacredFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByVisibleToTiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByVisibleToTiersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySpeakerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySpeakerIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByElderApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByElderApprovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByAuthoritySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByAuthoritySourceDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByPrimaryAudioId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByPrimaryAudioIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByRequiresLandContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByRequiresLandContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySchemaVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenBySchemaVersionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension ProtocolMetadataQueryWhereDistinct
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QDistinct> {
  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByRecordId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctBySacredFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByClanScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByVisibleToTiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctBySpeakerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByElderApproved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByAuthoritySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByPrimaryAudioId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByRequiresLandContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctBySchemaVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProtocolMetadata, ProtocolMetadata, QAfterDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }
}

extension ProtocolMetadataQueryProperty1
    on QueryBuilder<ProtocolMetadata, ProtocolMetadata, QProperty> {
  QueryBuilder<ProtocolMetadata, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ProtocolMetadata, String, QAfterProperty> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ProtocolMetadata, String, QAfterProperty> protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ProtocolMetadata, bool, QAfterProperty> sacredFlagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ProtocolMetadata, List<String>, QAfterProperty>
      clanScopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ProtocolMetadata, int, QAfterProperty> visibleToTiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ProtocolMetadata, String, QAfterProperty> speakerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ProtocolMetadata, bool, QAfterProperty> elderApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ProtocolMetadata, String, QAfterProperty>
      authoritySourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ProtocolMetadata, String?, QAfterProperty>
      primaryAudioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ProtocolMetadata, bool, QAfterProperty>
      requiresLandContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ProtocolMetadata, String, QAfterProperty>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ProtocolMetadata, DateTime, QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension ProtocolMetadataQueryProperty2<R>
    on QueryBuilder<ProtocolMetadata, R, QAfterProperty> {
  QueryBuilder<ProtocolMetadata, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String), QAfterProperty>
      recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String), QAfterProperty>
      protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, bool), QAfterProperty>
      sacredFlagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, List<String>), QAfterProperty>
      clanScopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, int), QAfterProperty>
      visibleToTiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String), QAfterProperty>
      speakerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, bool), QAfterProperty>
      elderApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String), QAfterProperty>
      authoritySourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String?), QAfterProperty>
      primaryAudioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, bool), QAfterProperty>
      requiresLandContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, String), QAfterProperty>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ProtocolMetadata, (R, DateTime), QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension ProtocolMetadataQueryProperty3<R1, R2>
    on QueryBuilder<ProtocolMetadata, (R1, R2), QAfterProperty> {
  QueryBuilder<ProtocolMetadata, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String), QOperations>
      recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String), QOperations>
      protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, bool), QOperations>
      sacredFlagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, List<String>), QOperations>
      clanScopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, int), QOperations>
      visibleToTiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String), QOperations>
      speakerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, bool), QOperations>
      elderApprovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String), QOperations>
      authoritySourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String?), QOperations>
      primaryAudioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, bool), QOperations>
      requiresLandContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, String), QOperations>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ProtocolMetadata, (R1, R2, DateTime), QOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetUserProfileMirrorCollection on Isar {
  IsarCollection<int, UserProfileMirror> get userProfileMirrors =>
      this.collection();
}

const UserProfileMirrorSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'UserProfileMirror',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'userId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'mode',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'clan',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'role',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'tier',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'encryptedPayload',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lastSyncedAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'elderOverride',
        type: IsarType.bool,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'userId',
        properties: [
          "userId",
        ],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, UserProfileMirror>(
    serialize: serializeUserProfileMirror,
    deserialize: deserializeUserProfileMirror,
    deserializeProperty: deserializeUserProfileMirrorProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeUserProfileMirror(IsarWriter writer, UserProfileMirror object) {
  IsarCore.writeString(writer, 1, object.userId);
  IsarCore.writeString(writer, 2, object.mode);
  IsarCore.writeString(writer, 3, object.clan);
  IsarCore.writeString(writer, 4, object.role);
  IsarCore.writeLong(writer, 5, object.tier);
  IsarCore.writeString(writer, 6, object.encryptedPayload);
  IsarCore.writeLong(
      writer, 7, object.lastSyncedAt.toUtc().microsecondsSinceEpoch);
  IsarCore.writeBool(writer, 8, object.elderOverride);
  return object.id;
}

@isarProtected
UserProfileMirror deserializeUserProfileMirror(IsarReader reader) {
  final object = UserProfileMirror();
  object.id = IsarCore.readId(reader);
  object.userId = IsarCore.readString(reader, 1) ?? '';
  object.mode = IsarCore.readString(reader, 2) ?? '';
  object.clan = IsarCore.readString(reader, 3) ?? '';
  object.role = IsarCore.readString(reader, 4) ?? '';
  object.tier = IsarCore.readLong(reader, 5);
  object.encryptedPayload = IsarCore.readString(reader, 6) ?? '';
  {
    final value = IsarCore.readLong(reader, 7);
    if (value == -9223372036854775808) {
      object.lastSyncedAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.lastSyncedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  object.elderOverride = IsarCore.readBool(reader, 8);
  return object;
}

@isarProtected
dynamic deserializeUserProfileMirrorProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      {
        final value = IsarCore.readLong(reader, 7);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 8:
      return IsarCore.readBool(reader, 8);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _UserProfileMirrorUpdate {
  bool call({
    required int id,
    String? userId,
    String? mode,
    String? clan,
    String? role,
    int? tier,
    String? encryptedPayload,
    DateTime? lastSyncedAt,
    bool? elderOverride,
  });
}

class _UserProfileMirrorUpdateImpl implements _UserProfileMirrorUpdate {
  const _UserProfileMirrorUpdateImpl(this.collection);

  final IsarCollection<int, UserProfileMirror> collection;

  @override
  bool call({
    required int id,
    Object? userId = ignore,
    Object? mode = ignore,
    Object? clan = ignore,
    Object? role = ignore,
    Object? tier = ignore,
    Object? encryptedPayload = ignore,
    Object? lastSyncedAt = ignore,
    Object? elderOverride = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (userId != ignore) 1: userId as String?,
          if (mode != ignore) 2: mode as String?,
          if (clan != ignore) 3: clan as String?,
          if (role != ignore) 4: role as String?,
          if (tier != ignore) 5: tier as int?,
          if (encryptedPayload != ignore) 6: encryptedPayload as String?,
          if (lastSyncedAt != ignore) 7: lastSyncedAt as DateTime?,
          if (elderOverride != ignore) 8: elderOverride as bool?,
        }) >
        0;
  }
}

sealed class _UserProfileMirrorUpdateAll {
  int call({
    required List<int> id,
    String? userId,
    String? mode,
    String? clan,
    String? role,
    int? tier,
    String? encryptedPayload,
    DateTime? lastSyncedAt,
    bool? elderOverride,
  });
}

class _UserProfileMirrorUpdateAllImpl implements _UserProfileMirrorUpdateAll {
  const _UserProfileMirrorUpdateAllImpl(this.collection);

  final IsarCollection<int, UserProfileMirror> collection;

  @override
  int call({
    required List<int> id,
    Object? userId = ignore,
    Object? mode = ignore,
    Object? clan = ignore,
    Object? role = ignore,
    Object? tier = ignore,
    Object? encryptedPayload = ignore,
    Object? lastSyncedAt = ignore,
    Object? elderOverride = ignore,
  }) {
    return collection.updateProperties(id, {
      if (userId != ignore) 1: userId as String?,
      if (mode != ignore) 2: mode as String?,
      if (clan != ignore) 3: clan as String?,
      if (role != ignore) 4: role as String?,
      if (tier != ignore) 5: tier as int?,
      if (encryptedPayload != ignore) 6: encryptedPayload as String?,
      if (lastSyncedAt != ignore) 7: lastSyncedAt as DateTime?,
      if (elderOverride != ignore) 8: elderOverride as bool?,
    });
  }
}

extension UserProfileMirrorUpdate on IsarCollection<int, UserProfileMirror> {
  _UserProfileMirrorUpdate get update => _UserProfileMirrorUpdateImpl(this);

  _UserProfileMirrorUpdateAll get updateAll =>
      _UserProfileMirrorUpdateAllImpl(this);
}

sealed class _UserProfileMirrorQueryUpdate {
  int call({
    String? userId,
    String? mode,
    String? clan,
    String? role,
    int? tier,
    String? encryptedPayload,
    DateTime? lastSyncedAt,
    bool? elderOverride,
  });
}

class _UserProfileMirrorQueryUpdateImpl
    implements _UserProfileMirrorQueryUpdate {
  const _UserProfileMirrorQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<UserProfileMirror> query;
  final int? limit;

  @override
  int call({
    Object? userId = ignore,
    Object? mode = ignore,
    Object? clan = ignore,
    Object? role = ignore,
    Object? tier = ignore,
    Object? encryptedPayload = ignore,
    Object? lastSyncedAt = ignore,
    Object? elderOverride = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (userId != ignore) 1: userId as String?,
      if (mode != ignore) 2: mode as String?,
      if (clan != ignore) 3: clan as String?,
      if (role != ignore) 4: role as String?,
      if (tier != ignore) 5: tier as int?,
      if (encryptedPayload != ignore) 6: encryptedPayload as String?,
      if (lastSyncedAt != ignore) 7: lastSyncedAt as DateTime?,
      if (elderOverride != ignore) 8: elderOverride as bool?,
    });
  }
}

extension UserProfileMirrorQueryUpdate on IsarQuery<UserProfileMirror> {
  _UserProfileMirrorQueryUpdate get updateFirst =>
      _UserProfileMirrorQueryUpdateImpl(this, limit: 1);

  _UserProfileMirrorQueryUpdate get updateAll =>
      _UserProfileMirrorQueryUpdateImpl(this);
}

class _UserProfileMirrorQueryBuilderUpdateImpl
    implements _UserProfileMirrorQueryUpdate {
  const _UserProfileMirrorQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<UserProfileMirror, UserProfileMirror, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? userId = ignore,
    Object? mode = ignore,
    Object? clan = ignore,
    Object? role = ignore,
    Object? tier = ignore,
    Object? encryptedPayload = ignore,
    Object? lastSyncedAt = ignore,
    Object? elderOverride = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (userId != ignore) 1: userId as String?,
        if (mode != ignore) 2: mode as String?,
        if (clan != ignore) 3: clan as String?,
        if (role != ignore) 4: role as String?,
        if (tier != ignore) 5: tier as int?,
        if (encryptedPayload != ignore) 6: encryptedPayload as String?,
        if (lastSyncedAt != ignore) 7: lastSyncedAt as DateTime?,
        if (elderOverride != ignore) 8: elderOverride as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension UserProfileMirrorQueryBuilderUpdate
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QOperations> {
  _UserProfileMirrorQueryUpdate get updateFirst =>
      _UserProfileMirrorQueryBuilderUpdateImpl(this, limit: 1);

  _UserProfileMirrorQueryUpdate get updateAll =>
      _UserProfileMirrorQueryBuilderUpdateImpl(this);
}

extension UserProfileMirrorQueryFilter
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QFilterCondition> {
  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      modeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      clanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      tierBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      encryptedPayloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterFilterCondition>
      elderOverrideEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }
}

extension UserProfileMirrorQueryObject
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QFilterCondition> {}

extension UserProfileMirrorQuerySortBy
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QSortBy> {
  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> sortByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByUserIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> sortByMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByModeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> sortByClan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByClanDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> sortByRole(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByRoleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByEncryptedPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByEncryptedPayloadDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByElderOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      sortByElderOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension UserProfileMirrorQuerySortThenBy
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QSortThenBy> {
  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> thenByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByUserIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> thenByMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByModeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> thenByClan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByClanDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy> thenByRole(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByRoleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByTierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByEncryptedPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByEncryptedPayloadDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByElderOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterSortBy>
      thenByElderOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension UserProfileMirrorQueryWhereDistinct
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QDistinct> {
  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByClan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByRole({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByTier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByEncryptedPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<UserProfileMirror, UserProfileMirror, QAfterDistinct>
      distinctByElderOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }
}

extension UserProfileMirrorQueryProperty1
    on QueryBuilder<UserProfileMirror, UserProfileMirror, QProperty> {
  QueryBuilder<UserProfileMirror, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserProfileMirror, String, QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserProfileMirror, String, QAfterProperty> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserProfileMirror, String, QAfterProperty> clanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserProfileMirror, String, QAfterProperty> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserProfileMirror, int, QAfterProperty> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UserProfileMirror, String, QAfterProperty>
      encryptedPayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UserProfileMirror, DateTime, QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UserProfileMirror, bool, QAfterProperty>
      elderOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension UserProfileMirrorQueryProperty2<R>
    on QueryBuilder<UserProfileMirror, R, QAfterProperty> {
  QueryBuilder<UserProfileMirror, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserProfileMirror, (R, String), QAfterProperty>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserProfileMirror, (R, String), QAfterProperty> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserProfileMirror, (R, String), QAfterProperty> clanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserProfileMirror, (R, String), QAfterProperty> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserProfileMirror, (R, int), QAfterProperty> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UserProfileMirror, (R, String), QAfterProperty>
      encryptedPayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UserProfileMirror, (R, DateTime), QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UserProfileMirror, (R, bool), QAfterProperty>
      elderOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension UserProfileMirrorQueryProperty3<R1, R2>
    on QueryBuilder<UserProfileMirror, (R1, R2), QAfterProperty> {
  QueryBuilder<UserProfileMirror, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, String), QOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, String), QOperations>
      modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, String), QOperations>
      clanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, String), QOperations>
      roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, int), QOperations> tierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, String), QOperations>
      encryptedPayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, DateTime), QOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<UserProfileMirror, (R1, R2, bool), QOperations>
      elderOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetUserMasteryMirrorCollection on Isar {
  IsarCollection<int, UserMasteryMirror> get userMasteryMirrors =>
      this.collection();
}

const UserMasteryMirrorSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'UserMasteryMirror',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'userId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'canonicalStage',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'wordCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'modeProgressJson',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lastSyncedAt',
        type: IsarType.dateTime,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'userId',
        properties: [
          "userId",
        ],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, UserMasteryMirror>(
    serialize: serializeUserMasteryMirror,
    deserialize: deserializeUserMasteryMirror,
    deserializeProperty: deserializeUserMasteryMirrorProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeUserMasteryMirror(IsarWriter writer, UserMasteryMirror object) {
  IsarCore.writeString(writer, 1, object.userId);
  IsarCore.writeString(writer, 2, object.canonicalStage);
  IsarCore.writeLong(writer, 3, object.wordCount);
  IsarCore.writeString(writer, 4, object.modeProgressJson);
  IsarCore.writeLong(
      writer, 5, object.lastSyncedAt.toUtc().microsecondsSinceEpoch);
  return object.id;
}

@isarProtected
UserMasteryMirror deserializeUserMasteryMirror(IsarReader reader) {
  final object = UserMasteryMirror();
  object.id = IsarCore.readId(reader);
  object.userId = IsarCore.readString(reader, 1) ?? '';
  object.canonicalStage = IsarCore.readString(reader, 2) ?? '';
  object.wordCount = IsarCore.readLong(reader, 3);
  object.modeProgressJson = IsarCore.readString(reader, 4) ?? '';
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      object.lastSyncedAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.lastSyncedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeUserMasteryMirrorProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readLong(reader, 3);
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _UserMasteryMirrorUpdate {
  bool call({
    required int id,
    String? userId,
    String? canonicalStage,
    int? wordCount,
    String? modeProgressJson,
    DateTime? lastSyncedAt,
  });
}

class _UserMasteryMirrorUpdateImpl implements _UserMasteryMirrorUpdate {
  const _UserMasteryMirrorUpdateImpl(this.collection);

  final IsarCollection<int, UserMasteryMirror> collection;

  @override
  bool call({
    required int id,
    Object? userId = ignore,
    Object? canonicalStage = ignore,
    Object? wordCount = ignore,
    Object? modeProgressJson = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (userId != ignore) 1: userId as String?,
          if (canonicalStage != ignore) 2: canonicalStage as String?,
          if (wordCount != ignore) 3: wordCount as int?,
          if (modeProgressJson != ignore) 4: modeProgressJson as String?,
          if (lastSyncedAt != ignore) 5: lastSyncedAt as DateTime?,
        }) >
        0;
  }
}

sealed class _UserMasteryMirrorUpdateAll {
  int call({
    required List<int> id,
    String? userId,
    String? canonicalStage,
    int? wordCount,
    String? modeProgressJson,
    DateTime? lastSyncedAt,
  });
}

class _UserMasteryMirrorUpdateAllImpl implements _UserMasteryMirrorUpdateAll {
  const _UserMasteryMirrorUpdateAllImpl(this.collection);

  final IsarCollection<int, UserMasteryMirror> collection;

  @override
  int call({
    required List<int> id,
    Object? userId = ignore,
    Object? canonicalStage = ignore,
    Object? wordCount = ignore,
    Object? modeProgressJson = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (userId != ignore) 1: userId as String?,
      if (canonicalStage != ignore) 2: canonicalStage as String?,
      if (wordCount != ignore) 3: wordCount as int?,
      if (modeProgressJson != ignore) 4: modeProgressJson as String?,
      if (lastSyncedAt != ignore) 5: lastSyncedAt as DateTime?,
    });
  }
}

extension UserMasteryMirrorUpdate on IsarCollection<int, UserMasteryMirror> {
  _UserMasteryMirrorUpdate get update => _UserMasteryMirrorUpdateImpl(this);

  _UserMasteryMirrorUpdateAll get updateAll =>
      _UserMasteryMirrorUpdateAllImpl(this);
}

sealed class _UserMasteryMirrorQueryUpdate {
  int call({
    String? userId,
    String? canonicalStage,
    int? wordCount,
    String? modeProgressJson,
    DateTime? lastSyncedAt,
  });
}

class _UserMasteryMirrorQueryUpdateImpl
    implements _UserMasteryMirrorQueryUpdate {
  const _UserMasteryMirrorQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<UserMasteryMirror> query;
  final int? limit;

  @override
  int call({
    Object? userId = ignore,
    Object? canonicalStage = ignore,
    Object? wordCount = ignore,
    Object? modeProgressJson = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (userId != ignore) 1: userId as String?,
      if (canonicalStage != ignore) 2: canonicalStage as String?,
      if (wordCount != ignore) 3: wordCount as int?,
      if (modeProgressJson != ignore) 4: modeProgressJson as String?,
      if (lastSyncedAt != ignore) 5: lastSyncedAt as DateTime?,
    });
  }
}

extension UserMasteryMirrorQueryUpdate on IsarQuery<UserMasteryMirror> {
  _UserMasteryMirrorQueryUpdate get updateFirst =>
      _UserMasteryMirrorQueryUpdateImpl(this, limit: 1);

  _UserMasteryMirrorQueryUpdate get updateAll =>
      _UserMasteryMirrorQueryUpdateImpl(this);
}

class _UserMasteryMirrorQueryBuilderUpdateImpl
    implements _UserMasteryMirrorQueryUpdate {
  const _UserMasteryMirrorQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<UserMasteryMirror, UserMasteryMirror, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? userId = ignore,
    Object? canonicalStage = ignore,
    Object? wordCount = ignore,
    Object? modeProgressJson = ignore,
    Object? lastSyncedAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (userId != ignore) 1: userId as String?,
        if (canonicalStage != ignore) 2: canonicalStage as String?,
        if (wordCount != ignore) 3: wordCount as int?,
        if (modeProgressJson != ignore) 4: modeProgressJson as String?,
        if (lastSyncedAt != ignore) 5: lastSyncedAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension UserMasteryMirrorQueryBuilderUpdate
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QOperations> {
  _UserMasteryMirrorQueryUpdate get updateFirst =>
      _UserMasteryMirrorQueryBuilderUpdateImpl(this, limit: 1);

  _UserMasteryMirrorQueryUpdate get updateAll =>
      _UserMasteryMirrorQueryBuilderUpdateImpl(this);
}

extension UserMasteryMirrorQueryFilter
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QFilterCondition> {
  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      canonicalStageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      wordCountBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      modeProgressJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension UserMasteryMirrorQueryObject
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QFilterCondition> {}

extension UserMasteryMirrorQuerySortBy
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QSortBy> {
  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy> sortByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByUserIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByCanonicalStage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByCanonicalStageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByModeProgressJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByModeProgressJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }
}

extension UserMasteryMirrorQuerySortThenBy
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QSortThenBy> {
  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy> thenByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByUserIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByCanonicalStage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByCanonicalStageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByModeProgressJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByModeProgressJsonDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }
}

extension UserMasteryMirrorQueryWhereDistinct
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QDistinct> {
  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterDistinct>
      distinctByCanonicalStage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterDistinct>
      distinctByWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterDistinct>
      distinctByModeProgressJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserMasteryMirror, UserMasteryMirror, QAfterDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }
}

extension UserMasteryMirrorQueryProperty1
    on QueryBuilder<UserMasteryMirror, UserMasteryMirror, QProperty> {
  QueryBuilder<UserMasteryMirror, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserMasteryMirror, String, QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserMasteryMirror, String, QAfterProperty>
      canonicalStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserMasteryMirror, int, QAfterProperty> wordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserMasteryMirror, String, QAfterProperty>
      modeProgressJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserMasteryMirror, DateTime, QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension UserMasteryMirrorQueryProperty2<R>
    on QueryBuilder<UserMasteryMirror, R, QAfterProperty> {
  QueryBuilder<UserMasteryMirror, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserMasteryMirror, (R, String), QAfterProperty>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserMasteryMirror, (R, String), QAfterProperty>
      canonicalStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserMasteryMirror, (R, int), QAfterProperty>
      wordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserMasteryMirror, (R, String), QAfterProperty>
      modeProgressJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserMasteryMirror, (R, DateTime), QAfterProperty>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension UserMasteryMirrorQueryProperty3<R1, R2>
    on QueryBuilder<UserMasteryMirror, (R1, R2), QAfterProperty> {
  QueryBuilder<UserMasteryMirror, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<UserMasteryMirror, (R1, R2, String), QOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<UserMasteryMirror, (R1, R2, String), QOperations>
      canonicalStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<UserMasteryMirror, (R1, R2, int), QOperations>
      wordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<UserMasteryMirror, (R1, R2, String), QOperations>
      modeProgressJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<UserMasteryMirror, (R1, R2, DateTime), QOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetIsarAuditLogEntryCollection on Isar {
  IsarCollection<int, IsarAuditLogEntry> get isarAuditLogEntrys =>
      this.collection();
}

const IsarAuditLogEntrySchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'IsarAuditLogEntry',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'timestamp',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'protocolId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'operation',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'outcome',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'payloadSummary',
        type: IsarType.string,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'timestamp',
        properties: [
          "timestamp",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, IsarAuditLogEntry>(
    serialize: serializeIsarAuditLogEntry,
    deserialize: deserializeIsarAuditLogEntry,
    deserializeProperty: deserializeIsarAuditLogEntryProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeIsarAuditLogEntry(IsarWriter writer, IsarAuditLogEntry object) {
  IsarCore.writeLong(
      writer, 1, object.timestamp.toUtc().microsecondsSinceEpoch);
  IsarCore.writeString(writer, 2, object.protocolId);
  IsarCore.writeString(writer, 3, object.operation);
  IsarCore.writeString(writer, 4, object.outcome);
  {
    final value = object.payloadSummary;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  return object.id;
}

@isarProtected
IsarAuditLogEntry deserializeIsarAuditLogEntry(IsarReader reader) {
  final object = IsarAuditLogEntry();
  object.id = IsarCore.readId(reader);
  {
    final value = IsarCore.readLong(reader, 1);
    if (value == -9223372036854775808) {
      object.timestamp =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.timestamp =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  object.protocolId = IsarCore.readString(reader, 2) ?? '';
  object.operation = IsarCore.readString(reader, 3) ?? '';
  object.outcome = IsarCore.readString(reader, 4) ?? '';
  object.payloadSummary = IsarCore.readString(reader, 5);
  return object;
}

@isarProtected
dynamic deserializeIsarAuditLogEntryProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      {
        final value = IsarCore.readLong(reader, 1);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readString(reader, 5);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _IsarAuditLogEntryUpdate {
  bool call({
    required int id,
    DateTime? timestamp,
    String? protocolId,
    String? operation,
    String? outcome,
    String? payloadSummary,
  });
}

class _IsarAuditLogEntryUpdateImpl implements _IsarAuditLogEntryUpdate {
  const _IsarAuditLogEntryUpdateImpl(this.collection);

  final IsarCollection<int, IsarAuditLogEntry> collection;

  @override
  bool call({
    required int id,
    Object? timestamp = ignore,
    Object? protocolId = ignore,
    Object? operation = ignore,
    Object? outcome = ignore,
    Object? payloadSummary = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (timestamp != ignore) 1: timestamp as DateTime?,
          if (protocolId != ignore) 2: protocolId as String?,
          if (operation != ignore) 3: operation as String?,
          if (outcome != ignore) 4: outcome as String?,
          if (payloadSummary != ignore) 5: payloadSummary as String?,
        }) >
        0;
  }
}

sealed class _IsarAuditLogEntryUpdateAll {
  int call({
    required List<int> id,
    DateTime? timestamp,
    String? protocolId,
    String? operation,
    String? outcome,
    String? payloadSummary,
  });
}

class _IsarAuditLogEntryUpdateAllImpl implements _IsarAuditLogEntryUpdateAll {
  const _IsarAuditLogEntryUpdateAllImpl(this.collection);

  final IsarCollection<int, IsarAuditLogEntry> collection;

  @override
  int call({
    required List<int> id,
    Object? timestamp = ignore,
    Object? protocolId = ignore,
    Object? operation = ignore,
    Object? outcome = ignore,
    Object? payloadSummary = ignore,
  }) {
    return collection.updateProperties(id, {
      if (timestamp != ignore) 1: timestamp as DateTime?,
      if (protocolId != ignore) 2: protocolId as String?,
      if (operation != ignore) 3: operation as String?,
      if (outcome != ignore) 4: outcome as String?,
      if (payloadSummary != ignore) 5: payloadSummary as String?,
    });
  }
}

extension IsarAuditLogEntryUpdate on IsarCollection<int, IsarAuditLogEntry> {
  _IsarAuditLogEntryUpdate get update => _IsarAuditLogEntryUpdateImpl(this);

  _IsarAuditLogEntryUpdateAll get updateAll =>
      _IsarAuditLogEntryUpdateAllImpl(this);
}

sealed class _IsarAuditLogEntryQueryUpdate {
  int call({
    DateTime? timestamp,
    String? protocolId,
    String? operation,
    String? outcome,
    String? payloadSummary,
  });
}

class _IsarAuditLogEntryQueryUpdateImpl
    implements _IsarAuditLogEntryQueryUpdate {
  const _IsarAuditLogEntryQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<IsarAuditLogEntry> query;
  final int? limit;

  @override
  int call({
    Object? timestamp = ignore,
    Object? protocolId = ignore,
    Object? operation = ignore,
    Object? outcome = ignore,
    Object? payloadSummary = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (timestamp != ignore) 1: timestamp as DateTime?,
      if (protocolId != ignore) 2: protocolId as String?,
      if (operation != ignore) 3: operation as String?,
      if (outcome != ignore) 4: outcome as String?,
      if (payloadSummary != ignore) 5: payloadSummary as String?,
    });
  }
}

extension IsarAuditLogEntryQueryUpdate on IsarQuery<IsarAuditLogEntry> {
  _IsarAuditLogEntryQueryUpdate get updateFirst =>
      _IsarAuditLogEntryQueryUpdateImpl(this, limit: 1);

  _IsarAuditLogEntryQueryUpdate get updateAll =>
      _IsarAuditLogEntryQueryUpdateImpl(this);
}

class _IsarAuditLogEntryQueryBuilderUpdateImpl
    implements _IsarAuditLogEntryQueryUpdate {
  const _IsarAuditLogEntryQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? timestamp = ignore,
    Object? protocolId = ignore,
    Object? operation = ignore,
    Object? outcome = ignore,
    Object? payloadSummary = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (timestamp != ignore) 1: timestamp as DateTime?,
        if (protocolId != ignore) 2: protocolId as String?,
        if (operation != ignore) 3: operation as String?,
        if (outcome != ignore) 4: outcome as String?,
        if (payloadSummary != ignore) 5: payloadSummary as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension IsarAuditLogEntryQueryBuilderUpdate
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QOperations> {
  _IsarAuditLogEntryQueryUpdate get updateFirst =>
      _IsarAuditLogEntryQueryBuilderUpdateImpl(this, limit: 1);

  _IsarAuditLogEntryQueryUpdate get updateAll =>
      _IsarAuditLogEntryQueryBuilderUpdateImpl(this);
}

extension IsarAuditLogEntryQueryFilter
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QFilterCondition> {
  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      protocolIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      operationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      outcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterFilterCondition>
      payloadSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }
}

extension IsarAuditLogEntryQueryObject
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QFilterCondition> {}

extension IsarAuditLogEntryQuerySortBy
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QSortBy> {
  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByProtocolIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByOperation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByOperationDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByOutcome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByOutcomeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByPayloadSummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      sortByPayloadSummaryDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension IsarAuditLogEntryQuerySortThenBy
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QSortThenBy> {
  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByProtocolIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByOperation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByOperationDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByOutcome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByOutcomeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByPayloadSummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterSortBy>
      thenByPayloadSummaryDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension IsarAuditLogEntryQueryWhereDistinct
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QDistinct> {
  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterDistinct>
      distinctByProtocolId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterDistinct>
      distinctByOperation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterDistinct>
      distinctByOutcome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QAfterDistinct>
      distinctByPayloadSummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }
}

extension IsarAuditLogEntryQueryProperty1
    on QueryBuilder<IsarAuditLogEntry, IsarAuditLogEntry, QProperty> {
  QueryBuilder<IsarAuditLogEntry, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<IsarAuditLogEntry, DateTime, QAfterProperty>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, String, QAfterProperty> protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<IsarAuditLogEntry, String, QAfterProperty> operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<IsarAuditLogEntry, String, QAfterProperty> outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<IsarAuditLogEntry, String?, QAfterProperty>
      payloadSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension IsarAuditLogEntryQueryProperty2<R>
    on QueryBuilder<IsarAuditLogEntry, R, QAfterProperty> {
  QueryBuilder<IsarAuditLogEntry, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R, DateTime), QAfterProperty>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R, String), QAfterProperty>
      protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R, String), QAfterProperty>
      operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R, String), QAfterProperty>
      outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R, String?), QAfterProperty>
      payloadSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension IsarAuditLogEntryQueryProperty3<R1, R2>
    on QueryBuilder<IsarAuditLogEntry, (R1, R2), QAfterProperty> {
  QueryBuilder<IsarAuditLogEntry, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R1, R2, DateTime), QOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R1, R2, String), QOperations>
      protocolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R1, R2, String), QOperations>
      operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R1, R2, String), QOperations>
      outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<IsarAuditLogEntry, (R1, R2, String?), QOperations>
      payloadSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}
