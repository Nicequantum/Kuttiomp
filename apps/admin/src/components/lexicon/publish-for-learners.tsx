"use client";

import { useMemo, useState } from "react";
import { Globe, CheckCircle2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { api } from "@/lib/api";
import { formatSaveError } from "@/lib/format-api-error";
import { confirmPublishForLearners } from "@/lib/safe-confirm";

const RESTRICTED_SPIRITUAL = new Set(["ceremonial", "sacred", "restricted"]);

export type PublishableLexiconFields = {
  id: string;
  word_narragansett: string;
  english_gloss?: string | null;
  primary_speaker_id?: string | null;
  visibility?: string | null;
  approval_status?: string | null;
  is_sacred?: boolean | null;
  spiritual_significance?: string | null;
};

function publishBlockReason(entry: PublishableLexiconFields): string | null {
  const spiritual = entry.spiritual_significance ?? "none";
  if (entry.is_sacred || entry.visibility === "sacred" || RESTRICTED_SPIRITUAL.has(spiritual)) {
    return "Sacred or restricted entries cannot be published for learners.";
  }
  if (!entry.english_gloss?.trim()) {
    return "Add an English gloss before publishing for learners.";
  }
  if (!entry.primary_speaker_id) {
    return "Assign a primary speaker before publishing for learners.";
  }
  return null;
}

function isAlreadyPublished(entry: PublishableLexiconFields): boolean {
  return (
    entry.visibility === "public" &&
    entry.approval_status === "approved" &&
    !entry.is_sacred &&
    !RESTRICTED_SPIRITUAL.has(entry.spiritual_significance ?? "none")
  );
}

interface PublishForLearnersProps {
  entry: PublishableLexiconFields;
  size?: "default" | "sm";
  onPublished?: (entry: PublishableLexiconFields) => void;
}

export function PublishForLearnersButton({
  entry,
  size = "sm",
  onPublished,
}: PublishForLearnersProps) {
  const [publishing, setPublishing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [published, setPublished] = useState(isAlreadyPublished(entry));

  const blockReason = useMemo(() => publishBlockReason(entry), [entry]);

  if (published) {
    return (
      <Badge variant="secondary" className="gap-1 text-emerald-800">
        <CheckCircle2 className="h-3 w-3" />
        Published for learners
      </Badge>
    );
  }

  const handlePublish = async () => {
    if (blockReason) {
      setError(blockReason);
      return;
    }
    if (!confirmPublishForLearners(entry.word_narragansett)) return;

    setPublishing(true);
    setError(null);
    try {
      const result = await api.lexicon.publish(entry.id);
      setPublished(true);
      onPublished?.(result as PublishableLexiconFields);
    } catch (err) {
      setError(formatSaveError(err, "Publish"));
    } finally {
      setPublishing(false);
    }
  };

  return (
    <div className="space-y-1">
      <Button
        type="button"
        variant="outline"
        size={size}
        className="gap-2"
        disabled={publishing || Boolean(blockReason)}
        title={blockReason ?? "Set public + approved for the learner app"}
        onClick={handlePublish}
        aria-busy={publishing}
      >
        <Globe className="h-4 w-4" />
        {publishing ? "Publishing..." : "Publish for learners"}
      </Button>
      {(error || blockReason) && (
        <p className="text-xs text-muted-foreground max-w-xs">{error ?? blockReason}</p>
      )}
    </div>
  );
}
