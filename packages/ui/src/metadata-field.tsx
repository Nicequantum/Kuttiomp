import * as React from "react";
import { cn } from "./utils";

interface MetadataFieldProps {
  label: string;
  value?: React.ReactNode;
  description?: string;
  required?: boolean;
  className?: string;
  children?: React.ReactNode;
}

export function MetadataField({
  label,
  value,
  description,
  required,
  className,
  children,
}: MetadataFieldProps) {
  return (
    <div className={cn("space-y-1.5", className)}>
      <label className="text-xs font-semibold uppercase tracking-wider text-stone-500">
        {label}
        {required && <span className="ml-0.5 text-red-600">*</span>}
      </label>
      {description && (
        <p className="text-xs text-stone-400 leading-relaxed">{description}</p>
      )}
      {children ?? (
        <div className="text-sm text-stone-800 leading-relaxed">{value ?? "—"}</div>
      )}
    </div>
  );
}