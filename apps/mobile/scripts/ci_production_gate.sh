#!/usr/bin/env bash
# Kuttiomp v2.3.0+1 — CI production gate (§11)
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== Kuttiomp Production Gate v2.3.0+1 ==="
flutter pub get
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
flutter test test/production/
flutter test test/features/
flutter test test/offline/
flutter test test/mode_consistency/
echo "=== Sovereign Production-Ready | All gates passed ==="