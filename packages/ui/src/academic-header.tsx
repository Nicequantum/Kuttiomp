import * as React from "react";
import { cn } from "./utils";

interface AcademicHeaderProps {
  title: string;
  subtitle?: string;
  eyebrow?: string;
  actions?: React.ReactNode;
  className?: string;
}

export function AcademicHeader({
  title,
  subtitle,
  eyebrow,
  actions,
  className,
}: AcademicHeaderProps) {
  return (
    <header
      className={cn(
        "border-b border-stone-200 bg-stone-50/80 px-8 py-6 backdrop-blur-sm",
        className
      )}
    >
      <div className="flex items-start justify-between gap-4">
        <div className="space-y-1">
          {eyebrow && (
            <p className="text-xs font-medium uppercase tracking-widest text-emerald-800/70">
              {eyebrow}
            </p>
          )}
          <h2 className="font-serif text-2xl font-semibold text-stone-900">
            {title}
          </h2>
          {subtitle && (
            <p className="max-w-2xl text-sm leading-relaxed text-stone-600">
              {subtitle}
            </p>
          )}
        </div>
        {actions && <div className="flex shrink-0 items-center gap-2">{actions}</div>}
      </div>
    </header>
  );
}