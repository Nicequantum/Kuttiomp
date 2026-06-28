"use client";

import { useEffect, useState } from "react";
import { CheckCircle, Clock, FileText, Send } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ProtocolBadge } from "@kuttiomp/ui";
import { CULTURAL_PROTOCOLS } from "@kuttiomp/types";
import { api } from "@/lib/api";

interface Contribution {
  id: string;
  contribution_type: string;
  entity_type: string;
  status: string;
  submission_notes: string | null;
  protocol_acknowledgments: number[];
  created_at: string;
  contributor?: { display_name: string; role: string };
}

export function ContributionWorkflow() {
  const [contributions, setContributions] = useState<Contribution[]>([]);
  const [acknowledged, setAcknowledged] = useState<number[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.contributions.pending()
      .then((data) => setContributions(data as Contribution[]))
      .catch(() => setContributions([]))
      .finally(() => setLoading(false));
  }, []);

  const toggleProtocol = (id: number) =>
    setAcknowledged((prev) =>
      prev.includes(id) ? prev.filter((p) => p !== id) : [...prev, id]
    );

  const allAcknowledged = acknowledged.length === CULTURAL_PROTOCOLS.length;

  return (
    <div className="space-y-8">
      <Card className="border-emerald-900/15">
        <CardHeader>
          <CardTitle className="text-lg font-serif">Protocol Acknowledgment</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm text-muted-foreground">
            Before submitting knowledge, acknowledge the Twelve Cultural Governance Protocols.
            This ensures every contribution honors speaker sovereignty, clan boundaries, and sacred content protection.
          </p>
          <div className="grid gap-2 sm:grid-cols-2">
            {CULTURAL_PROTOCOLS.map((p) => (
              <label
                key={p.id}
                className="flex items-start gap-3 rounded-md border p-3 cursor-pointer hover:bg-stone-50 transition-colors"
              >
                <input
                  type="checkbox"
                  checked={acknowledged.includes(p.id)}
                  onChange={() => toggleProtocol(p.id)}
                  className="mt-0.5"
                />
                <div>
                  <p className="text-sm font-medium">P{p.id}: {p.title}</p>
                  <p className="text-xs text-muted-foreground">{p.principle}</p>
                </div>
              </label>
            ))}
          </div>
          {allAcknowledged && (
            <div className="flex items-center gap-2 text-emerald-800 text-sm">
              <CheckCircle className="h-4 w-4" />
              All protocols acknowledged. You may submit contributions.
            </div>
          )}
        </CardContent>
      </Card>

      <div>
        <h3 className="font-serif text-lg mb-4">Pending Review Queue</h3>
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading...</p>
        ) : contributions.length === 0 ? (
          <Card>
            <CardContent className="pt-6 text-sm text-muted-foreground">
              No contributions awaiting review.
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-3">
            {contributions.map((c) => (
              <Card key={c.id}>
                <CardContent className="pt-4 flex items-start justify-between gap-4">
                  <div className="space-y-1">
                    <div className="flex items-center gap-2">
                      <FileText className="h-4 w-4 text-stone-400" />
                      <span className="font-medium text-sm">
                        {c.contribution_type.replace(/_/g, " ")}
                      </span>
                      <Badge variant="outline">{c.status}</Badge>
                    </div>
                    <p className="text-sm text-muted-foreground">
                      By {c.contributor?.display_name ?? "Unknown"} — {c.entity_type}
                    </p>
                    {c.submission_notes && (
                      <p className="text-xs text-stone-500">{c.submission_notes}</p>
                    )}
                    <div className="flex flex-wrap gap-1 pt-1">
                      {c.protocol_acknowledgments?.map((p) => (
                        <ProtocolBadge key={p} protocolId={p} />
                      ))}
                    </div>
                  </div>
                  <div className="flex gap-2 shrink-0">
                    <Button size="sm" variant="outline" className="gap-1">
                      <Clock className="h-3 w-3" /> Review
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}