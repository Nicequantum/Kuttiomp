"use client";

import { UserButton } from "@clerk/nextjs";
import { useModeTheme } from "@kuttiomp/admin-design-system";

interface HeaderProps {
  title: string;
  description?: string;
}

export function Header({ title, description }: HeaderProps) {
  const { tokens } = useModeTheme();

  return (
    <header
      className="flex min-h-16 items-center justify-between border-b bg-card px-6 py-3 md:px-8"
      style={{ borderColor: `hsl(${tokens.border})` }}
    >
      <div className="min-w-0 pr-4">
        <h2
          className="font-semibold text-foreground"
          style={{ fontSize: "var(--mode-font-title)" }}
        >
          {title}
        </h2>
        {description ? (
          <p
            className="text-muted-foreground"
            style={{ fontSize: "var(--mode-font-body)" }}
          >
            {description}
          </p>
        ) : null}
      </div>
      <div className="flex shrink-0 items-center gap-3">
        <span
          className="hidden rounded-[var(--radius)] border px-2 py-1 text-muted-foreground sm:inline"
          style={{
            fontSize: "calc(var(--mode-font-body) * 0.85)",
            borderColor: `hsl(${tokens.border})`,
          }}
        >
          {tokens.label}
        </span>
        <UserButton afterSignOutUrl="/sign-in" />
      </div>
    </header>
  );
}
