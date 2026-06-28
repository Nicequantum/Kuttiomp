import { AcademicHeader } from "@kuttiomp/ui";
import { AudioStudio } from "@/components/audio/audio-studio";
import { Card, CardContent } from "@/components/ui/card";
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

export default async function AudioPage() {
  const speakers = await getSpeakers();

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 1 & 8"
        title="Professional Audio Studio"
        subtitle="Speaker-attributed recording with waveform visualization, quality metadata, context tags, and elder approval workflow."
      />
      <div className="p-8 max-w-5xl">
        <Card>
          <CardContent className="pt-6">
            <AudioStudio speakers={speakers} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}