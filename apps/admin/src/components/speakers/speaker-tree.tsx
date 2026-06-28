"use client";

import { Badge } from "@/components/ui/badge";
import { SPEAKER_ROLE_LABELS } from "@kuttiomp/types";

interface TreeNode {
  id: string;
  display_name: string;
  role: string;
  is_elder?: boolean;
  is_two_spirit?: boolean;
  children?: TreeNode[];
}

interface SpeakerTreeProps {
  nodes: TreeNode[];
  depth?: number;
}

export function SpeakerTree({ nodes, depth = 0 }: SpeakerTreeProps) {
  return (
    <ul className={depth === 0 ? "space-y-2" : "ml-6 mt-2 space-y-2 border-l-2 border-kuttiomp-sage/30 pl-4"}>
      {nodes.map((node) => (
        <li key={node.id}>
          <div className="flex items-center gap-2 rounded-md bg-muted/50 px-3 py-2">
            <span className="font-medium">{node.display_name}</span>
            <Badge variant="secondary" className="text-xs">
              {SPEAKER_ROLE_LABELS[node.role as keyof typeof SPEAKER_ROLE_LABELS] || node.role}
            </Badge>
            {node.is_elder && <Badge variant="elder" className="text-xs">Elder</Badge>}
            {node.is_two_spirit && <Badge variant="sharente" className="text-xs">Sharente</Badge>}
          </div>
          {node.children && node.children.length > 0 && (
            <SpeakerTree nodes={node.children} depth={depth + 1} />
          )}
        </li>
      ))}
    </ul>
  );
}