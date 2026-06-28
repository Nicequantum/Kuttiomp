"use client";

import { useState } from "react";
import { ChevronDown, ChevronRight, Crown, Heart, Users, Sparkles, TreeDeciduous } from "lucide-react";
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
  clan_member: <Users className="h-3.5 w-3.5 text-emerald-700" />,
};

function TreeNodeComponent({ node, depth = 0 }: { node: TreeNode; depth?: number }) {
  const [expanded, setExpanded] = useState(depth < 2);
  const hasChildren = node.children && node.children.length > 0;
  const roleLabel = SPEAKER_ROLE_LABELS[node.role as keyof typeof SPEAKER_ROLE_LABELS] || node.role;

  return (
    <div className="relative">
      <div
        className={cn(
          "group flex items-center gap-2 rounded-lg border px-3 py-2.5 transition-all hover:shadow-sm",
          depth === 0
            ? "border-emerald-900/20 bg-white shadow-sm"
            : "border-transparent hover:border-stone-200 hover:bg-stone-50/80"
        )}
        style={{ marginLeft: depth * 20 }}
      >
        {hasChildren ? (
          <button
            type="button"
            onClick={() => setExpanded(!expanded)}
            className="flex h-6 w-6 items-center justify-center rounded-full text-stone-400 hover:bg-emerald-50 hover:text-emerald-800"
            aria-label={expanded ? "Collapse" : "Expand"}
          >
            {expanded ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
          </button>
        ) : (
          <span className="w-6 h-6 flex items-center justify-center">
            <span className="h-1.5 w-1.5 rounded-full bg-emerald-800/30" />
          </span>
        )}

        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-stone-100">
          {ROLE_ICONS[node.role] ?? <Users className="h-3.5 w-3.5 text-stone-400" />}
        </div>

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
        <div className="relative ml-5 mt-1 space-y-1 border-l-2 border-emerald-800/15 pl-3">
          {node.children!.map((child) => (
            <TreeNodeComponent key={child.id} node={child} depth={depth + 1} />
          ))}
        </div>
      )}
    </div>
  );
}

function ClanLegend() {
  return (
    <div className="flex flex-wrap gap-4 text-xs text-stone-500 border-t border-stone-100 pt-4 mt-4">
      <span className="flex items-center gap-1"><Crown className="h-3 w-3 text-amber-700" /> Elder</span>
      <span className="flex items-center gap-1"><Sparkles className="h-3 w-3 text-sky-700" /> Sharente</span>
      <span className="flex items-center gap-1"><Heart className="h-3 w-3 text-rose-600" /> Parent</span>
      <span className="flex items-center gap-1"><Users className="h-3 w-3" /> Sibling / Clan</span>
    </div>
  );
}

interface ClanTreeVisualProps {
  nodes: TreeNode[];
  clanName?: string;
  apiUnavailable?: boolean;
}

export function ClanTreeVisual({ nodes, clanName, apiUnavailable }: ClanTreeVisualProps) {
  if (nodes.length === 0) {
    return (
      <p className="text-sm text-stone-500 py-8 text-center">
        {apiUnavailable
          ? "Clan tree data is unavailable. Check the API connection for this deployment."
          : "No speakers are in the clan tree yet."}
      </p>
    );
  }

  return (
    <div className="space-y-4">
      {clanName && (
        <div className="rounded-lg bg-gradient-to-r from-emerald-900/5 to-stone-50 border border-emerald-900/10 px-4 py-3 flex items-center gap-3">
          <TreeDeciduous className="h-5 w-5 text-emerald-800/70" />
          <div>
            <p className="text-xs uppercase tracking-widest text-emerald-800/60 font-medium">Clan</p>
            <p className="font-serif text-lg text-stone-800">{clanName}</p>
          </div>
        </div>
      )}
      <div className="space-y-2">
        {nodes.map((node) => (
          <TreeNodeComponent key={node.id} node={node} />
        ))}
      </div>
      <ClanLegend />
    </div>
  );
}