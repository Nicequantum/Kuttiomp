import { AcademicHeader } from "@kuttiomp/ui";
import { LexiconEditor } from "@/components/lexicon/lexicon-editor";
import { Card, CardContent } from "@/components/ui/card";
import type { Speaker } from "@kuttiomp/types";

async function getSpeakers(): Promise<Speaker[]> {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000"}/api/v1/speakers`,
      { next: { revalidate: 60 } }
    );
    if (!res.ok) return [];
    return res.json();
  } catch {
    return [];
  }
}

export default async function LexiconEditorPage() {
  const speakers = await getSpeakers();

  return (
    <>
      <AcademicHeader
        eyebrow="Linguistic Documentation"
        title="Advanced Lexicon Editor"
        subtitle="Document Narragansett words with the full scholarly metadata schema — phonemic transcription, morphology, cultural contexts, orthographic variants, and governance fields."
      />
      <div className="p-8 max-w-4xl">
        <Card>
          <CardContent className="pt-6">
            <LexiconEditor speakers={speakers} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}