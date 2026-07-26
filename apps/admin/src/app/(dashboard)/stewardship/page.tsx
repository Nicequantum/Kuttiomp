import { Header } from "@/components/layout/header";
import { ContinuityPanelLive } from "@/components/stewardship/continuity-panel-live";

/**
 * Knowledge Keeper stewardship surface — live RPC primary, offline absolute fallback.
 */
export default function StewardshipPage() {
  return (
    <>
      <Header
        title="Corpus Stewardship"
        description="Absolute contribution counts for speakers — service to the living language, never a game."
      />
      <div className="space-y-6 p-8">
        <ContinuityPanelLive />
        <p className="max-w-3xl text-sm leading-relaxed text-stone-600">
          Apply{" "}
          <code className="rounded bg-stone-100 px-1">
            supabase/migrations/005_stewardship_continuity_views.sql
          </code>{" "}
          so live RPCs{" "}
          <code className="rounded bg-stone-100 px-1">speaker_stewardship_summary</code> and{" "}
          <code className="rounded bg-stone-100 px-1">corpus_continuity_metrics</code> are
          available. Until then, absolute offline counts are shown. Target lexicon size is
          not configured — Keepers must define it before any continuity percentage appears.
          See <code className="rounded bg-stone-100 px-1">docs/MIGRATION_005_APPLY.md</code>.
        </p>
      </div>
    </>
  );
}