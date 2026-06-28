import { AcademicHeader } from "@kuttiomp/ui";
import { ApiStatusMessage } from "@/components/data/api-status-message";
import { AudioStudio } from "@/components/audio/audio-studio";
import { Card, CardContent } from "@/components/ui/card";
import { serverApiFetch } from "@/lib/server-api";
import type { Speaker } from "@kuttiomp/types";

export default async function AudioPage() {
  const result = await serverApiFetch<Speaker[]>("/api/v1/speakers", { revalidate: 60 });
  const speakers = result.ok ? result.data : [];

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 1 & 8"
        title="Professional Audio Studio"
        subtitle="Speaker-attributed recording with waveform visualization, quality metadata, context tags, and elder approval workflow."
      />
      <div className="p-8 max-w-5xl space-y-4">
        {!result.ok && (
          <ApiStatusMessage
            title="Speaker list unavailable"
            message={result.message}
            variant="unreachable"
          />
        )}
        <Card>
          <CardContent className="pt-6">
            <AudioStudio speakers={speakers} apiReachable={result.ok} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}