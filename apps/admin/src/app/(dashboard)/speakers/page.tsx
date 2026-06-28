import { AcademicHeader } from "@kuttiomp/ui";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { ClanTreeVisual } from "@/components/speakers/clan-tree-visual";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { serverApiFetch } from "@/lib/server-api";

interface TreeNode {
  id: string;
  display_name: string;
  role: string;
  generation?: string;
  is_elder?: boolean;
  is_two_spirit?: boolean;
  cultural_authority?: string;
  children?: TreeNode[];
}

function getFallbackTree(): TreeNode[] {
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
  const result = await serverApiFetch<TreeNode[]>("/api/v1/speakers/tree", { revalidate: 60 });
  const tree = result.ok ? result.data : null;
  const usingFallback = !result.ok;

  return (
    <>
      <AcademicHeader
        eyebrow="Multi-Generational Knowledge Transmission"
        title="Clan Speaker Tree"
        subtitle="Visual representation of generational knowledge flow from Elders through Sharente, parents, siblings, and clan members. Every branch carries attributed voice and cultural authority."
      />
      <div className="p-8 space-y-4">
        {usingFallback && (
          <ApiStatusMessage
            title="Showing reference clan tree"
            message={`${result.message} Displaying seeded fallback data until the API connection is restored.`}
            variant="unreachable"
          />
        )}
        <Card>
          <CardHeader>
            <CardTitle className="font-serif text-lg">Kuttiomp Family Clan</CardTitle>
          </CardHeader>
          <CardContent>
            <ClanTreeVisual
              nodes={tree && tree.length > 0 ? tree : getFallbackTree()}
              clanName="Kuttiomp Clan — Turtle"
              apiUnavailable={usingFallback}
            />
          </CardContent>
        </Card>
      </div>
    </>
  );
}