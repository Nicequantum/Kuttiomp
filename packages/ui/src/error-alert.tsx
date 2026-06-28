import * as React from "react";
import { AlertCircle } from "lucide-react";
import { cn } from "./utils";

interface ErrorAlertProps {
  title?: string;
  message: string;
  onRetry?: () => void;
  className?: string;
}

export function ErrorAlert({
  title = "Something went wrong",
  message,
  onRetry,
  className,
}: ErrorAlertProps) {
  return (
    <div
      className={cn(
        "rounded-lg border border-red-200 bg-red-50/80 px-4 py-3",
        className
      )}
      role="alert"
    >
      <div className="flex gap-3">
        <AlertCircle className="h-5 w-5 shrink-0 text-red-700" />
        <div className="flex-1">
          <p className="text-sm font-medium text-red-900">{title}</p>
          <p className="mt-1 text-sm text-red-800/80">{message}</p>
          {onRetry && (
            <button
              type="button"
              onClick={onRetry}
              className="mt-2 text-sm font-medium text-red-900 underline hover:no-underline"
            >
              Try again
            </button>
          )}
        </div>
      </div>
    </div>
  );
}