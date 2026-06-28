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
} from "lucide-react";
import { cn } from "@/lib/utils";
import { Separator } from "@/components/ui/separator";

const navigation = [
  { name: "Dashboard", href: "/", icon: Home },
  { name: "Speakers", href: "/speakers", icon: Users },
  { name: "Clans", href: "/clans", icon: TreePine },
  { name: "Lexicon", href: "/lexicon", icon: BookOpen },
  { name: "Audio Studio", href: "/audio", icon: Mic },
  { name: "AI Assistant", href: "/ai", icon: Sparkles },
  { name: "Approvals", href: "/approvals", icon: Shield },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="flex h-full w-64 flex-col border-r bg-card">
      <div className="flex h-16 items-center gap-3 border-b px-6">
        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-kuttiomp-turtle text-white font-serif text-sm">
          K
        </div>
        <div>
          <h1 className="font-serif text-lg font-semibold text-kuttiomp-bark">
            Kuttiomp
          </h1>
          <p className="text-xs text-muted-foreground">Admin Dashboard</p>
        </div>
      </div>

      <nav className="flex-1 space-y-1 p-4">
        {navigation.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== "/" && pathname.startsWith(item.href));
          return (
            <Link
              key={item.name}
              href={item.href}
              className={cn(
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors",
                isActive
                  ? "bg-primary/10 text-primary"
                  : "text-muted-foreground hover:bg-muted hover:text-foreground"
              )}
            >
              <item.icon className="h-4 w-4" />
              {item.name}
            </Link>
          );
        })}
      </nav>

      <div className="border-t p-4">
        <Separator className="mb-4" />
        <p className="px-3 text-xs text-muted-foreground leading-relaxed">
          Built with respect for Narragansett Knowledge Keepers, Elders, and
          Sharente.
        </p>
      </div>
    </aside>
  );
}