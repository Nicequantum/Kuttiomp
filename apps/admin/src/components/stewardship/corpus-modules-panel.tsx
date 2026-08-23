"use client";

import { useCallback, useEffect, useState } from "react";
import type { CorpusDesk, CorpusModules } from "@kuttiomp/types";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { api, ApiError } from "@/lib/api";
import { cn } from "@/lib/utils";

const MODULES: Array<{
  key: keyof CorpusModules;
  title: string;
  short: string;
  description: string;
  offWarning: string;
}> = [
  {
    key: "feedHistorical",
    title: "Historical seed",
    short: "1643",
    description:
      "Roger Williams’ attested words from A Key into the Language of America. The old language, left true.",
    offWarning:
      "Williams 1643 words will leave the learner desk until this module is turned back on. The records stay in the Keeper desk.",
  },
  {
    key: "feedApprovedLiving",
    title: "Approved living words",
    short: "Released",
    description:
      "Forge words Sharente has approved and marked production-ready. Real keeper knowledge — new 21st-century stems, not calques.",
    offWarning:
      "Released living words will leave the learner lexicon until this module is turned back on. Approvals and dossiers are not undone.",
  },
  {
    key: "feedForgeDemoMerge",
    title: "Forge teaching feed",
    short: "Demo merge",
    description:
      "Merge unapproved, demo-visible Forge drafts into the learner lexicon so Keepers can walk the method. This is the module that converts the public desk from demo to real keeper knowledge. The Forge itself stays Keepers-only either way.",
    offWarning:
      "Learners will immediately stop seeing unapproved Forge words. Historical seed and production-ready living words stay, if those modules are on.",
  },
];

const PRESETS: Array<{
  id: "demo_teaching" | "keeper_knowledge";
  label: string;
  description: string;
  modules: CorpusModules;
}> = [
  {
    id: "demo_teaching",
    label: "Demo teaching",
    description:
      "All three feeds on. Proposed Forge words may appear, clearly marked, so the method can be taught.",
    modules: {
      feedHistorical: true,
      feedApprovedLiving: true,
      feedForgeDemoMerge: true,
    },
  },
  {
    id: "keeper_knowledge",
    label: "Real keeper knowledge",
    description:
      "Teaching feed off. Learners see only 1643 seed and words Sharente has formally released.",
    modules: {
      feedHistorical: true,
      feedApprovedLiving: true,
      feedForgeDemoMerge: false,
    },
  },
];

function matchingPreset(modules: CorpusModules) {
  return (
    PRESETS.find(
      (preset) =>
        preset.modules.feedHistorical === modules.feedHistorical &&
        preset.modules.feedApprovedLiving === modules.feedApprovedLiving &&
        preset.modules.feedForgeDemoMerge === modules.feedForgeDemoMerge,
    )?.id ?? null
  );
}

export function CorpusModulesPanel() {
  const [desk, setDesk] = useState<CorpusDesk | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    try {
      const next = (await api.forge.corpus()) as CorpusDesk;
      setDesk(next);
      setError(null);
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Could not load corpus modules.");
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  async function apply(patch: Partial<CorpusModules>) {
    if (!desk) return;
    const turningOffTeaching =
      patch.feedForgeDemoMerge === false && desk.modules.feedForgeDemoMerge;
    if (
      turningOffTeaching &&
      !window.confirm(
        "Convert to real keeper knowledge? Learners will immediately stop seeing unapproved Forge words.",
      )
    ) {
      return;
    }
    setBusy(true);
    try {
      const next = (await api.forge.updateCorpus(patch)) as CorpusDesk;
      setDesk(next);
      setError(null);
    } catch (err) {
      setError(
        err instanceof ApiError
          ? err.message
          : "Only Sharente / an elder session can change corpus modules.",
      );
    } finally {
      setBusy(false);
    }
  }

  function requestToggle(key: keyof CorpusModules, next: boolean) {
    const meta = MODULES.find((mod) => mod.key === key);
    if (!next && meta && !window.confirm(`Turn off ${meta.title.toLowerCase()}? ${meta.offWarning}`)) {
      return;
    }
    void apply({ [key]: next });
  }

  const modules = desk?.modules;
  const preview = desk?.preview;
  const activePreset = modules ? matchingPreset(modules) : null;

  return (
    <section aria-label="Learner feed modules" className="space-y-4">
      <Card>
        <CardHeader>
          <CardTitle className="font-serif">Learner feed modules</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3 text-sm">
          <p className="text-muted-foreground" style={{ fontSize: "var(--mode-font-body)" }}>
            Independent on/off modules assemble the public desk. Flip the Forge teaching feed
            off to convert from demo to real keeper knowledge. The Forge itself never becomes a
            public minting tool.
          </p>
          {error ? (
            <p className="text-destructive" role="alert">
              {error}
            </p>
          ) : null}
          <p className="text-muted-foreground">
            Contract for kuttiomp-learn:{" "}
            <strong className="text-foreground">{desk?.corpusMode ?? "…"}</strong>
          </p>
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            <FeedStat label="1643 seed" value={preview?.historical} on={modules?.feedHistorical} />
            <FeedStat
              label="Released living"
              value={preview?.approvedLiving}
              on={modules?.feedApprovedLiving}
            />
            <FeedStat
              label="Teaching drafts"
              value={preview?.teachingDrafts}
              on={modules?.feedForgeDemoMerge}
            />
            <FeedStat label="On the public desk" value={preview?.learnerTotal} emphasize />
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-3 sm:grid-cols-2">
        {PRESETS.map((preset) => {
          const active = activePreset === preset.id;
          return (
            <button
              key={preset.id}
              type="button"
              disabled={busy || !desk}
              onClick={() => void apply(preset.modules)}
              className={cn(
                "rounded-lg border p-4 text-left transition-colors",
                active ? "border-primary bg-muted/60" : "border-border hover:bg-muted/40",
                (busy || !desk) && "opacity-60",
              )}
            >
              <p className="font-serif text-lg leading-tight">{preset.label}</p>
              <p className="mt-2 text-sm text-muted-foreground">{preset.description}</p>
              {active ? (
                <p className="mt-3 text-xs tracking-wide text-muted-foreground uppercase">Active</p>
              ) : null}
            </button>
          );
        })}
      </div>

      {MODULES.map((mod) => {
        const on = modules?.[mod.key] ?? true;
        const count =
          mod.key === "feedHistorical"
            ? preview?.historical
            : mod.key === "feedApprovedLiving"
              ? preview?.approvedLiving
              : preview?.teachingDrafts;
        return (
          <Card
            key={mod.key}
            className={cn(mod.key === "feedForgeDemoMerge" && "border-primary/40")}
          >
            <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-start sm:justify-between">
              <div className="min-w-0">
                <p className="text-xs tracking-[0.16em] text-muted-foreground uppercase">
                  {mod.short}
                  {mod.key === "feedForgeDemoMerge" ? " · the convert switch" : ""}
                </p>
                <h3 className="mt-1 font-serif text-xl leading-tight">{mod.title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
                  {mod.description}
                </p>
                <p className="mt-2 text-xs text-muted-foreground">
                  {count ?? "—"} rows ready · {on ? "currently feeding learners" : "currently held back"}
                </p>
              </div>
              <div className="flex shrink-0 gap-2">
                <Button
                  type="button"
                  size="sm"
                  variant={on ? "default" : "outline"}
                  disabled={busy || !desk || on}
                  onClick={() => requestToggle(mod.key, true)}
                >
                  On
                </Button>
                <Button
                  type="button"
                  size="sm"
                  variant={!on ? "default" : "outline"}
                  disabled={busy || !desk || !on}
                  onClick={() => requestToggle(mod.key, false)}
                >
                  Off
                </Button>
              </div>
            </CardContent>
          </Card>
        );
      })}

      <Card>
        <CardHeader>
          <CardTitle className="font-serif">Module history</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {!desk || desk.audit.length === 0 ? (
            <p className="text-sm text-muted-foreground">No module changes recorded yet.</p>
          ) : (
            desk.audit.map((row) => (
              <div key={row.id} className="flex items-start justify-between gap-3 text-sm">
                <p>{row.summary}</p>
                <span className="shrink-0 text-xs text-muted-foreground">
                  {row.created_at ? new Date(row.created_at).toLocaleString() : ""}
                </span>
              </div>
            ))
          )}
        </CardContent>
      </Card>
    </section>
  );
}

function FeedStat({
  label,
  value,
  on,
  emphasize,
}: {
  label: string;
  value?: number;
  on?: boolean;
  emphasize?: boolean;
}) {
  return (
    <div
      className={cn(
        "rounded-lg border border-border px-3 py-3",
        emphasize && "bg-muted/60",
        on === false && "opacity-50",
      )}
    >
      <p className="text-xs tracking-wide text-muted-foreground uppercase">{label}</p>
      <p className="mt-1 font-serif text-2xl tabular-nums">
        {on === false ? 0 : (value ?? "—")}
      </p>
    </div>
  );
}
