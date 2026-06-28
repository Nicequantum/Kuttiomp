import { AcademicHeader } from "@kuttiomp/ui";
import { SpeakerCard } from "@/components/speakers/speaker-card";
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

export default async function SpeakerProfilesPage() {
  const speakers = await getSpeakers();

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 1: Speaker Sovereignty"
        title="Knowledge Keeper Profiles"
        subtitle="Each profile documents clan affiliation, generational status, gender expression, voice characteristics, and cultural authority level."
      />
      <div className="p-8 grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {speakers.length === 0 ? (
          <p className="text-sm text-muted-foreground col-span-full">
            No speakers loaded. Apply database migrations and ensure API is running.
          </p>
        ) : (
          speakers.map((speaker) => (
            <SpeakerCard key={speaker.id} speaker={speaker} />
          ))
        )}
      </div>
    </>
  );
}