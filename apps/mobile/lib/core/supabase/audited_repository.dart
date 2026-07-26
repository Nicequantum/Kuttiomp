import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';

/// Protocol 9 – base for all data repositories; RPC-only, fully audited (§3).
abstract class AuditedRepository {
  AuditedRepository({
    ProtocolGateway? gateway,
    AuditedSupabaseClient? auditedClient,
    KuttiompProtocolService? protocolService,
  })  : _gateway = gateway ?? ProtocolGateway(),
        _auditedClient = auditedClient,
        _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final ProtocolGateway _gateway;
  final AuditedSupabaseClient? _auditedClient;
  final KuttiompProtocolService _protocolService;

  ProtocolGateway get gateway => _gateway;

  /// Executes audited RPC with Protocol 9 enforcement.
  Future<T> auditedRpc<T>(
    String rpcName, {
    Map<String, dynamic> params = const {},
  }) async {
    _protocolService.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    if (!KuttiompRpc.all.contains(rpcName)) {
      _protocolService.assertDataSovereignty(
        context: const {'direct_table_access': true},
      );
    }

    final safeParams = _gateway.withElderApprovedFilter(params);
    final client = _auditedClient ?? AuditedSupabaseClient.instance;

    if (client == null || !client.isInitialized) {
      throw StateError('AuditedSupabaseClient not initialized');
    }

    return client.rpc<T>(rpcName, params: safeParams);
  }

  Future<void> logRepositoryOperation({
    required String operation,
    required String outcome,
    String? payloadSummary,
  }) async {
    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: KuttiompProtocol.dataSovereignty.id,
        operation: operation,
        outcome: outcome,
        payloadSummary: payloadSummary,
      ),
    );
  }
}