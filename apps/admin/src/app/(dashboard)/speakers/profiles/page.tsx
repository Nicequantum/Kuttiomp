import { AcademicHeader } from "@kuttiomp/ui";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { SpeakerCard } from "@/components/speakers/speaker-card";
import { serverApiFetch } from "@/lib/server-api";
import type { Speaker } from "@kuttiomp/types";

export default async function SpeakerProfilesPage() {
  const result = await serverApiFetch<Speaker[]>("/api/v1/speakers", { revalidate: 60 });

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 1: Speaker Sovereignty"
        title="Knowledge Keeper Profiles"
        subtitle="Each profile documents clan affiliation, generational status, gender expression, voice characteristics, and cultural authority level."
      />
      <div className="p-8 grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {!result.ok ? (
          <ApiStatusMessage
            title="Speakers could not be loaded"
            message={result.message}
            variant="unreachable"
          />
        ) : result.data.length === 0 ? (
          <ApiStatusMessage
            title="No speaker profiles yet"
            message="The database has no speaker records. Add Knowledge Keepers via the API or Supabase when ready."
            variant="empty"
          />
        ) : (
          result.data.map((speaker) => (
            <SpeakerCard key={speaker.id} speaker={speaker} />
          ))
        )}
      </div>
    </>
  );
}