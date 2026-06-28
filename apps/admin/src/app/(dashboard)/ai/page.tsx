"use client";

import { useState } from "react";
import { Header } from "@/components/layout/header";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ErrorAlert } from "@kuttiomp/ui";
import { api } from "@/lib/api";
import { formatSaveError } from "@/lib/format-api-error";

export default function AIPage() {
  const [promptType, setPromptType] = useState("translation");
  const [text, setText] = useState("");
  const [response, setResponse] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    if (!text.trim()) return;
    setLoading(true);
    setError(null);
    try {
      const result = await api.ai.linguistic({
        prompt_type: promptType,
        text,
      }) as { response: string; cultural_disclaimer?: string };
      const disclaimer = result.cultural_disclaimer
        ? `\n\n—\n${result.cultural_disclaimer}`
        : "";
      setResponse(`${result.response}${disclaimer}`);
    } catch (err) {
      setError(formatSaveError(err, "Request"));
      setResponse("");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <Header
        title="AI Linguistic Assistant"
        description="Learning support — not a replacement for Knowledge Keepers"
      />
      <div className="p-8 max-w-2xl space-y-6">
        <Card className="border-kuttiomp-dawn/50 bg-kuttiomp-dawn/5">
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">
              This AI assists learners only. Elder Knowledge Keepers, Grandmother
              Comus, Grandfather, and Sharente hold authoritative understanding
              of Narragansett language and culture. Never use AI output as
              ceremonial or sacred content.
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Ask for Linguistic Help</CardTitle>
            <CardDescription>
              Translation suggestions, etymology, pronunciation guidance, cultural context
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Request Type</Label>
              <Select value={promptType} onValueChange={setPromptType}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="translation">Translation</SelectItem>
                  <SelectItem value="etymology">Etymology</SelectItem>
                  <SelectItem value="pronunciation_help">Pronunciation Help</SelectItem>
                  <SelectItem value="cultural_context">Cultural Context</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Your Question</Label>
              <textarea
                className="flex min-h-[120px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                placeholder="Enter a word, phrase, or question..."
                value={text}
                onChange={(e) => setText(e.target.value)}
              />
            </div>

            <Button onClick={handleSubmit} disabled={loading || !text.trim()} aria-busy={loading}>
              {loading ? "Thinking..." : "Ask Kuttiomp AI"}
            </Button>

            {error && (
              <ErrorAlert
                title="Request not completed"
                message={error}
                onRetry={loading ? undefined : handleSubmit}
              />
            )}

            {response && (
              <div className="rounded-md bg-muted p-4 text-sm whitespace-pre-wrap">
                {response}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </>
  );
}