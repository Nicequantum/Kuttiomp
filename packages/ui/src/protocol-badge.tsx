import * as React from "react";
import { CULTURAL_PROTOCOLS } from "@kuttiomp/types";
import { cn } from "./utils";

interface ProtocolBadgeProps {
  protocolId: number;
  className?: string;
}

export function ProtocolBadge({ protocolId, className }: ProtocolBadgeProps) {
  const protocol = CULTURAL_PROTOCOLS.find((p) => p.id === protocolId);
  if (!protocol) return null;

  return (
    <span
      className={cn(
        "inline-flex items-center rounded border border-emerald-800/20 bg-emerald-50 px-2 py-0.5 text-xs font-medium text-emerald-900",
        className
      )}
      title={protocol.principle}
    >
      P{protocol.id}: {protocol.title}
    </span>
  );
}