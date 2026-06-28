import * as React from "react";
import { cn } from "./utils";

interface EmptyStateProps {
  icon?: React.ReactNode;
  title: string;
  description?: string;
  action?: React.ReactNode;
  className?: string;
}

export function EmptyState({
  icon,
  title,
  description,
  action,
  className,
}: EmptyStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center rounded-lg border border-dashed border-stone-200 bg-stone-50/50 px-6 py-14 text-center",
        className
      )}
    >
      {icon && <div className="mb-4 text-stone-400">{icon}</div>}
      <h3 className="font-serif text-lg text-stone-800">{title}</h3>
      {description && (
        <p className="mt-2 max-w-md text-sm text-stone-500 leading-relaxed">
          {description}
        </p>
      )}
      {action && <div className="mt-6">{action}</div>}
    </div>
  );
}