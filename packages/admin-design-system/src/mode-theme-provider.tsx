"use client";

import * as React from "react";
import {
  ADMIN_MODES,
  DEFAULT_ADMIN_MODE,
  MODE_TOKENS,
  type AdminLearningMode,
  type ModeTokens,
  isAdminLearningMode,
} from "./modes";

const STORAGE_KEY = "kuttiomp.admin.learningMode";

type ModeThemeContextValue = {
  mode: AdminLearningMode;
  tokens: ModeTokens;
  setMode: (mode: AdminLearningMode) => void;
  modes: readonly AdminLearningMode[];
};

const ModeThemeContext = React.createContext<ModeThemeContextValue | null>(null);

function applyTokensToDocument(tokens: ModeTokens) {
  if (typeof document === "undefined") return;
  const root = document.documentElement;
  root.setAttribute("data-admin-mode", tokens.id);
  root.style.setProperty("--background", tokens.background);
  root.style.setProperty("--foreground", tokens.foreground);
  root.style.setProperty("--card", tokens.card);
  root.style.setProperty("--card-foreground", tokens.cardForeground);
  root.style.setProperty("--popover", tokens.card);
  root.style.setProperty("--popover-foreground", tokens.cardForeground);
  root.style.setProperty("--primary", tokens.primary);
  root.style.setProperty("--primary-foreground", tokens.primaryForeground);
  root.style.setProperty("--secondary", tokens.secondary);
  root.style.setProperty("--secondary-foreground", tokens.secondaryForeground);
  root.style.setProperty("--muted", tokens.muted);
  root.style.setProperty("--muted-foreground", tokens.mutedForeground);
  root.style.setProperty("--accent", tokens.accent);
  root.style.setProperty("--accent-foreground", tokens.accentForeground);
  root.style.setProperty("--border", tokens.border);
  root.style.setProperty("--input", tokens.border);
  root.style.setProperty("--ring", tokens.ring);
  root.style.setProperty("--radius", tokens.radius);
  root.style.setProperty("--mode-font-body", tokens.fontBody);
  root.style.setProperty("--mode-font-title", tokens.fontTitle);
  root.style.setProperty("--mode-font-content", tokens.fontContent);
  root.style.setProperty("--mode-sidebar", tokens.sidebar);
  root.style.setProperty("--mode-sidebar-border", tokens.sidebarBorder);
  root.style.setProperty("--mode-nav-active", tokens.navActive);
  root.style.setProperty("--mode-nav-active-fg", tokens.navActiveFg);
  root.style.setProperty("--mode-nav-idle", tokens.navIdle);
  root.style.setProperty("--mode-surface-tint", tokens.surfaceTint);
}

export function ModeThemeProvider({
  children,
  initialMode = DEFAULT_ADMIN_MODE,
}: {
  children: React.ReactNode;
  initialMode?: AdminLearningMode;
}) {
  const [mode, setModeState] = React.useState<AdminLearningMode>(initialMode);

  React.useEffect(() => {
    try {
      const stored = window.localStorage.getItem(STORAGE_KEY);
      if (stored && isAdminLearningMode(stored)) {
        setModeState(stored);
      }
    } catch {
      // offline / private mode — keep default
    }
  }, []);

  React.useEffect(() => {
    applyTokensToDocument(MODE_TOKENS[mode]);
    try {
      window.localStorage.setItem(STORAGE_KEY, mode);
    } catch {
      // ignore
    }
  }, [mode]);

  const setMode = React.useCallback((next: AdminLearningMode) => {
    setModeState(next);
  }, []);

  const value = React.useMemo(
    () => ({
      mode,
      tokens: MODE_TOKENS[mode],
      setMode,
      modes: ADMIN_MODES,
    }),
    [mode, setMode]
  );

  return (
    <ModeThemeContext.Provider value={value}>{children}</ModeThemeContext.Provider>
  );
}

export function useModeTheme(): ModeThemeContextValue {
  const ctx = React.useContext(ModeThemeContext);
  if (!ctx) {
    throw new Error("useModeTheme must be used within ModeThemeProvider");
  }
  return ctx;
}

/** Safe hook for components that may render outside the provider (tests). */
export function useModeThemeOptional(): ModeThemeContextValue | null {
  return React.useContext(ModeThemeContext);
}
