/**
 * Live stewardship RPCs (migration 005) with absolute offline fallback.
 * Protocol 10: absolute counts only; never invent target_lexemes / continuity_pct.
 *
 * This serves our people by preferring living-database counts when available
 * while remaining usable offline for Keepers through 2050.
 */

import { supabase } from "@/lib/supabase";
import type {
  ContinuityMetrics,
  SpeakerStewardship,
} from "@/components/stewardship/continuity-panel";
import {
  SAMPLE_CORPUS_METRICS,
  SAMPLE_SPEAKER_STEWARDSHIP,
} from "@/components/stewardship/continuity-panel";

export type StewardshipFetchSource = "live_rpc" | "offline_fallback";

export type StewardshipBundle = {
  corpus: ContinuityMetrics;
  speaker: SpeakerStewardship;
  source: StewardshipFetchSource;
};

function forceNullTargets(metrics: ContinuityMetrics): ContinuityMetrics {
  return {
    total_approved_lexemes: metrics.total_approved_lexemes ?? 0,
    last_approved_at: metrics.last_approved_at ?? null,
    // Keepers have not defined a target — never invent.
    target_lexemes: null,
    continuity_pct: null,
  };
}

/**
 * Primary path: corpus_continuity_metrics + speaker_stewardship_summary.
 * Fallback: SAMPLE absolute counts when migration not applied or network fails.
 */
export async function fetchStewardshipBundle(options?: {
  speakerId?: string;
  speakerDisplayName?: string;
}): Promise<StewardshipBundle> {
  const speakerId =
    options?.speakerId ?? SAMPLE_SPEAKER_STEWARDSHIP.speaker_id;
  const speakerDisplayName =
    options?.speakerDisplayName ?? SAMPLE_SPEAKER_STEWARDSHIP.speaker_display_name;

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) {
    return {
      corpus: forceNullTargets(SAMPLE_CORPUS_METRICS),
      speaker: {
        ...SAMPLE_SPEAKER_STEWARDSHIP,
        speaker_id: speakerId,
        speaker_display_name: speakerDisplayName,
      },
      source: "offline_fallback",
    };
  }

  try {
    const [corpusRes, speakerRes] = await Promise.all([
      supabase.rpc("corpus_continuity_metrics"),
      supabase.rpc("speaker_stewardship_summary", {
        p_speaker_id: speakerId,
      }),
    ]);

    if (corpusRes.error || speakerRes.error) {
      return {
        corpus: forceNullTargets(SAMPLE_CORPUS_METRICS),
        speaker: {
          ...SAMPLE_SPEAKER_STEWARDSHIP,
          speaker_id: speakerId,
          speaker_display_name: speakerDisplayName,
        },
        source: "offline_fallback",
      };
    }

    const corpusRow = Array.isArray(corpusRes.data)
      ? corpusRes.data[0]
      : corpusRes.data;
    const speakerRow = Array.isArray(speakerRes.data)
      ? speakerRes.data[0]
      : speakerRes.data;

    const corpus = forceNullTargets({
      total_approved_lexemes: Number(corpusRow?.total_approved_lexemes ?? 0),
      last_approved_at: corpusRow?.last_approved_at ?? null,
      target_lexemes: null,
      continuity_pct: null,
    });

    const speaker: SpeakerStewardship = {
      speaker_id: String(speakerRow?.speaker_id ?? speakerId),
      speaker_display_name: speakerDisplayName,
      submitted_count: Number(speakerRow?.submitted_count ?? 0),
      pending_approval_count: Number(speakerRow?.pending_approval_count ?? 0),
      approved_living_count: Number(speakerRow?.approved_living_count ?? 0),
      primary_audio_count: Number(speakerRow?.primary_audio_count ?? 0),
      approval_status_note:
        "Living counts include elder-approved, non-sacred entries only (Protocol 2, 4).",
    };

    return { corpus, speaker, source: "live_rpc" };
  } catch {
    return {
      corpus: forceNullTargets(SAMPLE_CORPUS_METRICS),
      speaker: {
        ...SAMPLE_SPEAKER_STEWARDSHIP,
        speaker_id: speakerId,
        speaker_display_name: speakerDisplayName,
      },
      source: "offline_fallback",
    };
  }
}