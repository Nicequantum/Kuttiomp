"use client";

import { useModeTheme } from "@kuttiomp/admin-design-system";

/**
 * Mode-aware welcome header for the Keeper dashboard (MAD §5 + Protocol 10).
 */
export function DashboardHero() {
  const { tokens } = useModeTheme();

  return (
    <header
      className="border-b px-6 py-6 backdrop-blur-sm md:px-8"
      style={{
        borderColor: `hsl(${tokens.border})`,
        backgroundColor: `hsl(${tokens.secondary} / 0.55)`,
      }}
    >
      <p
        className="font-medium uppercase tracking-widest text-primary"
        style={{ fontSize: "calc(var(--mode-font-body) * 0.8)" }}
      >
        Narragansett Language Revitalization · {tokens.label}
      </p>
      <h1
        className="mt-1 font-serif font-semibold text-foreground"
        style={{ fontSize: "var(--mode-font-title)" }}
      >
        Wunnegan — Welcome, Knowledge Keeper
      </h1>
      <p
        className="mt-2 max-w-3xl text-muted-foreground"
        style={{ fontSize: "var(--mode-font-content)", lineHeight: 1.55 }}
      >
        Kuttiomp is the gathering place where language lives in relationship —
        through the voices of Grandmother Comus, Grandfather, Sharente, parents,
        siblings, and clan members. Switch the portal visual path in the sidebar
        to preview how each generation experiences the work.
      </p>
    </header>
  );
}
