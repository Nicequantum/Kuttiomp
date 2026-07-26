import 'package:flutter/foundation.dart';

/// Semantic keys for golden-lock and integration tests (§11).
abstract final class KuttiompTestKeys {
  static const contributePetal = Key('contribute_petal');
  static const wordField = Key('word_field');
  static const translationField = Key('translation_field');
  static const recordStub = Key('record_stub');
  static const submitSecure = Key('submit_secure');
  static const keeperApprove = Key('keeper_approve');
}