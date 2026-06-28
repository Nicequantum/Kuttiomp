import { AlertCircle, WifiOff } from "lucide-react";

interface ApiStatusMessageProps {
  title: string;
  message: string;
  variant?: "unreachable" | "empty";
}

export function ApiStatusMessage({
  title,
  message,
  variant = "unreachable",
}: ApiStatusMessageProps) {
  const Icon = variant === "unreachable" ? WifiOff : AlertCircle;

  return (
    <div
      className={`col-span-full rounded-lg border px-4 py-4 ${
        variant === "unreachable"
          ? "border-amber-200 bg-amber-50 text-amber-950"
          : "border-stone-200 bg-stone-50 text-stone-700"
      }`}
    >
      <div className="flex items-start gap-3">
        <Icon className="mt-0.5 h-5 w-5 shrink-0" />
        <div>
          <p className="text-sm font-medium">{title}</p>
          <p className="mt-1 text-sm leading-relaxed opacity-90">{message}</p>
        </div>
      </div>
    </div>
  );
}