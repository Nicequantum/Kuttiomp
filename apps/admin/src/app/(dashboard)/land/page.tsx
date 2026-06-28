import { AcademicHeader } from "@kuttiomp/ui";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { MapPin } from "lucide-react";

async function getLandSites() {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000"}/api/v1/land/sites`,
      { next: { revalidate: 120 } }
    );
    if (!res.ok) return [];
    return res.json();
  } catch {
    return [];
  }
}

export default async function LandKnowledgePage() {
  const sites = await getLandSites();

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 11: Land Relationship"
        title="Land-Based Knowledge"
        subtitle="Geographic anchoring of linguistic and cultural knowledge using PostGIS. Language is inseparable from place."
      />
      <div className="p-8 space-y-4">
        {sites.length === 0 ? (
          <Card>
            <CardContent className="pt-6 flex items-center gap-3 text-muted-foreground">
              <MapPin className="h-5 w-5" />
              <p className="text-sm">
                No land knowledge sites yet. Apply migration 002 and add sites via API or Supabase.
              </p>
            </CardContent>
          </Card>
        ) : (
          sites.map((site: {
            id: string;
            name_narragansett: string;
            name_english: string | null;
            site_type: string;
            ecological_zone: string | null;
            cultural_significance: string | null;
            visibility: string;
          }) => (
            <Card key={site.id}>
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between">
                  <CardTitle className="font-serif text-lg">{site.name_narragansett}</CardTitle>
                  <div className="flex gap-2">
                    <Badge variant="secondary">{site.site_type}</Badge>
                    <Badge variant="outline">{site.visibility}</Badge>
                  </div>
                </div>
                {site.name_english && (
                  <p className="text-sm text-muted-foreground">{site.name_english}</p>
                )}
              </CardHeader>
              {site.cultural_significance && (
                <CardContent>
                  <p className="text-sm text-muted-foreground">{site.cultural_significance}</p>
                </CardContent>
              )}
            </Card>
          ))
        )}
      </div>
    </>
  );
}