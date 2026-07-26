"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  BookOpen,
  Home,
  Mic,
  Users,
  TreePine,
  Sparkles,
  Shield,
  MapPin,
  FileEdit,
  GitBranch,
  ScrollText,
  Upload,
} from "lucide-react";
import { KuttiompBrand } from "@kuttiomp/ui";
import { ModeSwitcher, useModeTheme } from "@kuttiomp/admin-design-system";
import { cn } from "@/lib/utils";
import { Separator } from "@/components/ui/separator";

const guideLink = {
  name: "Knowledge Keepers Guide",
  href: "/knowledge-keepers-guide",
  icon: ScrollText,
};

const navigation = [
  { name: "Dashboard", href: "/", icon: Home },
  { name: "Clan Tree", href: "/speakers", icon: GitBranch },
  { name: "Speakers", href: "/speakers/profiles", icon: Users },
  { name: "Clans", href: "/clans", icon: TreePine },
  { name: "Lexicon", href: "/lexicon", icon: BookOpen },
  { name: "Stewardship", href: "/stewardship", icon: ScrollText },
  { name: "Lexicon Editor", href: "/lexicon/editor", icon: FileEdit },
  { name: "Seed / Import", href: "/import", icon: Upload },
  { name: "Audio Studio", href: "/audio", icon: Mic },
  { name: "Land Knowledge", href: "/land", icon: MapPin },
  { name: "Contributions", href: "/contributions", icon: Shield },
  { name: "Approvals", href: "/approvals", icon: Shield },
  { name: "AI Assistant", href: "/ai", icon: Sparkles },
];

export function Sidebar() {
  const pathname = usePathname();
  const { tokens } = useModeTheme();
  const guideActive =
    pathname === guideLink.href || pathname.startsWith("/docs/knowledge-keepers");

  return (
    <aside
      className="mode-sidebar-surface flex h-full w-72 flex-col border-r"
      aria-label="Knowledge Keeper navigation"
    >
      <div
        className="border-b px-5 py-4"
        style={{ borderColor: `hsl(${tokens.sidebarBorder})` }}
      >
        <KuttiompBrand subtitle="Knowledge Keeper Portal" />
        <p
          className="mt-2 text-muted-foreground"
          style={{ fontSize: "calc(var(--mode-font-body) * 0.85)" }}
        >
          Viewing as: <strong className="text-foreground">{tokens.label}</strong>
        </p>
      </div>

      <nav className="flex-1 space-y-0.5 overflow-y-auto p-3">
        <div className="mb-3">
          <Link
            href={guideLink.href}
            data-active={guideActive ? "true" : "false"}
            className={cn(
              "mode-nav-link flex items-center gap-3 px-3 py-2.5 font-semibold shadow-sm",
              guideActive && "ring-2 ring-offset-2"
            )}
            style={{
              fontSize: "var(--mode-font-body)",
              minHeight: "2.75rem",
              ...(guideActive
                ? {
                    backgroundColor: `hsl(${tokens.primary})`,
                    color: `hsl(${tokens.primaryForeground})`,
                  }
                : {
                    backgroundColor: `hsl(${tokens.primary} / 0.12)`,
                    color: `hsl(${tokens.primary})`,
                  }),
            }}
          >
            <guideLink.icon className="h-4 w-4 shrink-0" aria-hidden />
            {guideLink.name}
          </Link>
          <p
            className="mt-1.5 px-1 leading-snug text-muted-foreground"
            style={{ fontSize: "calc(var(--mode-font-body) * 0.8)" }}
          >
            Start here — essential guide for Sharente &amp; Knowledge Keepers
          </p>
        </div>

        <Separator className="mb-2" />

        {navigation.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== "/" && pathname.startsWith(item.href));
          return (
            <Link
              key={item.name}
              href={item.href}
              data-active={isActive ? "true" : "false"}
              className="mode-nav-link flex items-center gap-3 px-3 py-2.5 transition-colors"
              style={{
                fontSize: "var(--mode-font-body)",
                minHeight: "2.5rem",
              }}
            >
              <item.icon className="h-4 w-4 shrink-0" aria-hidden />
              {item.name}
            </Link>
          );
        })}
      </nav>

      <div
        className="space-y-3 border-t p-4"
        style={{ borderColor: `hsl(${tokens.sidebarBorder})` }}
      >
        <ModeSwitcher />
        <Separator />
        <p
          className="px-1 leading-relaxed text-muted-foreground"
          style={{ fontSize: "calc(var(--mode-font-body) * 0.8)" }}
        >
          Twelve Cultural Governance Protocols govern all content. Protocol 10
          forbids points, streaks, and leaderboards.
        </p>
      </div>
    </aside>
  );
}
