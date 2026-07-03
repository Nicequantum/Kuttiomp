"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  BookOpen, Home, Mic, Users, TreePine, Sparkles, Shield,
  MapPin, FileEdit, GitBranch, ScrollText, Upload,
} from "lucide-react";
import { KuttiompBrand } from "@kuttiomp/ui";
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
  const guideActive =
    pathname === guideLink.href || pathname.startsWith("/docs/knowledge-keepers");

  return (
    <aside className="flex h-full w-64 flex-col border-r border-stone-200 bg-stone-50/50">
      <div className="border-b border-stone-200 px-5 py-4">
        <KuttiompBrand subtitle="Knowledge Keeper Portal" />
      </div>

      <nav className="flex-1 overflow-y-auto p-3 space-y-0.5">
        <div className="mb-3">
          <Link
            href={guideLink.href}
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-semibold transition-colors shadow-sm",
              guideActive
                ? "bg-emerald-900 text-white ring-2 ring-emerald-700 ring-offset-2 ring-offset-stone-50"
                : "bg-emerald-800 text-white hover:bg-emerald-900"
            )}
          >
            <guideLink.icon className="h-4 w-4 shrink-0" />
            {guideLink.name}
          </Link>
          <p className="mt-1.5 px-1 text-[10px] leading-snug text-emerald-800/80">
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
              className={cn(
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors",
                isActive
                  ? "bg-emerald-900/10 text-emerald-900 font-medium"
                  : "text-stone-600 hover:bg-stone-100 hover:text-stone-900"
              )}
            >
              <item.icon className="h-4 w-4 shrink-0" />
              {item.name}
            </Link>
          );
        })}
      </nav>

      <div className="border-t border-stone-200 p-4">
        <Link
          href={guideLink.href}
          className={cn(
            "mb-3 flex items-center gap-2 rounded-md px-2 py-1.5 text-xs font-medium text-emerald-800 transition-colors hover:bg-emerald-50",
            guideActive && "bg-emerald-50"
          )}
        >
          <ScrollText className="h-3.5 w-3.5 shrink-0" />
          Open Knowledge Keepers Guide
        </Link>
        <Separator className="mb-3" />
        <p className="px-1 text-[11px] leading-relaxed text-stone-400">
          Twelve Cultural Governance Protocols govern all content on this platform.
        </p>
      </div>
    </aside>
  );
}