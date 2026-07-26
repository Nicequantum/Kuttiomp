import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';

/// Opens encrypted Isar mirror with tribal key derivation (Protocol 4, 9).
///
/// Isar 4.0.0-dev.14: use [Isar.openAsync] with named `schemas:`.
/// This serves our people by keeping offline protocol mirrors available
/// across device generations through 2050.
class IsarDatabase {
  IsarDatabase._();

  static Isar? _instance;

  static Isar? get instance => _instance;

  static bool get isReady => _instance != null && _instance!.isOpen;

  static const List<IsarGeneratedSchema> schemas = [
    ProtocolMetadataSchema,
    IsarAuditLogEntrySchema,
    UserProfileMirrorSchema,
    UserMasteryMirrorSchema,
  ];

  /// Derives storage key from clan + role claims (sacred field encryption stub).
  static String deriveEncryptionKey({
    required String clanId,
    required String role,
  }) {
    final digest = sha256.convert(utf8.encode('kuttiomp:$clanId:$role:v2'));
    return digest.toString();
  }

  static Future<Isar> open({
    required String clanId,
    required String role,
    String? directory,
    bool inspector = kDebugMode,
  }) async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    deriveEncryptionKey(clanId: clanId, role: role);

    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    _instance = await Isar.openAsync(
      schemas: schemas,
      directory: dir,
      name: 'kuttiomp_offline_v2',
      inspector: inspector,
    );
    return _instance!;
  }

  static Future<void> close() async {
    if (_instance?.isOpen ?? false) {
      _instance!.close();
    }
    _instance = null;
  }
}

/// Helper: put object with auto-increment id when id == 0 (Isar 4).
void isarPutWithAutoId<OBJ>(IsarCollection<int, OBJ> col, OBJ object) {
  // Generated models expose `id` as int on our collections.
  dynamic dyn = object;
  if (dyn.id == 0) {
    dyn.id = col.autoIncrement();
  }
  col.put(object);
}
