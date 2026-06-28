"use client";

import { useEffect, useState } from "react";
import { AcademicHeader } from "@kuttiomp/ui";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Check, X, Clock } from "lucide-react";
import { api } from "@/lib/api";

export default function ApprovalsPage() {
  const [audioPending, setAudioPending] = useState<unknown[]>([]);
  const [contribPending, setContribPending] = useState<unknown[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      api.audio.pending().catch(() => []),
      api.contributions.pending().catch(() => []),
    ]).then(([audio, contrib]) => {
      setAudioPending(audio as unknown[]);
      setContribPending(contrib as unknown[]);
      setLoading(false);
    });
  }, []);

  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 4 & 7"
        title="Cultural Accuracy Approvals"
        subtitle="Review queue for audio recordings and knowledge contributions. Sacred and ceremonial content requires elder authority."
      />
      <div className="p-8 max-w-4xl">
        <Tabs defaultValue="audio">
          <TabsList>
            <TabsTrigger value="audio">
              Audio ({audioPending.length})
            </TabsTrigger>
            <TabsTrigger value="contributions">
              Contributions ({contribPending.length})
            </TabsTrigger>
          </TabsList>

          <TabsContent value="audio" className="space-y-4 mt-6">
            {loading ? (
              <p className="text-sm text-muted-foreground">Loading...</p>
            ) : audioPending.length === 0 ? (
              <Card><CardContent className="pt-6 text-sm text-muted-foreground">No pending audio.</CardContent></Card>
            ) : (
              audioPending.map((item: {
                id: string;
                recording_context: string | null;
                quality: string;
                speakers?: { display_name: string };
                lexical_entries?: { word_narragansett: string };
              }) => (
                <Card key={item.id}>
                  <CardHeader className="pb-2">
                    <div className="flex justify-between items-start">
                      <div>
                        <CardTitle className="text-base">
                          {item.speakers?.display_name ?? "Unknown Speaker"}
                        </CardTitle>
                        {item.lexical_entries?.word_narragansett && (
                          <p className="text-sm text-muted-foreground">
                            Word: {item.lexical_entries.word_narragansett}
                          </p>
                        )}
                      </div>
                      <Badge variant="outline"><Clock className="h-3 w-3 mr-1" />Pending</Badge>
                    </div>
                  </CardHeader>
                  <CardContent className="flex justify-between items-center">
                    <p className="text-xs text-muted-foreground">
                      {item.recording_context ?? "No context"} · {item.quality}
                    </p>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" className="gap-1 text-emerald-800">
                        <Check className="h-3 w-3" /> Approve
                      </Button>
                      <Button size="sm" variant="outline" className="gap-1 text-red-700">
                        <X className="h-3 w-3" /> Reject
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))
            )}
          </TabsContent>

          <TabsContent value="contributions" className="space-y-4 mt-6">
            {contribPending.length === 0 ? (
              <Card><CardContent className="pt-6 text-sm text-muted-foreground">No pending contributions.</CardContent></Card>
            ) : (
              contribPending.map((c: {
                id: string;
                contribution_type: string;
                status: string;
                contributor?: { display_name: string };
              }) => (
                <Card key={c.id}>
                  <CardContent className="pt-4 flex justify-between">
                    <div>
                      <p className="font-medium text-sm">{c.contribution_type.replace(/_/g, " ")}</p>
                      <p className="text-xs text-muted-foreground">By {c.contributor?.display_name}</p>
                    </div>
                    <Badge variant="outline">{c.status}</Badge>
                  </CardContent>
                </Card>
              ))
            )}
          </TabsContent>
        </Tabs>
      </div>
    </>
  );
}