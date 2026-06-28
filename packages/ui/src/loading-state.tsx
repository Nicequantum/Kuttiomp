import * as React from "react";
import { Loader2 } from "lucide-react";
import { cn } from "./utils";

interface LoadingStateProps {
  message?: string;
  className?: string;
}

export function LoadingState({
  message = "Loading knowledge...",
  className,
}: LoadingStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center gap-3 py-16 text-stone-500",
        className
      )}
      role="status"
      aria-live="polite"
    >
      <Loader2 className="h-8 w-8 animate-spin text-emerald-800/60" />
      <p className="text-sm font-medium">{message}</p>
    </div>
  );
}