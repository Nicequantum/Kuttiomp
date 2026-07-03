"use client";

import { useCallback, useState } from "react";
import { Upload, FileJson, CheckCircle2, AlertTriangle, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { apiFetch, apiUpload } from "@/lib/api-client";
import { formatSaveError } from "@/lib/format-api-error";

interface BulkImportRow {
  index: number;
  word_narragansett: string;
  status: string;
  entry_id?: string;
  error?: string;
}

interface BulkImportResult {
  total: number;
  approved: number;
  requires_elder_review: number;
  failed: number;
  results: BulkImportRow[];
}

const SAMPLE_JSON = `[
  {
    "word_narragansett": "Wunnegan",
    "english_gloss": "Greeting / Good day",
    "ipa_transcription": "wʌˈnɛɡən",
    "category": "phrase",
    "semantic_domain": "other",
    "seasonal_usage": ["year_round"],
    "visibility": "public"
  }
]`;

export function BulkImport() {
  const [jsonText, setJsonText] = useState(SAMPLE_JSON);
  const [result, setResult] = useState<BulkImportResult | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleJsonImport = useCallback(async () => {
    setLoading(true);
    setError(null);
    setResult(null);
    try {
      const payload = JSON.parse(jsonText);
      const data = await apiFetch<BulkImportResult>("/api/v1/lexicon/bulk", {
        method: "POST",
        body: JSON.stringify(payload),
      });
      setResult(data);
    } catch (err) {
      setError(formatSaveError(err));
    } finally {
      setLoading(false);
    }
  }, [jsonText]);

  const handleFileImport = useCallback(async (file: File) => {
    setLoading(true);
    setError(null);
    setResult(null);
    try {
      const formData = new FormData();
      formData.append("file", file);
      const data = await apiUpload<BulkImportResult>("/api/v1/lexicon/bulk", formData);
      setResult(data);
    } catch (err) {
      setError(formatSaveError(err));
    } finally {
      setLoading(false);
    }
  }, []);

  return (
    <div className="space-y-6">
      <Tabs defaultValue="json">
        <TabsList>
          <TabsTrigger value="json" className="gap-2">
            <FileJson className="h-4 w-4" />
            JSON Array
          </TabsTrigger>
          <TabsTrigger value="file" className="gap-2">
            <Upload className="h-4 w-4" />
            CSV / JSON File
          </TabsTrigger>
        </TabsList>

        <TabsContent value="json" className="space-y-4">
          <p className="text-sm text-stone-600">
            Paste a JSON array of lexical entries. All fields from the Lexicon Editor are supported,
            plus optional <code className="text-xs">land_site_id</code> and{" "}
            <code className="text-xs">speaker_ids</code>.
          </p>
          <Textarea
            value={jsonText}
            onChange={(e) => setJsonText(e.target.value)}
            rows={14}
            className="font-mono text-sm"
          />
          <Button onClick={handleJsonImport} disabled={loading}>
            {loading ? "Importing…" : "Import JSON"}
          </Button>
        </TabsContent>

        <TabsContent value="file" className="space-y-4">
          <p className="text-sm text-stone-600">
            Upload a <strong>.csv</strong> or <strong>.json</strong> file. CSV columns: word,
            english_gloss, ipa, morphology, tek_context, seasonal_usage, orth_variants,
            speaker_ids, land_site_id, category, visibility, and more.
          </p>
          <input
            type="file"
            accept=".csv,.json"
            className="block w-full text-sm text-stone-600 file:mr-4 file:rounded-md file:border-0 file:bg-emerald-900 file:px-4 file:py-2 file:text-sm file:font-medium file:text-white hover:file:bg-emerald-800"
            onChange={(e) => {
              const file = e.target.files?.[0];
              if (file) void handleFileImport(file);
            }}
            disabled={loading}
          />
        </TabsContent>
      </Tabs>

      {error && (
        <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
          {error}
        </div>
      )}

      {result && (
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Import Report</CardTitle>
            <div className="flex flex-wrap gap-2 pt-2">
              <Badge variant="outline">{result.total} total</Badge>
              <Badge className="bg-emerald-700">
                <CheckCircle2 className="mr-1 h-3 w-3" />
                {result.approved} approved
              </Badge>
              <Badge className="bg-amber-600">
                <AlertTriangle className="mr-1 h-3 w-3" />
                {result.requires_elder_review} need elder review
              </Badge>
              {result.failed > 0 && (
                <Badge variant="destructive">
                  <XCircle className="mr-1 h-3 w-3" />
                  {result.failed} failed
                </Badge>
              )}
            </div>
          </CardHeader>
          <CardContent>
            <ul className="max-h-64 space-y-1 overflow-y-auto text-sm">
              {result.results.map((row) => (
                <li
                  key={row.index}
                  className="flex items-center justify-between rounded px-2 py-1 hover:bg-stone-50"
                >
                  <span className="font-medium">{row.word_narragansett}</span>
                  <span
                    className={
                      row.status === "error"
                        ? "text-red-600"
                        : row.status === "requires_elder_review"
                          ? "text-amber-700"
                          : "text-emerald-700"
                    }
                  >
                    {row.status === "error" ? row.error : row.status}
                  </span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      )}
    </div>
  );
}