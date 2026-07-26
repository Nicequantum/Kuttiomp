"use client";

import * as React from "react";
import { MODE_TOKENS, type AdminLearningMode } from "./modes";
import { useModeTheme } from "./mode-theme-provider";

/**
 * Mode switcher — dignified label list, no playful pills or gamified chrome (Protocol 10).
 */
export function ModeSwitcher({ className }: { className?: string }) {
  const { mode, setMode, modes, tokens } = useModeTheme();

  return (
    <div
      className={className}
      role="group"
      aria-label="Learning path visual mode for this portal"
    >
      <p
        className="mb-1 font-medium text-muted-foreground"
        style={{ fontSize: "var(--mode-font-body)" }}
      >
        Portal visual path
      </p>
      <div className="flex flex-wrap gap-2">
        {modes.map((id) => {
          const t = MODE_TOKENS[id];
          const active = id === mode;
          return (
            <button
              key={id}
              type="button"
              onClick={() => setMode(id as AdminLearningMode)}
              aria-pressed={active}
              title={t.description}
              className="rounded-[var(--radius)] border px-3 py-2 text-left transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-ring"
              style={{
                fontSize: "var(--mode-font-body)",
                minHeight: "2.75rem",
                borderColor: active
                  ? `hsl(${tokens.primary})`
                  : `hsl(${tokens.border})`,
                backgroundColor: active
                  ? `hsl(${tokens.primary})`
                  : `hsl(${tokens.card})`,
                color: active
                  ? `hsl(${tokens.primaryForeground})`
                  : `hsl(${tokens.foreground})`,
                fontWeight: active ? 600 : 500,
              }}
            >
              {t.label}
            </button>
          );
        })}
      </div>
      <p
        className="mt-2 text-muted-foreground"
        style={{ fontSize: "calc(var(--mode-font-body) * 0.9)" }}
      >
        {tokens.description} Land accent: {tokens.landAccentName}.
      </p>
    </div>
  );
}
