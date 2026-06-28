import { AcademicHeader } from "@kuttiomp/ui";
import { LexiconEditor } from "@/components/lexicon/lexicon-editor";
import { Card, CardContent } from "@/components/ui/card";

export default function LexiconEditorPage() {
  return (
    <>
      <AcademicHeader
        eyebrow="Linguistic Documentation"
        title="Advanced Lexicon Editor"
        subtitle="PhD-grade lexical entry creation with phonemic transcription, morphological analysis, semantic and cultural domains, ecological connections, and governance metadata."
      />
      <div className="p-8 max-w-4xl">
        <Card>
          <CardContent className="pt-6">
            <LexiconEditor />
          </CardContent>
        </Card>
      </div>
    </>
  );
}