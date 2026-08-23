import { Header } from "@/components/layout/header";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { serverApiFetch } from "@/lib/server-api";

type ForgeRow = {
  id: string;
  proposed_word: string;
  english_gloss: string;
  status: string;
  semantic_domain?: string;
  confidence_score?: number;
  is_demo_visible?: boolean;
  is_production_ready?: boolean;
  version?: number;
};

export default async function ForgeListPage() {
  const result = await serverApiFetch<ForgeRow[]>("/api/v1/forge", { revalidate: 30 });
  const entries = result.ok ? result.data : [];

  return (
    <>
      <Header
        title="Narragansett Language Forge"
        description="Keeper-only working room for new words. kuttiomp-learn never mints forms — it only receives what Sharente releases."
      />
      <div className="space-y-4 p-6">
        {!result.ok ? (
          <ApiStatusMessage title="Forge API unavailable" message={result.message} />
        ) : null}
        <Card>
          <CardContent className="divide-y p-0">
            {entries.map((entry) => (
              <div
                key={entry.id}
                className="flex items-start justify-between gap-3 px-5 py-4"
              >
                <div>
                  <p className="font-serif text-xl">{entry.proposed_word}</p>
                  <p className="text-sm text-muted-foreground">{entry.english_gloss}</p>
                </div>
                <div className="flex flex-col items-end gap-1">
                  <Badge>{entry.status.replaceAll("_", " ")}</Badge>
                  <span className="text-xs text-muted-foreground">
                    {entry.semantic_domain} · v{entry.version ?? 1}
                    {entry.is_production_ready ? " · prod" : ""}
                    {entry.is_demo_visible ? " · demo" : ""}
                  </span>
                </div>
              </div>
            ))}
            {result.ok && entries.length === 0 ? (
              <p className="px-5 py-8 text-sm text-muted-foreground">
                No dossiers yet. Drafts stay hidden from learners until Sharente
                approves and marks them production-ready.
              </p>
            ) : null}
          </CardContent>
        </Card>
      </div>
    </>
  );
}
