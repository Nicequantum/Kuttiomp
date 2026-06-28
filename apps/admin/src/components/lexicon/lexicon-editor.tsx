"use client";

import { useState } from "react";
import { Save, BookOpen } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { MetadataField } from "@kuttiomp/ui";
import { SEMANTIC_DOMAIN_LABELS, type LexicalEntry } from "@kuttiomp/types";
import { api } from "@/lib/api";

interface LexiconEditorProps {
  entry?: Partial<LexicalEntry>;
  onSaved?: (entry: LexicalEntry) => void;
}

const CATEGORIES = [
  "noun", "verb", "adjective", "phrase", "kinship_term",
  "ceremonial", "place_name", "natural_world", "proverb", "other",
];

const SEASONS = ["spring", "summer", "fall", "winter", "year_round", "ceremonial_season", "harvest", "planting"];

export function LexiconEditor({ entry, onSaved }: LexiconEditorProps) {
  const [form, setForm] = useState({
    word_narragansett: entry?.word_narragansett ?? "",
    english_gloss: entry?.english_gloss ?? "",
    english_gloss_extended: entry?.english_gloss_extended ?? "",
    phonemic_transcription: entry?.phonemic_transcription ?? "",
    ipa_transcription: entry?.ipa_transcription ?? "",
    morphological_breakdown: entry?.morphological_breakdown ?? "",
    morpheme_gloss: entry?.morpheme_gloss ?? "",
    etymology_notes: entry?.etymology_notes ?? "",
    etymology_source: entry?.etymology_source ?? "",
    usage_notes: entry?.usage_notes ?? "",
    register: entry?.register ?? "",
    category: entry?.category ?? "other",
    semantic_domain: entry?.semantic_domain ?? "other",
    ecological_connection: entry?.ecological_connection ?? "",
    cultural_context_summary: entry?.cultural_context_summary ?? "",
    spiritual_significance: entry?.spiritual_significance ?? "none",
    visibility: entry?.visibility ?? "clan",
    is_sacred: entry?.is_sacred ?? false,
    seasonal_usage: entry?.seasonal_usage ?? [],
  });
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");

  const update = (key: string, value: unknown) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const handleSave = async () => {
    if (!form.word_narragansett || !form.english_gloss) {
      setMessage("Narragansett word and English gloss are required.");
      return;
    }
    setSaving(true);
    try {
      const result = entry?.id
        ? await api.lexicon.update(entry.id, form)
        : await api.lexicon.create(form);
      setMessage("Entry saved successfully.");
      onSaved?.(result as LexicalEntry);
    } catch {
      setMessage("Save failed. Ensure API is running and database migration is applied.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2 text-stone-600">
          <BookOpen className="h-5 w-5" />
          <span className="text-sm font-medium">
            {entry?.id ? "Edit Lexical Entry" : "New Lexical Entry"}
          </span>
        </div>
        <Button onClick={handleSave} disabled={saving} className="gap-2">
          <Save className="h-4 w-4" />
          {saving ? "Saving..." : "Save Entry"}
        </Button>
      </div>

      <Tabs defaultValue="core">
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="core">Core</TabsTrigger>
          <TabsTrigger value="linguistic">Linguistic</TabsTrigger>
          <TabsTrigger value="cultural">Cultural</TabsTrigger>
          <TabsTrigger value="governance">Governance</TabsTrigger>
        </TabsList>

        <TabsContent value="core" className="space-y-4 mt-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label>Narragansett Word *</Label>
              <Input
                value={form.word_narragansett}
                onChange={(e) => update("word_narragansett", e.target.value)}
                className="font-serif text-lg"
                placeholder="e.g., Wunnegan"
              />
            </div>
            <div className="space-y-2">
              <Label>English Gloss *</Label>
              <Input
                value={form.english_gloss}
                onChange={(e) => update("english_gloss", e.target.value)}
                placeholder="Brief translation"
              />
            </div>
          </div>
          <MetadataField label="Extended Gloss" description="Full definitional explanation for scholars">
            <Textarea
              value={form.english_gloss_extended}
              onChange={(e) => update("english_gloss_extended", e.target.value)}
              rows={3}
            />
          </MetadataField>
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label>Grammatical Category</Label>
              <Select value={form.category} onValueChange={(v) => update("category", v)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {CATEGORIES.map((c) => (
                    <SelectItem key={c} value={c}>{c.replace(/_/g, " ")}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Semantic Domain</Label>
              <Select value={form.semantic_domain} onValueChange={(v) => update("semantic_domain", v)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {Object.entries(SEMANTIC_DOMAIN_LABELS).map(([k, v]) => (
                    <SelectItem key={k} value={k}>{v}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </TabsContent>

        <TabsContent value="linguistic" className="space-y-4 mt-6">
          <div className="grid gap-4 md:grid-cols-2">
            <MetadataField label="Phonemic Transcription" description="Phonemic-level representation">
              <Input value={form.phonemic_transcription} onChange={(e) => update("phonemic_transcription", e.target.value)} />
            </MetadataField>
            <MetadataField label="IPA Transcription">
              <Input value={form.ipa_transcription} onChange={(e) => update("ipa_transcription", e.target.value)} />
            </MetadataField>
          </div>
          <MetadataField label="Morphological Breakdown" description="Morpheme-by-morpheme analysis">
            <Textarea value={form.morphological_breakdown} onChange={(e) => update("morphological_breakdown", e.target.value)} rows={2} />
          </MetadataField>
          <MetadataField label="Morpheme Gloss">
            <Input value={form.morpheme_gloss} onChange={(e) => update("morpheme_gloss", e.target.value)} />
          </MetadataField>
          <MetadataField label="Etymology Notes">
            <Textarea value={form.etymology_notes} onChange={(e) => update("etymology_notes", e.target.value)} rows={3} />
          </MetadataField>
          <MetadataField label="Etymology Source" description="Citation for etymological claims">
            <Input value={form.etymology_source} onChange={(e) => update("etymology_source", e.target.value)} />
          </MetadataField>
          <MetadataField label="Usage Notes">
            <Textarea value={form.usage_notes} onChange={(e) => update("usage_notes", e.target.value)} rows={2} />
          </MetadataField>
          <MetadataField label="Register" description="Formal, informal, ceremonial, etc.">
            <Input value={form.register} onChange={(e) => update("register", e.target.value)} />
          </MetadataField>
        </TabsContent>

        <TabsContent value="cultural" className="space-y-4 mt-6">
          <MetadataField label="Cultural Context Summary" description="When, how, and why this word is used">
            <Textarea value={form.cultural_context_summary} onChange={(e) => update("cultural_context_summary", e.target.value)} rows={4} />
          </MetadataField>
          <MetadataField label="Ecological Connection" description="Relationship to land, plants, animals, seasons (Protocol 11)">
            <Textarea value={form.ecological_connection} onChange={(e) => update("ecological_connection", e.target.value)} rows={3} />
          </MetadataField>
          <div className="space-y-2">
            <Label>Spiritual Significance</Label>
            <Select value={form.spiritual_significance} onValueChange={(v) => update("spiritual_significance", v)}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                {["none", "respectful", "ceremonial", "sacred", "restricted"].map((s) => (
                  <SelectItem key={s} value={s}>{s}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <MetadataField label="Seasonal Usage" description="When this word is traditionally used">
            <div className="flex flex-wrap gap-2">
              {SEASONS.map((s) => (
                <label key={s} className="flex items-center gap-1.5 text-sm">
                  <input
                    type="checkbox"
                    checked={(form.seasonal_usage as string[]).includes(s)}
                    onChange={(e) => {
                      const current = form.seasonal_usage as string[];
                      update(
                        "seasonal_usage",
                        e.target.checked ? [...current, s] : current.filter((x) => x !== s)
                      );
                    }}
                  />
                  {s.replace(/_/g, " ")}
                </label>
              ))}
            </div>
          </MetadataField>
        </TabsContent>

        <TabsContent value="governance" className="space-y-4 mt-6">
          <div className="space-y-2">
            <Label>Visibility</Label>
            <Select value={form.visibility} onValueChange={(v) => update("visibility", v)}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                {["public", "clan", "family", "elders_only", "sacred"].map((v) => (
                  <SelectItem key={v} value={v}>{v}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={form.is_sacred}
              onChange={(e) => update("is_sacred", e.target.checked)}
            />
            Mark as sacred content (requires elder review — Protocol 4)
          </label>
          <p className="text-xs text-muted-foreground leading-relaxed">
            All entries enter the approval workflow upon save. Sacred content is automatically
            flagged for elder review per Cultural Governance Protocol 4.
          </p>
        </TabsContent>
      </Tabs>

      {message && <p className="text-sm text-muted-foreground">{message}</p>}
    </div>
  );
}