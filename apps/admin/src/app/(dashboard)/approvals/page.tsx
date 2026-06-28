import { Header } from "@/components/layout/header";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

async function getPending() {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000"}/api/v1/audio/pending`,
      { next: { revalidate: 30 } }
    );
    if (!res.ok) return [];
    return res.json();
  } catch {
    return [];
  }
}

export default async function ApprovalsPage() {
  const pending = await getPending();

  return (
    <>
      <Header
        title="Content Approvals"
        description="Review pending audio and lexical content"
      />
      <div className="p-8 space-y-6">
        <Card className="border-kuttiomp-earth/30">
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">
              Sacred and ceremonial content requires elder review. Only Knowledge
              Keepers with appropriate authority should approve restricted content.
            </p>
          </CardContent>
        </Card>

        {pending.length === 0 ? (
          <Card>
            <CardContent className="pt-6">
              <p className="text-muted-foreground">No pending approvals at this time.</p>
            </CardContent>
          </Card>
        ) : (
          pending.map((item: {
            id: string;
            storage_path: string;
            recording_context: string | null;
            speakers?: { display_name: string; role: string };
            lexical_entries?: { word_narragansett: string };
          }) => (
            <Card key={item.id}>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-base">
                    Audio from {item.speakers?.display_name || "Unknown Speaker"}
                  </CardTitle>
                  <Badge variant="outline">Pending</Badge>
                </div>
              </CardHeader>
              <CardContent className="text-sm text-muted-foreground space-y-1">
                {item.lexical_entries?.word_narragansett && (
                  <p>Word: {item.lexical_entries.word_narragansett}</p>
                )}
                {item.recording_context && (
                  <p>Context: {item.recording_context}</p>
                )}
                <p>Path: {item.storage_path}</p>
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </>
  );
}