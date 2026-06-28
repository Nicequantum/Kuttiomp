import * as React from "react";
import { cn } from "./utils";

interface SacredLanguageNoticeProps {
  className?: string;
  compact?: boolean;
}

export function SacredLanguageNotice({ className, compact }: SacredLanguageNoticeProps) {
  if (compact) {
    return (
      <p className={cn("text-xs text-emerald-900/70 italic", className)}>
        Narragansett is a living, sacred language — handle every word with respect.
      </p>
    );
  }
  return (
    <div
      className={cn(
        "rounded-lg border border-emerald-900/15 bg-gradient-to-r from-emerald-50/80 to-stone-50 px-4 py-3",
        className
      )}
    >
      <p className="text-xs uppercase tracking-widest text-emerald-800/60 font-medium mb-1">
        Cultural Remembrance
      </p>
      <p className="text-sm text-stone-700 leading-relaxed">
        Narragansett is not merely data to be catalogued — it is a sacred, living language
        carried by Knowledge Keepers across generations. Every entry, every recording, every
        teaching on this platform honors that truth.
      </p>
    </div>
  );
}