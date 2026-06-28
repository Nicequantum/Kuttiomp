import { Header } from "@/components/layout/header";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { serverApiFetch } from "@/lib/server-api";
import type { Clan } from "@kuttiomp/database";

function getFallbackClans(): Clan[] {
  return [
    {
      id: "a0000000-0000-0000-0000-000000000001",
      name_narragansett: "Kuttiomp Clan",
      name_english: "Kuttiomp Family Clan",
      clan_animal: "Turtle",
      clan_color: null,
      territory_description: null,
      cultural_notes:
        "The primary family clan of the Kuttiomp language revitalization project. Turtle carries the teachings of patience, longevity, and ancestral knowledge.",
      is_primary_family_clan: true,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  ];
}

export default async function ClansPage() {
  const result = await serverApiFetch<Clan[]>("/api/v1/clans", { revalidate: 60 });
  const clans = result.ok ? result.data : getFallbackClans();
  const usingFallback = !result.ok;

  return (
    <>
      <Header
        title="Clans"
        description="Clan structure and cultural associations"
      />
      <div className="p-8 space-y-6">
        {usingFallback && (
          <ApiStatusMessage
            title="Showing reference clan data"
            message={`${result.message} Displaying fallback data until the API connection is restored.`}
            variant="unreachable"
          />
        )}
        {clans.map((clan) => (
          <Card key={clan.id}>
            <CardHeader>
              <div className="flex items-start justify-between">
                <div>
                  <CardTitle className="font-serif text-xl">
                    {clan.name_narragansett}
                  </CardTitle>
                  {clan.name_english && (
                    <p className="text-muted-foreground">{clan.name_english}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  {clan.is_primary_family_clan && (
                    <Badge>Primary Family Clan</Badge>
                  )}
                  {clan.clan_animal && (
                    <Badge variant="secondary">{clan.clan_animal}</Badge>
                  )}
                </div>
              </div>
            </CardHeader>
            {clan.cultural_notes && (
              <CardContent>
                <p className="text-sm text-muted-foreground leading-relaxed">
                  {clan.cultural_notes}
                </p>
              </CardContent>
            )}
          </Card>
        ))}
      </div>
    </>
  );
}