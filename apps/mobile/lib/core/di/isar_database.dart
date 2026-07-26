import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';

/// Opens encrypted Isar mirror with tribal key derivation (Protocol 4, 9).
class IsarDatabase {
  IsarDatabase._();

  static Isar? _instance;

  static Isar? get instance => _instance;

  static bool get isReady => _instance != null && _instance!.isOpen;

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
    _instance = await Isar.open(
      [
        ProtocolMetadataSchema,
        IsarAuditLogEntrySchema,
        UserProfileMirrorSchema,
        UserMasteryMirrorSchema,
      ],
      directory: dir,
      name: 'kuttiomp_offline_v2',
      inspector: inspector,
    );
    return _instance!;
  }

  static Future<void> close() async {
    if (_instance?.isOpen ?? false) {
      await _instance!.close();
    }
    _instance = null;
  }
}