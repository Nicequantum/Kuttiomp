import { Header } from "@/components/layout/header";
import {
  ContinuityPanel,
  SAMPLE_CORPUS_METRICS,
  SAMPLE_SPEAKER_STEWARDSHIP,
} from "@/components/stewardship/continuity-panel";

/**
 * Knowledge Keeper stewardship surface — Stream D first increment.
 * RPC-backed data lands when migration 005 is applied; sample absolute
 * counts used for walkthrough until then.
 */
export default function StewardshipPage() {
  return (
    <>
      <Header
        title="Corpus Stewardship"
        description="Absolute contribution counts for speakers — service to the living language, never a game."
      />
      <div className="space-y-6 p-8">
        <ContinuityPanel
          corpus={SAMPLE_CORPUS_METRICS}
          speaker={SAMPLE_SPEAKER_STEWARDSHIP}
        />
        <p className="max-w-3xl text-sm leading-relaxed text-stone-600">
          Apply <code className="rounded bg-stone-100 px-1">supabase/migrations/005_stewardship_continuity_views.sql</code>{" "}
          to enable <code className="rounded bg-stone-100 px-1">speaker_stewardship_summary</code> and{" "}
          <code className="rounded bg-stone-100 px-1">corpus_continuity_metrics</code> RPCs. Target lexicon
          size is not configured — Keepers must define it before continuity percentage appears.
        </p>
      </div>
    </>
  );
}