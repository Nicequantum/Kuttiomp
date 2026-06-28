import { Header } from "@/components/layout/header";
import { SpeakerCard } from "@/components/speakers/speaker-card";
import { SpeakerTree } from "@/components/speakers/speaker-tree";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import type { Speaker } from "@kuttiomp/database";

async function getSpeakers(): Promise<Speaker[]> {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000"}/api/v1/speakers`,
      { next: { revalidate: 60 } }
    );
    if (!res.ok) return getFallbackSpeakers();
    return res.json();
  } catch {
    return getFallbackSpeakers();
  }
}

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

function getFallbackSpeakers(): Speaker[] {
  return [
    {
      id: "b0000000-0000-0000-0000-000000000001",
      display_name: "Grandmother Comus",
      name_narragansett: "Mush8n8m8s",
      role: "grandmother",
      generation: "elder",
      clan_id: "a0000000-0000-0000-0000-000000000001",
      parent_speaker_id: null,
      biography: "Revered elder and primary keeper of Narragansett language and cultural knowledge.",
      cultural_title: "Elder Knowledge Keeper",
      is_two_spirit: false,
      is_elder: true,
      is_active: true,
      birth_year: null,
      photo_url: null,
      voice_description: null,
      teaching_domains: ["kinship_terms", "ceremonial_language", "traditional_stories"],
      clerk_user_id: null,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
    {
      id: "b0000000-0000-0000-0000-000000000003",
      display_name: "Sharente",
      name_narragansett: "Sharente",
      role: "sharente",
      generation: "middle",
      clan_id: "a0000000-0000-0000-0000-000000000001",
      parent_speaker_id: null,
      biography: "Two-Spirit knowledge keeper bridging traditional and contemporary understanding.",
      cultural_title: "Two-Spirit Knowledge Keeper",
      is_two_spirit: true,
      is_elder: false,
      is_active: true,
      birth_year: null,
      photo_url: null,
      voice_description: null,
      teaching_domains: ["kinship_terms", "inclusive_language", "cultural_bridge"],
      clerk_user_id: null,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  ] as Speaker[];
}

function getFallbackTree() {
  return [
    {
      id: "b0000000-0000-0000-0000-000000000001",
      display_name: "Grandmother Comus",
      role: "grandmother",
      is_elder: true,
      children: [
        {
          id: "b0000000-0000-0000-0000-000000000004",
          display_name: "Mother",
          role: "parent",
          children: [
            { id: "b0000000-0000-0000-0000-000000000006", display_name: "Older Sibling", role: "sibling", children: [] },
            { id: "b0000000-0000-0000-0000-000000000007", display_name: "Younger Sibling", role: "sibling", children: [] },
          ],
        },
      ],
    },
    {
      id: "b0000000-0000-0000-0000-000000000002",
      display_name: "Grandfather",
      role: "grandfather",
      is_elder: true,
      children: [
        { id: "b0000000-0000-0000-0000-000000000005", display_name: "Father", role: "parent", children: [] },
      ],
    },
    {
      id: "b0000000-0000-0000-0000-000000000003",
      display_name: "Sharente",
      role: "sharente",
      is_two_spirit: true,
      children: [],
    },
  ];
}

export default async function SpeakersPage() {
  const [speakers, tree] = await Promise.all([getSpeakers(), getSpeakerTree()]);

  return (
    <>
      <Header
        title="Knowledge Keepers & Speakers"
        description="Multi-generational clan-based speaker system"
      />
      <div className="p-8 space-y-8">
        <Card>
          <CardHeader>
            <CardTitle>Clan Speaker Tree</CardTitle>
          </CardHeader>
          <CardContent>
            <SpeakerTree nodes={tree} />
          </CardContent>
        </Card>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {speakers.map((speaker) => (
            <SpeakerCard key={speaker.id} speaker={speaker} />
          ))}
        </div>
      </div>
    </>
  );
}