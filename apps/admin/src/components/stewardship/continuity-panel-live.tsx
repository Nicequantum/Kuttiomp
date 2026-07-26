"use client";

import { useEffect, useState } from "react";
import {
  ContinuityPanel,
  SAMPLE_CORPUS_METRICS,
  SAMPLE_SPEAKER_STEWARDSHIP,
  type ContinuityMetrics,
  type SpeakerStewardship,
} from "@/components/stewardship/continuity-panel";
import {
  fetchStewardshipBundle,
  type StewardshipFetchSource,
} from "@/lib/stewardship-rpc";

/**
 * Live-primary Continuity panel: RPC first, absolute offline fallback second.
 * Protocol 10: no gamification; targets stay null.
 */
export function ContinuityPanelLive({
  speakerId,
  speakerDisplayName,
}: {
  speakerId?: string;
  speakerDisplayName?: string;
}) {
  const [corpus, setCorpus] = useState<ContinuityMetrics>(SAMPLE_CORPUS_METRICS);
  const [speaker, setSpeaker] = useState<SpeakerStewardship>(
    SAMPLE_SPEAKER_STEWARDSHIP
  );
  const [source, setSource] = useState<StewardshipFetchSource>("offline_fallback");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      const bundle = await fetchStewardshipBundle({
        speakerId,
        speakerDisplayName,
      });
      if (cancelled) return;
      setCorpus(bundle.corpus);
      setSpeaker(bundle.speaker);
      setSource(bundle.source);
      setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [speakerId, speakerDisplayName]);

  return (
    <div className="space-y-2">
      {loading ? (
        <p className="text-sm text-stone-600" role="status">
          Loading stewardship counts…
        </p>
      ) : (
        <p className="text-sm text-stone-600" role="status">
          Data source:{" "}
          <strong>
            {source === "live_rpc"
              ? "Live database (RPC after migration 005)"
              : "Offline absolute counts (migration not applied or network unavailable)"}
          </strong>
        </p>
      )}
      <ContinuityPanel corpus={corpus} speaker={speaker} />
    </div>
  );
}