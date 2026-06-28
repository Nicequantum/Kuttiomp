import { Header } from "@/components/layout/header";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { serverApiFetch } from "@/lib/server-api";
import type { LexicalEntry } from "@kuttiomp/database";

const FALLBACK_LEXICAL_DEFAULTS: Omit<
  LexicalEntry,
  | "id"
  | "word_narragansett"
  | "word_normalized"
  | "english_gloss"
  | "cultural_context"
  | "category"
  | "visibility"
  | "primary_speaker_id"
> = {
  english_gloss_extended: null,
  alternate_spellings: [],
  phonemic_transcription: null,
  ipa_transcription: null,
  morphological_breakdown: null,
  morpheme_gloss: null,
  etymology_notes: null,
  etymology_source: null,
  usage_notes: null,
  register: null,
  semantic_domain: "other",
  cultural_domain_id: null,
  ecological_connection: null,
  seasonal_usage: [],
  spiritual_significance: "none",
  cultural_context_summary: null,
  is_sacred: false,
  is_archaic: false,
  is_neologism: false,
  primary_orthography_id: null,
  approval_status: "approved",
  approved_by: null,
  approved_at: null,
  created_by: null,
  created_at: new Date().toISOString(),
  updated_at: new Date().toISOString(),
};

function getFallbackLexicon(): LexicalEntry[] {
  return [
    {
      ...FALLBACK_LEXICAL_DEFAULTS,
      id: "1",
      word_narragansett: "Wunnegan",
      word_normalized: "wunnegan",
      english_gloss: "Greeting / Good day",
      cultural_context:
        "A traditional greeting used to acknowledge presence and show respect.",
      category: "phrase",
      visibility: "public",
      primary_speaker_id: "b0000000-0000-0000-0000-000000000001",
    },
    {
      ...FALLBACK_LEXICAL_DEFAULTS,
      id: "2",
      word_narragansett: "Sharente",
      word_normalized: "sharente",
      english_gloss: "Two-Spirit person",
      cultural_context:
        "Honors the sacred Two-Spirit role in Narragansett culture.",
      category: "kinship_term",
      visibility: "clan",
      primary_speaker_id: "b0000000-0000-0000-0000-000000000003",
    },
    {
      ...FALLBACK_LEXICAL_DEFAULTS,
      id: "3",
      word_narragansett: "Kuttiomp",
      word_normalized: "kuttiomp",
      english_gloss: "Family / Home",
      cultural_context:
        "The gathering place for language — family and home.",
      category: "noun",
      visibility: "public",
      primary_speaker_id: "b0000000-0000-0000-0000-000000000001",
    },
  ];
}

export default async function LexiconPage() {
  const result = await serverApiFetch<LexicalEntry[]>("/api/v1/lexicon", { revalidate: 60 });
  const entries = result.ok ? result.data : getFallbackLexicon();
  const usingFallback = !result.ok;

  return (
    <>
      <Header
        title="Lexicon"
        description="Narragansett words and phrases with cultural context"
      />
      <div className="p-8 space-y-6">
        {usingFallback && (
          <ApiStatusMessage
            title="Showing sample lexicon entries"
            message={`${result.message} Displaying reference entries until the API connection is restored.`}
            variant="unreachable"
          />
        )}
        <Input placeholder="Search words in Narragansett or English..." className="max-w-md" />

        <div className="grid gap-4">
          {entries.length === 0 ? (
            <ApiStatusMessage
              title="No lexical entries yet"
              message="The lexicon is empty. Create your first entry in the Lexicon Editor."
              variant="empty"
            />
          ) : (
          entries.map((entry) => (
            <Card key={entry.id}>
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="font-serif text-xl">
                      {entry.word_narragansett}
                    </CardTitle>
                    <p className="text-muted-foreground">{entry.english_gloss}</p>
                  </div>
                  <div className="flex gap-2">
                    <Badge variant="secondary">{entry.category}</Badge>
                    {entry.is_sacred && <Badge variant="sacred">Sacred</Badge>}
                    <Badge variant="outline">{entry.visibility}</Badge>
                  </div>
                </div>
              </CardHeader>
              {entry.cultural_context && (
                <CardContent>
                  <p className="text-sm text-muted-foreground">
                    {entry.cultural_context}
                  </p>
                </CardContent>
              )}
            </Card>
          ))
          )}
        </div>
      </div>
    </>
  );
}