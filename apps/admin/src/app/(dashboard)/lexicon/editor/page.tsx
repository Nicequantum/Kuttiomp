import { AcademicHeader } from "@kuttiomp/ui";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { LexiconEditor } from "@/components/lexicon/lexicon-editor";
import { Card, CardContent } from "@/components/ui/card";
import { serverApiFetch } from "@/lib/server-api";
import type { Speaker } from "@kuttiomp/types";

export default async function LexiconEditorPage() {
  const result = await serverApiFetch<Speaker[]>("/api/v1/speakers", { revalidate: 60 });
  const speakers = result.ok ? result.data : [];

  return (
    <>
      <AcademicHeader
        eyebrow="Linguistic Documentation"
        title="Advanced Lexicon Editor"
        subtitle="Document Narragansett words with the full scholarly metadata schema — phonemic transcription, morphology, cultural contexts, orthographic variants, and governance fields."
      />
      <div className="p-8 max-w-4xl space-y-4">
        {!result.ok && (
          <ApiStatusMessage
            title="Speaker list unavailable for attribution"
            message={result.message}
            variant="unreachable"
          />
        )}
        <Card>
          <CardContent className="pt-6">
            <LexiconEditor speakers={speakers} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}