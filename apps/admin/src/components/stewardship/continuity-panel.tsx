"use client";

/**
 * Continuity / Stewardship panel — Protocol 10 absolute (no gamification).
 * Mode-themed via CSS variables from ModeThemeProvider.
 */

export type ContinuityMetrics = {
  total_approved_lexemes: number;
  last_approved_at: string | null;
  /** null until Keepers define a target — never invent */
  target_lexemes: number | null;
  continuity_pct: number | null;
};

export type SpeakerStewardship = {
  speaker_id: string;
  speaker_display_name: string;
  submitted_count: number;
  pending_approval_count: number;
  approved_living_count: number;
  primary_audio_count: number;
  approval_status_note: string;
};

type Props = {
  corpus: ContinuityMetrics;
  speaker?: SpeakerStewardship | null;
};

export function ContinuityPanel({ corpus, speaker }: Props) {
  const hasTarget =
    corpus.target_lexemes != null &&
    corpus.target_lexemes > 0 &&
    corpus.continuity_pct != null;

  return (
    <section
      aria-label="Corpus stewardship continuity"
      className="mode-stewardship-panel"
    >
      <h2
        className="font-serif font-semibold text-foreground"
        style={{ fontSize: "var(--mode-font-title)" }}
      >
        Corpus Stewardship
      </h2>
      <p
        className="mt-2 leading-relaxed text-foreground"
        style={{ fontSize: "var(--mode-font-content)" }}
      >
        Your attributed contributions strengthen the living language for the
        generations.
      </p>

      {speaker ? (
        <div
          className="mt-4 space-y-1 text-foreground"
          style={{ fontSize: "var(--mode-font-content)" }}
        >
          <p>
            <span className="font-medium">Speaker attribution:</span>{" "}
            {speaker.speaker_display_name} ({speaker.speaker_id})
          </p>
          <p>
            <span className="font-medium">Approval status:</span>{" "}
            {speaker.approval_status_note}
          </p>
          <ul className="mt-3 list-none space-y-2 border-t border-border pt-3">
            <li className="flex justify-between gap-4">
              <span>Submitted</span>
              <strong className="tabular-nums">{speaker.submitted_count}</strong>
            </li>
            <li className="flex justify-between gap-4">
              <span>Pending elder review</span>
              <strong className="tabular-nums">
                {speaker.pending_approval_count}
              </strong>
            </li>
            <li className="flex justify-between gap-4">
              <span>Approved living</span>
              <strong className="tabular-nums">
                {speaker.approved_living_count}
              </strong>
            </li>
            <li className="flex justify-between gap-4">
              <span>Primary audio attributions</span>
              <strong className="tabular-nums">
                {speaker.primary_audio_count}
              </strong>
            </li>
          </ul>
        </div>
      ) : null}

      <div className="mt-6 border-t border-border pt-4">
        <h3
          className="font-semibold text-foreground"
          style={{ fontSize: "var(--mode-font-body)" }}
        >
          Living corpus (absolute)
        </h3>
        <p
          className="mt-2 flex justify-between gap-4 text-foreground"
          style={{ fontSize: "var(--mode-font-content)" }}
        >
          <span>Approved lexemes (non-sacred)</span>
          <strong className="tabular-nums">
            {corpus.total_approved_lexemes}
          </strong>
        </p>
        {corpus.last_approved_at ? (
          <p
            className="mt-1 text-muted-foreground"
            style={{ fontSize: "var(--mode-font-body)" }}
          >
            Last approved: {new Date(corpus.last_approved_at).toLocaleString()}
          </p>
        ) : null}

        {hasTarget ? (
          <div className="mt-4">
            <div
              className="h-3 w-full overflow-hidden rounded-none bg-muted"
              role="progressbar"
              aria-valuenow={Math.round((corpus.continuity_pct ?? 0) * 100)}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-label="Progress toward Keeper-defined lexicon target"
            >
              <div
                className="h-full bg-primary"
                style={{
                  width: `${Math.min(100, Math.max(0, (corpus.continuity_pct ?? 0) * 100))}%`,
                }}
              />
            </div>
            <p
              className="mt-2 text-foreground"
              style={{ fontSize: "var(--mode-font-body)" }}
            >
              Toward Keeper-defined target: {corpus.target_lexemes}
            </p>
          </div>
        ) : (
          <p
            className="mt-3 text-foreground"
            style={{ fontSize: "var(--mode-font-content)" }}
          >
            No Keeper-defined lexicon target is configured. Absolute counts only
            are shown. Priority domains and target size must be supplied by
            Keepers before continuity percentage can appear.
          </p>
        )}
      </div>
    </section>
  );
}

/** Offline / walkthrough sample — protocol-compliant absolute counts only. */
export const SAMPLE_CORPUS_METRICS: ContinuityMetrics = {
  total_approved_lexemes: 4,
  last_approved_at: null,
  target_lexemes: null,
  continuity_pct: null,
};

export const SAMPLE_SPEAKER_STEWARDSHIP: SpeakerStewardship = {
  speaker_id: "b0000000-0000-0000-0000-000000000001",
  speaker_display_name: "Grandmother Comus",
  submitted_count: 3,
  pending_approval_count: 0,
  approved_living_count: 3,
  primary_audio_count: 3,
  approval_status_note:
    "Living counts include elder-approved, non-sacred entries only (Protocol 2, 4).",
};
