import { Header } from "@/components/layout/header";
import { AudioRecorder } from "@/components/audio/audio-recorder";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import type { Speaker } from "@kuttiomp/database";

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
      <Header
        title="Audio Studio"
        description="Record and upload speaker-attributed audio"
      />
      <div className="p-8 max-w-2xl">
        <Card>
          <CardHeader>
            <CardTitle>New Recording</CardTitle>
            <CardDescription>
              Every recording must be attributed to the speaker whose voice is
              captured. Recordings require elder approval before publication.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <AudioRecorder speakers={speakers} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}