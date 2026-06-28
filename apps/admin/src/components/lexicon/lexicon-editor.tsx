"use client";

import { useCallback, useState } from "react";
import { Save, BookOpen, Plus, Trash2, CheckCircle2 } from "lucide-react";
import { lexicalEntryFormSchema, type LexicalEntryForm, type CulturalContextInput } from "@kuttiomp/validation";
import { ErrorAlert, MetadataField, SacredLanguageNotice } from "@kuttiomp/ui";
import { SEMANTIC_DOMAIN_LABELS, CONTEXT_TYPE_LABELS, type LexicalEntry } from "@kuttiomp/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { api, ApiError } from "@/lib/api";
import type { Speaker } from "@kuttiomp/types";

interface LexiconEditorProps {
  entry?: Partial<LexicalEntry>;
  speakers?: Speaker[];
  onSaved?: (entry: LexicalEntry) => void;
}

const CATEGORIES = [
  "noun", "verb", "adjective", "adverb", "phrase", "kinship_term",
  "ceremonial", "place_name", "natural_world", "proverb", "prayer", "other",
];

const SEASONS = ["spring", "summer", "fall", "winter", "year_round", "ceremonial_season", "harvest", "planting"] as const;

const ORTHOGRAPHY_SYSTEMS = [
  { key: "jopson_modern", label: "Jopson Modern" },
  { key: "costa_transcription", label: "Costa Transcription" },
  { key: "ipa", label: "IPA" },
  { key: "community_preferred", label: "Community Preferred" },
  { key: "learner_phonetic", label: "Learner Phonetic" },
];

const emptyContext = (): CulturalContextInput => ({
  context_type: "mother_earth",
  title: "",
  narrative: "",
  visibility: "clan",
});

const defaultForm = (): LexicalEntryForm => ({
  word_narragansett: "",
  english_gloss: "",
  english_gloss_extended: "",
  alternate_spellings: [],
  phonemic_transcription: "",
  ipa_transcription: "",
  morphological_breakdown: "",
  morpheme_gloss: "",
  etymology_notes: "",
  etymology_source: "",
  usage_notes: "",
  register: "",
  category: "other",
  semantic_domain: "other",
  ecological_connection: "",
  seasonal_usage: [],
  spiritual_significance: "none",
  cultural_context_summary: "",
  visibility: "clan",
  is_sacred: false,
  is_archaic: false,
  is_neologism: false,
  spelling_variants: [],
  example_sentences: [],
  cultural_contexts: [],
});

export function LexiconEditor({ entry, speakers = [], onSaved }: LexiconEditorProps) {
  const [form, setForm] = useState<LexicalEntryForm>(() => ({
    ...defaultForm(),
    word_narragansett: entry?.word_narragansett ?? "",
    english_gloss: entry?.english_gloss ?? "",
    english_gloss_extended: entry?.english_gloss_extended ?? "",
    phonemic_transcription: entry?.phonemic_transcription ?? "",
    ipa_transcription: entry?.ipa_transcription ?? "",
    morphological_breakdown: entry?.morphological_breakdown ?? "",
    morpheme_gloss: entry?.morpheme_gloss ?? "",
    etymology_notes: entry?.etymology_notes ?? "",
    usage_notes: entry?.usage_notes ?? "",
    category: entry?.category ?? "other",
    semantic_domain: entry?.semantic_domain ?? "other",
    ecological_connection: entry?.ecological_connection ?? "",
    cultural_context_summary: entry?.cultural_context_summary ?? "",
    spiritual_significance: entry?.spiritual_significance ?? "none",
    visibility: entry?.visibility ?? "clan",
    is_sacred: entry?.is_sacred ?? false,
    is_archaic: entry?.is_archaic ?? false,
    is_neologism: entry?.is_neologism ?? false,
    primary_speaker_id: entry?.primary_speaker_id ?? undefined,
    seasonal_usage: entry?.seasonal_usage ?? [],
    alternate_spellings: entry?.alternate_spellings ?? [],
  }));
  const [altSpelling, setAltSpelling] = useState("");
  const [saving, setSaving] = useState(false);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [feedback, setFeedback] = useState<{ type: "success" | "error"; message: string } | null>(null);
  const [activeTab, setActiveTab] = useState("core");

  const update = useCallback(<K extends keyof LexicalEntryForm>(key: K, value: LexicalEntryForm[K]) => {
    setForm((prev) => ({ ...prev, [key]: value }));
    setFieldErrors((prev) => {
      const next = { ...prev };
      delete next[key as string];
      return next;
    });
  }, []);

  const handleSave = async () => {
    setFeedback(null);
    const cleaned = {
      ...form,
      spelling_variants: form.spelling_variants.filter((v) => v.spelling.trim()),
      example_sentences: form.example_sentences.filter(
        (e) => e.sentence_narragansett.trim() && e.sentence_english.trim()
      ),
      cultural_contexts: form.cultural_contexts.filter(
        (c) => c.title.trim() && c.narrative.trim().length >= 10
      ),
    };
    const parsed = lexicalEntryFormSchema.safeParse(cleaned);
    if (!parsed.success) {
      const errors: Record<string, string> = {};
      parsed.error.issues.forEach((issue) => {
        const key = issue.path.join(".");
        if (!errors[key]) errors[key] = issue.message;
      });
      setFieldErrors(errors);
      setFeedback({ type: "error", message: "Please correct the highlighted fields before saving." });
      return;
    }

    setSaving(true);
    try {
      const payload = parsed.data;
      const result = entry?.id
        ? await api.lexicon.update(entry.id, payload)
        : await api.lexicon.create(payload);
      setFeedback({
        type: "success",
        message: entry?.id
          ? "Entry updated. It will enter the elder review workflow if marked sacred."
          : "Entry created and submitted for review.",
      });
      onSaved?.(result as LexicalEntry);
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : "Save failed. Check that the Kuttiomp API is reachable from this deployment.";
      setFeedback({ type: "error", message: msg });
    } finally {
      setSaving(false);
    }
  };

  const tabHasErrors = (fields: string[]) => fields.some((f) => fieldErrors[f]);

  return (
    <div className="space-y-6">
      <SacredLanguageNotice compact />

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

      {feedback?.type === "success" && (
        <div className="flex items-center gap-2 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">
          <CheckCircle2 className="h-4 w-4" />
          {feedback.message}
        </div>
      )}
      {feedback?.type === "error" && <ErrorAlert message={feedback.message} />}

      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="core" className={tabHasErrors(["word_narragansett", "english_gloss"]) ? "text-red-700" : ""}>
            Core
          </TabsTrigger>
          <TabsTrigger value="linguistic">Linguistic</TabsTrigger>
          <TabsTrigger value="cultural" className={tabHasErrors(["visibility", "is_sacred"]) ? "text-red-700" : ""}>
            Cultural
          </TabsTrigger>
          <TabsTrigger value="governance">Governance</TabsTrigger>
        </TabsList>

        {/* CORE TAB */}
        <TabsContent value="core" className="space-y-5 mt-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label>Narragansett Word *</Label>
              <Input
                value={form.word_narragansett}
                onChange={(e) => update("word_narragansett", e.target.value)}
                className="font-serif text-lg"
                placeholder="e.g., Wunnegan"
              />
              {fieldErrors.word_narragansett && <p className="text-xs text-red-600">{fieldErrors.word_narragansett}</p>}
            </div>
            <div className="space-y-2">
              <Label>English Gloss *</Label>
              <Input value={form.english_gloss} onChange={(e) => update("english_gloss", e.target.value)} />
              {fieldErrors.english_gloss && <p className="text-xs text-red-600">{fieldErrors.english_gloss}</p>}
            </div>
          </div>

          <MetadataField label="Extended Gloss">
            <Textarea value={form.english_gloss_extended ?? ""} onChange={(e) => update("english_gloss_extended", e.target.value)} rows={3} />
          </MetadataField>

          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label>Grammatical Category</Label>
              <Select value={form.category} onValueChange={(v) => update("category", v as LexicalEntryForm["category"])}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>{CATEGORIES.map((c) => <SelectItem key={c} value={c}>{c.replace(/_/g, " ")}</SelectItem>)}</SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Semantic Domain</Label>
              <Select value={form.semantic_domain} onValueChange={(v) => update("semantic_domain", v as LexicalEntryForm["semantic_domain"])}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {Object.entries(SEMANTIC_DOMAIN_LABELS).map(([k, v]) => <SelectItem key={k} value={k}>{v}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>

          <MetadataField label="Alternate Spellings" description="Protocol 12: multiple orthographies">
            <div className="flex gap-2">
              <Input value={altSpelling} onChange={(e) => setAltSpelling(e.target.value)} placeholder="Add spelling variant" />
              <Button type="button" variant="outline" onClick={() => {
                if (altSpelling.trim()) {
                  update("alternate_spellings", [...form.alternate_spellings, altSpelling.trim()]);
                  setAltSpelling("");
                }
              }}>Add</Button>
            </div>
            <div className="flex flex-wrap gap-1 mt-2">
              {form.alternate_spellings.map((s, i) => (
                <Badge key={i} variant="secondary" className="gap-1">
                  {s}
                  <button type="button" onClick={() => update("alternate_spellings", form.alternate_spellings.filter((_, j) => j !== i))}>×</button>
                </Badge>
              ))}
            </div>
          </MetadataField>

          <MetadataField label="Orthographic Spelling Variants">
            {form.spelling_variants.map((v, i) => (
              <div key={i} className="grid gap-2 md:grid-cols-3 mb-2 p-3 border rounded-md bg-stone-50/50">
                <Select value={v.orthography_system ?? "jopson_modern"} onValueChange={(val) => {
                  const next = [...form.spelling_variants];
                  next[i] = { ...next[i], orthography_system: val };
                  update("spelling_variants", next);
                }}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>{ORTHOGRAPHY_SYSTEMS.map((o) => <SelectItem key={o.key} value={o.key}>{o.label}</SelectItem>)}</SelectContent>
                </Select>
                <Input placeholder="Spelling" value={v.spelling} onChange={(e) => {
                  const next = [...form.spelling_variants];
                  next[i] = { ...next[i], spelling: e.target.value };
                  update("spelling_variants", next);
                }} />
                <Button type="button" variant="ghost" size="icon" onClick={() => update("spelling_variants", form.spelling_variants.filter((_, j) => j !== i))}>
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
            ))}
            <Button type="button" variant="outline" size="sm" className="gap-1" onClick={() => update("spelling_variants", [...form.spelling_variants, { spelling: "", is_preferred: false, orthography_system: "jopson_modern" }])}>
              <Plus className="h-3 w-3" /> Add Spelling Variant
            </Button>
          </MetadataField>

          <MetadataField label="Example Sentences">
            {form.example_sentences.map((ex, i) => (
              <div key={i} className="space-y-2 mb-3 p-3 border rounded-md">
                <Input placeholder="Sentence in Narragansett" value={ex.sentence_narragansett} onChange={(e) => {
                  const next = [...form.example_sentences];
                  next[i] = { ...next[i], sentence_narragansett: e.target.value };
                  update("example_sentences", next);
                }} />
                <Input placeholder="English translation" value={ex.sentence_english} onChange={(e) => {
                  const next = [...form.example_sentences];
                  next[i] = { ...next[i], sentence_english: e.target.value };
                  update("example_sentences", next);
                }} />
                <Input placeholder="Literal gloss (optional)" value={ex.literal_gloss ?? ""} onChange={(e) => {
                  const next = [...form.example_sentences];
                  next[i] = { ...next[i], literal_gloss: e.target.value };
                  update("example_sentences", next);
                }} />
                <Button type="button" variant="ghost" size="sm" onClick={() => update("example_sentences", form.example_sentences.filter((_, j) => j !== i))}>Remove</Button>
              </div>
            ))}
            <Button type="button" variant="outline" size="sm" className="gap-1" onClick={() => update("example_sentences", [...form.example_sentences, { sentence_narragansett: "", sentence_english: "" }])}>
              <Plus className="h-3 w-3" /> Add Example Sentence
            </Button>
          </MetadataField>
        </TabsContent>

        {/* LINGUISTIC TAB */}
        <TabsContent value="linguistic" className="space-y-4 mt-6">
          <div className="grid gap-4 md:grid-cols-2">
            <MetadataField label="Phonemic Transcription"><Input value={form.phonemic_transcription ?? ""} onChange={(e) => update("phonemic_transcription", e.target.value)} /></MetadataField>
            <MetadataField label="IPA Transcription"><Input value={form.ipa_transcription ?? ""} onChange={(e) => update("ipa_transcription", e.target.value)} /></MetadataField>
          </div>
          <MetadataField label="Morphological Breakdown"><Textarea value={form.morphological_breakdown ?? ""} onChange={(e) => update("morphological_breakdown", e.target.value)} rows={2} /></MetadataField>
          <MetadataField label="Morpheme Gloss"><Input value={form.morpheme_gloss ?? ""} onChange={(e) => update("morpheme_gloss", e.target.value)} /></MetadataField>
          <MetadataField label="Etymology Notes"><Textarea value={form.etymology_notes ?? ""} onChange={(e) => update("etymology_notes", e.target.value)} rows={3} /></MetadataField>
          <MetadataField label="Etymology Source"><Input value={form.etymology_source ?? ""} onChange={(e) => update("etymology_source", e.target.value)} /></MetadataField>
          <MetadataField label="Usage Notes"><Textarea value={form.usage_notes ?? ""} onChange={(e) => update("usage_notes", e.target.value)} rows={2} /></MetadataField>
          <MetadataField label="Register"><Input value={form.register ?? ""} onChange={(e) => update("register", e.target.value)} placeholder="formal, informal, ceremonial..." /></MetadataField>
          <div className="flex gap-4">
            <label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={form.is_archaic} onChange={(e) => update("is_archaic", e.target.checked)} /> Archaic form</label>
            <label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={form.is_neologism} onChange={(e) => update("is_neologism", e.target.checked)} /> Contemporary neologism</label>
          </div>
        </TabsContent>

        {/* CULTURAL TAB */}
        <TabsContent value="cultural" className="space-y-4 mt-6">
          <MetadataField label="Cultural Context Summary"><Textarea value={form.cultural_context_summary ?? ""} onChange={(e) => update("cultural_context_summary", e.target.value)} rows={4} /></MetadataField>
          <MetadataField label="Ecological Connection" description="Protocol 11 — land and living world"><Textarea value={form.ecological_connection ?? ""} onChange={(e) => update("ecological_connection", e.target.value)} rows={3} /></MetadataField>
          <div className="space-y-2">
            <Label>Spiritual Significance</Label>
            <Select value={form.spiritual_significance} onValueChange={(v) => update("spiritual_significance", v as LexicalEntryForm["spiritual_significance"])}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>{["none", "respectful", "ceremonial", "sacred", "restricted"].map((s) => <SelectItem key={s} value={s}>{s}</SelectItem>)}</SelectContent>
            </Select>
          </div>
          <MetadataField label="Seasonal Usage">
            <div className="flex flex-wrap gap-3">
              {SEASONS.map((s) => (
                <label key={s} className="flex items-center gap-1.5 text-sm">
                  <input type="checkbox" checked={form.seasonal_usage.includes(s)} onChange={(e) => {
                    update("seasonal_usage", e.target.checked ? [...form.seasonal_usage, s] : form.seasonal_usage.filter((x) => x !== s));
                  }} />
                  {s.replace(/_/g, " ")}
                </label>
              ))}
            </div>
          </MetadataField>

          <MetadataField label="Cultural Context Entries" description="Link to Mother Earth, ceremony, TEK">
            {form.cultural_contexts.map((ctx, i) => (
              <div key={i} className="space-y-2 mb-4 p-4 border rounded-lg border-emerald-900/10">
                <Select value={ctx.context_type} onValueChange={(v) => {
                  const next = [...form.cultural_contexts];
                  next[i] = { ...next[i], context_type: v as CulturalContextInput["context_type"] };
                  update("cultural_contexts", next);
                }}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {Object.entries(CONTEXT_TYPE_LABELS).map(([k, v]) => <SelectItem key={k} value={k}>{v}</SelectItem>)}
                  </SelectContent>
                </Select>
                <Input placeholder="Context title" value={ctx.title} onChange={(e) => {
                  const next = [...form.cultural_contexts];
                  next[i] = { ...next[i], title: e.target.value };
                  update("cultural_contexts", next);
                }} />
                <Textarea placeholder="Cultural narrative (minimum 10 characters)" value={ctx.narrative} rows={3} onChange={(e) => {
                  const next = [...form.cultural_contexts];
                  next[i] = { ...next[i], narrative: e.target.value };
                  update("cultural_contexts", next);
                }} />
                <Input placeholder="Mother Earth connection (optional)" value={ctx.mother_earth_connection ?? ""} onChange={(e) => {
                  const next = [...form.cultural_contexts];
                  next[i] = { ...next[i], mother_earth_connection: e.target.value };
                  update("cultural_contexts", next);
                }} />
                <Input placeholder="TEK notes (optional)" value={ctx.tek_notes ?? ""} onChange={(e) => {
                  const next = [...form.cultural_contexts];
                  next[i] = { ...next[i], tek_notes: e.target.value };
                  update("cultural_contexts", next);
                }} />
                <Button type="button" variant="ghost" size="sm" onClick={() => update("cultural_contexts", form.cultural_contexts.filter((_, j) => j !== i))}>Remove Context</Button>
              </div>
            ))}
            <Button type="button" variant="outline" size="sm" className="gap-1" onClick={() => update("cultural_contexts", [...form.cultural_contexts, emptyContext()])}>
              <Plus className="h-3 w-3" /> Add Cultural Context
            </Button>
          </MetadataField>
        </TabsContent>

        {/* GOVERNANCE TAB */}
        <TabsContent value="governance" className="space-y-4 mt-6">
          <div className="space-y-2">
            <Label>Primary Knowledge Keeper (Speaker)</Label>
            <Select value={form.primary_speaker_id ?? ""} onValueChange={(v) => update("primary_speaker_id", v || undefined)}>
              <SelectTrigger><SelectValue placeholder="Who taught this word?" /></SelectTrigger>
              <SelectContent>
                {speakers.map((s) => <SelectItem key={s.id} value={s.id}>{s.display_name} — {s.role}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>Visibility</Label>
            <Select value={form.visibility} onValueChange={(v) => update("visibility", v as LexicalEntryForm["visibility"])}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>{["public", "clan", "family", "elders_only", "sacred"].map((v) => <SelectItem key={v} value={v}>{v}</SelectItem>)}</SelectContent>
            </Select>
            {fieldErrors.visibility && <p className="text-xs text-red-600">{fieldErrors.visibility}</p>}
          </div>
          <label className="flex items-center gap-2 text-sm p-3 border rounded-md border-amber-200 bg-amber-50/50">
            <input type="checkbox" checked={form.is_sacred} onChange={(e) => update("is_sacred", e.target.checked)} />
            Sacred content — requires elder review (Protocol 4)
          </label>
          <p className="text-xs text-muted-foreground leading-relaxed">
            All entries enter the approval workflow upon save. Entries marked sacred or with
            spiritual significance &quot;sacred&quot; are automatically flagged for elder review.
          </p>
        </TabsContent>
      </Tabs>
    </div>
  );
}