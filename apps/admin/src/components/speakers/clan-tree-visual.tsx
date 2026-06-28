"use client";

import { useState } from "react";
import { ChevronDown, ChevronRight, Crown, Heart, Users, Sparkles } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { SPEAKER_ROLE_LABELS } from "@kuttiomp/types";
import { cn } from "@/lib/utils";

interface TreeNode {
  id: string;
  display_name: string;
  role: string;
  generation?: string;
  is_elder?: boolean;
  is_two_spirit?: boolean;
  cultural_authority?: string;
  children?: TreeNode[];
}

const ROLE_ICONS: Record<string, React.ReactNode> = {
  grandmother: <Crown className="h-3.5 w-3.5 text-amber-700" />,
  grandfather: <Crown className="h-3.5 w-3.5 text-amber-700" />,
  sharente: <Sparkles className="h-3.5 w-3.5 text-sky-700" />,
  parent: <Heart className="h-3.5 w-3.5 text-rose-600" />,
  sibling: <Users className="h-3.5 w-3.5 text-stone-500" />,
};

function TreeNodeComponent({ node, depth = 0 }: { node: TreeNode; depth?: number }) {
  const [expanded, setExpanded] = useState(depth < 2);
  const hasChildren = node.children && node.children.length > 0;
  const roleLabel = SPEAKER_ROLE_LABELS[node.role as keyof typeof SPEAKER_ROLE_LABELS] || node.role;

  return (
    <div className="relative">
      <div
        className={cn(
          "group flex items-center gap-2 rounded-lg border border-transparent px-3 py-2.5 transition-colors hover:border-stone-200 hover:bg-stone-50",
          depth === 0 && "border-stone-200 bg-white shadow-sm"
        )}
        style={{ marginLeft: depth * 24 }}
      >
        {hasChildren ? (
          <button
            onClick={() => setExpanded(!expanded)}
            className="flex h-5 w-5 items-center justify-center rounded text-stone-400 hover:bg-stone-100"
          >
            {expanded ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
          </button>
        ) : (
          <span className="w-5" />
        )}

        {ROLE_ICONS[node.role] ?? <Users className="h-3.5 w-3.5 text-stone-400" />}

        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="font-medium text-stone-900">{node.display_name}</span>
            <Badge variant="secondary" className="text-xs">{roleLabel}</Badge>
            {node.is_elder && <Badge variant="elder" className="text-xs">Elder</Badge>}
            {node.is_two_spirit && <Badge variant="sharente" className="text-xs">Sharente</Badge>}
          </div>
          {node.generation && (
            <p className="text-xs text-stone-500 mt-0.5 capitalize">{node.generation} generation</p>
          )}
        </div>
      </div>

      {expanded && hasChildren && (
        <div className="relative ml-3 border-l-2 border-emerald-800/15 pl-2 mt-1 space-y-1">
          {node.children!.map((child) => (
            <TreeNodeComponent key={child.id} node={child} depth={depth + 1} />
          ))}
        </div>
      )}
    </div>
  );
}

interface ClanTreeVisualProps {
  nodes: TreeNode[];
  clanName?: string;
}

export function ClanTreeVisual({ nodes, clanName }: ClanTreeVisualProps) {
  return (
    <div className="space-y-4">
      {clanName && (
        <div className="rounded-lg bg-emerald-900/5 border border-emerald-900/10 px-4 py-3">
          <p className="text-xs uppercase tracking-widest text-emerald-800/60 font-medium">Clan</p>
          <p className="font-serif text-lg text-stone-800">{clanName}</p>
        </div>
      )}
      <div className="space-y-2">
        {nodes.map((node) => (
          <TreeNodeComponent key={node.id} node={node} />
        ))}
      </div>
    </div>
  );
}