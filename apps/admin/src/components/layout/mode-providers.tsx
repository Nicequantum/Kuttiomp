"use client";

import { ModeThemeProvider } from "@kuttiomp/admin-design-system";

/**
 * Client boundary for mode tokens (localStorage + document CSS variables).
 * This serves our people by letting Keepers preview each generational path
 * without leaving the portal shell.
 */
export function ModeProviders({ children }: { children: React.ReactNode }) {
  return <ModeThemeProvider>{children}</ModeThemeProvider>;
}
