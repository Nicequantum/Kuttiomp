"use client";

import * as React from "react";
import { useModeThemeOptional } from "./mode-theme-provider";

/**
 * Protocol-aware surface for admin sections.
 * Prefer semantic HTML + CSS variables so mode changes re-theme instantly.
 */
export function ModePanel({
  children,
  className,
  as: Tag = "section",
  ariaLabel,
}: {
  children: React.ReactNode;
  className?: string;
  as?: "section" | "div" | "article";
  ariaLabel?: string;
}) {
  useModeThemeOptional();
  return (
    <Tag
      aria-label={ariaLabel}
      className={className}
      style={{
        backgroundColor: "hsl(var(--card))",
        color: "hsl(var(--card-foreground))",
        border: "1.5px solid hsl(var(--border))",
        borderRadius: "var(--radius)",
        padding: "1.25rem",
        fontSize: "var(--mode-font-content)",
        lineHeight: 1.5,
      }}
    >
      {children}
    </Tag>
  );
}

export function ModePageTitle({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <h1
      className={className}
      style={{
        fontSize: "var(--mode-font-title)",
        fontWeight: 600,
        color: "hsl(var(--foreground))",
        lineHeight: 1.25,
        fontFamily: "var(--font-serif), Georgia, serif",
      }}
    >
      {children}
    </h1>
  );
}

export function ModeBodyText({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <p
      className={className}
      style={{
        fontSize: "var(--mode-font-content)",
        color: "hsl(var(--muted-foreground))",
        lineHeight: 1.55,
      }}
    >
      {children}
    </p>
  );
}

/** Absolute-count metric row — never points/streaks (Protocol 10). */
export function ModeMetricRow({
  label,
  value,
}: {
  label: string;
  value: string | number;
}) {
  return (
    <div
      className="flex justify-between gap-4 border-b border-border py-2 last:border-0"
      style={{ fontSize: "var(--mode-font-content)" }}
    >
      <span>{label}</span>
      <strong className="tabular-nums">{value}</strong>
    </div>
  );
}
