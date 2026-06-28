import * as React from "react";
import { cn } from "./utils";

interface KuttiompBrandProps {
  subtitle?: string;
  className?: string;
}

export function KuttiompBrand({ subtitle, className }: KuttiompBrandProps) {
  return (
    <div className={cn("flex items-center gap-3", className)}>
      <div className="flex h-10 w-10 items-center justify-center rounded-full bg-emerald-800 text-white font-serif text-sm shadow-sm">
        K
      </div>
      <div>
        <h1 className="font-serif text-xl font-semibold text-stone-800 tracking-tight">
          Kuttiomp
        </h1>
        {subtitle && (
          <p className="text-xs text-stone-500 tracking-wide uppercase">
            {subtitle}
          </p>
        )}
      </div>
    </div>
  );
}