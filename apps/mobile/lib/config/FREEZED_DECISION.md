# Freezed Decision — Ratified under MAD v2.0 (Protocol 12)

**Date:** 5 July 2026  
**Decision:** **Hand-written immutable models** are the official domain modeling approach for Kuttiomp mobile through 2050.

## Rationale

This serves our people by keeping domain models readable by a 3–5 person tribal team without requiring code-generation fluency or freezed version churn after 2028.

## Rules

1. Domain models use `@immutable` classes with explicit `copyWith`, `fromJson`, and equality by id.
2. Protocol fields remain plain Dart (no generated freezed unions required).
3. `shared/models/` may host shared freezed-equivalent models later; feature modules own their models under `domain/` today (lexeme: `lexeme_model.dart`).
4. If freezed is adopted later, it must:
   - Be pinned to a major track with ≥5-year support horizon (Protocol 12)
   - Ship generated files committed to the repo so CI does not depend on silent codegen
   - Not reduce one-hour onboarding for basic Dart maintainers

## Status

- freezed / freezed_annotation: **not** in `pubspec.yaml` (intentional)
- Lexeme, phrases, lessons, profile models: hand-written immutable

**(Protocol 12 compliance verified)**
