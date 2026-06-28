import { AcademicHeader } from "@kuttiomp/ui";
import { ClanTreeVisual } from "@/components/speakers/clan-tree-visual";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

async function getSpeakerTree() {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000"}/api/v1/speakers/tree`,
      { next: { revalidate: 60 } }
    );
    if (!res.ok) return getFallbackTree();
    return res.json();
  } catch {
    return getFallbackTree();
  }
}

function getFallbackTree() {
  return [
    {
      id: "b0000000-0000-0000-0000-000000000001",
      display_name: "Grandmother Comus",
      role: "grandmother",
      generation: "elder",
      is_elder: true,
      cultural_authority: "elder_keeper",
      children: [
        {
          id: "b0000000-0000-0000-0000-000000000004",
          display_name: "Mother",
          role: "parent",
          generation: "middle",
          children: [
            { id: "b0000000-0000-0000-0000-000000000006", display_name: "Older Sibling", role: "sibling", generation: "younger", children: [] },
            { id: "b0000000-0000-0000-0000-000000000007", display_name: "Younger Sibling", role: "sibling", generation: "younger", children: [] },
          ],
        },
      ],
    },
    {
      id: "b0000000-0000-0000-0000-000000000002",
      display_name: "Grandfather",
      role: "grandfather",
      generation: "elder",
      is_elder: true,
      children: [
        { id: "b0000000-0000-0000-0000-000000000005", display_name: "Father", role: "parent", generation: "middle", children: [] },
      ],
    },
    {
      id: "b0000000-0000-0000-0000-000000000003",
      display_name: "Sharente",
      role: "sharente",
      generation: "middle",
      is_two_spirit: true,
      cultural_authority: "sharente_keeper",
      children: [],
    },
    {
      id: "b0000000-0000-0000-0000-000000000008",
      display_name: "Auntie",
      role: "clan_member",
      generation: "middle",
      children: [],
    },
    {
      id: "b0000000-0000-0000-0000-000000000009",
      display_name: "Uncle",
      role: "clan_member",
      generation: "middle",
      children: [],
    },
  ];
}

export default async function ClanTreePage() {
  const tree = await getSpeakerTree();

  return (
    <>
      <AcademicHeader
        eyebrow="Multi-Generational Knowledge Transmission"
        title="Clan Speaker Tree"
        subtitle="Visual representation of generational knowledge flow from Elders through Sharente, parents, siblings, and clan members. Every branch carries attributed voice and cultural authority."
      />
      <div className="p-8">
        <Card>
          <CardHeader>
            <CardTitle className="font-serif text-lg">Kuttiomp Family Clan</CardTitle>
          </CardHeader>
          <CardContent>
            <ClanTreeVisual nodes={tree} clanName="Kuttiomp Clan — Turtle" />
          </CardContent>
        </Card>
      </div>
    </>
  );
}