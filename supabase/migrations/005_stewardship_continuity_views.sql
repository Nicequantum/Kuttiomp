-- =============================================================================
-- Stream D – Corpus Stewardship Continuity (MAD v2.0, Protocols 1,2,9,10)
-- Absolute counts only. No scores, ranks, streaks, or gamification.
-- target_lexemes / continuity_pct are NULL until Keepers define a target.
-- This serves our people by making speaker labor visible as service through 2050.
-- =============================================================================

-- Speaker stewardship summary: derived from lexical_entries + audio only.
CREATE OR REPLACE FUNCTION speaker_stewardship_summary(p_speaker_id uuid)
RETURNS TABLE (
  speaker_id uuid,
  submitted_count bigint,
  pending_approval_count bigint,
  approved_living_count bigint,
  last_contribution_at timestamptz,
  primary_audio_count bigint
)
LANGUAGE sql
STABLE
SECURITY INVOKER
AS $$
  SELECT
    p_speaker_id AS speaker_id,
    (
      SELECT COUNT(*)::bigint
      FROM lexical_entries le
      WHERE le.primary_speaker_id = p_speaker_id
        AND COALESCE(le.is_sacred, false) = false
    ) AS submitted_count,
    (
      SELECT COUNT(*)::bigint
      FROM lexical_entries le
      WHERE le.primary_speaker_id = p_speaker_id
        AND le.approval_status IN ('pending', 'requires_elder_review', 'under_review', 'draft')
        AND COALESCE(le.is_sacred, false) = false
    ) AS pending_approval_count,
    (
      SELECT COUNT(*)::bigint
      FROM lexical_entries le
      WHERE le.primary_speaker_id = p_speaker_id
        AND le.approval_status = 'approved'
        AND COALESCE(le.is_sacred, false) = false
    ) AS approved_living_count,
    (
      SELECT MAX(COALESCE(le.updated_at, le.created_at))
      FROM lexical_entries le
      WHERE le.primary_speaker_id = p_speaker_id
        AND COALESCE(le.is_sacred, false) = false
    ) AS last_contribution_at,
    (
      SELECT COUNT(*)::bigint
      FROM audio_recordings ar
      WHERE ar.speaker_id = p_speaker_id
        AND ar.approval_status = 'approved'
        AND ar.lexical_entry_id IS NOT NULL
    ) AS primary_audio_count;
$$;

COMMENT ON FUNCTION speaker_stewardship_summary(uuid) IS
  'Protocol 10–safe absolute stewardship counts for a speaker. Excludes sacred rows.';

-- Corpus continuity: approved living lexemes only; no invented target.
CREATE OR REPLACE FUNCTION corpus_continuity_metrics()
RETURNS TABLE (
  total_approved_lexemes bigint,
  last_approved_at timestamptz,
  target_lexemes bigint,
  continuity_pct numeric
)
LANGUAGE sql
STABLE
SECURITY INVOKER
AS $$
  SELECT
    (
      SELECT COUNT(*)::bigint
      FROM lexical_entries le
      WHERE le.approval_status = 'approved'
        AND COALESCE(le.is_sacred, false) = false
    ) AS total_approved_lexemes,
    (
      SELECT MAX(COALESCE(le.approved_at, le.updated_at, le.created_at))
      FROM lexical_entries le
      WHERE le.approval_status = 'approved'
        AND COALESCE(le.is_sacred, false) = false
    ) AS last_approved_at,
    NULL::bigint AS target_lexemes,
    NULL::numeric AS continuity_pct;
$$;

COMMENT ON FUNCTION corpus_continuity_metrics() IS
  'Absolute approved living lexeme count. target_lexemes and continuity_pct are NULL until Keepers configure a target.';

-- Grant execute to authenticated roles used by admin / mobile (adjust per deploy).
GRANT EXECUTE ON FUNCTION speaker_stewardship_summary(uuid) TO authenticated, service_role, anon;
GRANT EXECUTE ON FUNCTION corpus_continuity_metrics() TO authenticated, service_role, anon;