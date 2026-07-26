import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/isar_database.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';

/// Protocol 9 – wraps Supabase; only RPCs/views, never direct tables.
class AuditedSupabaseClient {
  AuditedSupabaseClient(this._client);

  final SupabaseClient _client;
  bool _initialized = false;

  static AuditedSupabaseClient? _singleton;

  SupabaseClient get rawClient => _client;
  bool get isInitialized => _initialized;

  /// Initializes audited handshake with protocol assertions (Component 2).
  static Future<AuditedSupabaseClient> initialize({
    required SupabaseClient client,
  }) async {
    KuttiompProtocolService.instance.assertDataSovereignty(
      context: const {'direct_table_access': false},
    );

    for (final rpc in KuttiompRpc.all) {
      KuttiompProtocolService.instance.assertCompliant(
        KuttiompProtocol.dataSovereignty.id,
        context: {'allowed_rpc': rpc},
      );
    }

    final audited = AuditedSupabaseClient(client);
    await audited._logToIsarAudit(
      operation: 'initialize',
      outcome: 'Audited connection established | Protocol 9 active | Offline mirror ready',
    );
    audited._initialized = true;
    _singleton = audited;
    return audited;
  }

  static AuditedSupabaseClient? get instance => _singleton;

  Future<T> rpc<T>(
    String rpcName, {
    Map<String, dynamic> params = const {},
  }) async {
    if (!KuttiompRpc.all.contains(rpcName)) {
      KuttiompProtocolService.instance.assertDataSovereignty(
        context: const {'direct_table_access': true},
      );
    }

    KuttiompProtocolService.instance.assertDataSovereignty(
      context: const {'direct_table_access': false},
    );

    final safeParams = {...params, 'elderApproved': params['elderApproved'] ?? true};

    try {
      final result = await _client.rpc(rpcName, params: safeParams);
      await _logToIsarAudit(
        operation: 'rpc:$rpcName',
        outcome: 'success',
        payloadSummary: safeParams.keys.join(','),
      );
      return result as T;
    } catch (e) {
      await _logToIsarAudit(
        operation: 'rpc:$rpcName',
        outcome: 'failure',
        payloadSummary: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> _logToIsarAudit({
    required String operation,
    required String outcome,
    String? payloadSummary,
  }) async {
    final entry = AuditLogEntry(
      timestamp: DateTime.now().toUtc(),
      protocolId: KuttiompProtocol.dataSovereignty.id,
      operation: operation,
      outcome: outcome,
      payloadSummary: payloadSummary,
    );

    await AuditLogStore.instance.log(entry);

    final isar = IsarDatabase.instance;
    if (isar != null && isar.isOpen) {
      final isarEntry = IsarAuditLogEntry()
        ..timestamp = entry.timestamp
        ..protocolId = entry.protocolId
        ..operation = entry.operation
        ..outcome = entry.outcome
        ..payloadSummary = entry.payloadSummary;
      await isar.writeAsync((isar) {
        final col = isar.isarAuditLogEntrys;
        if (isarEntry.id == 0) {
          isarEntry.id = col.autoIncrement();
        }
        col.put(isarEntry);
      });
    }
  }
}