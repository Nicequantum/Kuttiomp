import Link from "next/link";
import {
  BookOpen,
  Mic,
  Users,
  Shield,
  MapPin,
  FileEdit,
  GitBranch,
  ScrollText,
} from "lucide-react";
import { ProtocolBadge } from "@kuttiomp/ui";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { CULTURAL_PROTOCOLS } from "@kuttiomp/types";
import { DashboardHero } from "@/components/layout/dashboard-hero";

const quickActions = [
  { href: "/lexicon/editor", label: "Create Lexical Entry", icon: FileEdit },
  { href: "/audio", label: "Record Audio", icon: Mic },
  { href: "/speakers", label: "View Clan Tree", icon: GitBranch },
  { href: "/contributions", label: "Submit Contribution", icon: Shield },
  { href: "/land", label: "Land Knowledge", icon: MapPin },
  { href: "/lexicon", label: "Browse Lexicon", icon: BookOpen },
  { href: "/stewardship", label: "Corpus Stewardship", icon: ScrollText },
];

export default function DashboardPage() {
  return (
    <>
      <DashboardHero />
      <div className="space-y-8 p-6 md:p-8">
        <section
          className="mode-rounded-extra border bg-card p-6"
          style={{ borderColor: "hsl(var(--border))" }}
          aria-labelledby="protocols-heading"
        >
          <h3
            id="protocols-heading"
            className="mb-2 font-serif text-foreground"
            style={{ fontSize: "var(--mode-font-title)" }}
          >
            Twelve Cultural Governance Protocols
          </h3>
          <p
            className="mode-content-text mb-4 max-w-3xl text-muted-foreground"
          >
            All content on this platform is governed by twelve protocols encoding
            speaker sovereignty, generational respect, Two-Spirit honor, sacred
            content protection, land relationship, and orthographic integrity.
            Protocol 10 forbids gamification forever.
          </p>
          <div className="flex flex-wrap gap-2">
            {CULTURAL_PROTOCOLS.map((p) => (
              <ProtocolBadge key={p.id} protocolId={p.id} />
            ))}
          </div>
        </section>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[
            {
              title: "Knowledge Keepers",
              value: "9+",
              desc: "Multi-generational speakers",
              icon: Users,
            },
            {
              title: "Lexical Depth",
              value: "PhD",
              desc: "Phonemic, morphological, cultural",
              icon: BookOpen,
            },
            {
              title: "Land Sites",
              value: "PostGIS",
              desc: "Place-based knowledge mapping",
              icon: MapPin,
            },
            {
              title: "Protocols",
              value: "12",
              desc: "Cultural governance framework",
              icon: Shield,
            },
          ].map((s) => (
            <Card key={s.title} className="border-border bg-card">
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle
                  className="font-medium"
                  style={{ fontSize: "var(--mode-font-body)" }}
                >
                  {s.title}
                </CardTitle>
                <s.icon className="h-4 w-4 text-muted-foreground" aria-hidden />
              </CardHeader>
              <CardContent>
                <div
                  className="font-serif font-bold text-foreground"
                  style={{ fontSize: "var(--mode-font-title)" }}
                >
                  {s.value}
                </div>
                <p
                  className="text-muted-foreground"
                  style={{ fontSize: "calc(var(--mode-font-body) * 0.9)" }}
                >
                  {s.desc}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="grid gap-6 md:grid-cols-2">
          <Card className="border-border bg-card">
            <CardHeader>
              <CardTitle
                className="font-serif"
                style={{ fontSize: "var(--mode-font-title)" }}
              >
                Quick Actions
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-1">
              {quickActions.map((a) => {
                const Icon = a.icon;
                return (
                  <Link
                    key={a.href}
                    href={a.href}
                    className="flex items-center gap-2 rounded-[var(--radius)] px-2 py-2 text-primary transition-colors hover:bg-muted"
                    style={{
                      fontSize: "var(--mode-font-body)",
                      minHeight: "2.75rem",
                    }}
                  >
                    <Icon className="h-4 w-4 shrink-0" aria-hidden />
                    {a.label}
                  </Link>
                );
              })}
            </CardContent>
          </Card>

          <Card className="border-border bg-card">
            <CardHeader>
              <CardTitle
                className="font-serif"
                style={{ fontSize: "var(--mode-font-title)" }}
              >
                Documentation
              </CardTitle>
            </CardHeader>
            <CardContent
              className="space-y-3 text-muted-foreground"
              style={{ fontSize: "var(--mode-font-content)" }}
            >
              <p>
                <strong className="text-foreground">Knowledge Keepers Guide:</strong>{" "}
                Comprehensive manual for systematic knowledge input.
              </p>
              <p>
                <strong className="text-foreground">Admin UI modes:</strong>{" "}
                Four visual paths (Little Ones → Elder) via the sidebar switcher.
                See <code className="rounded bg-muted px-1">docs/ADMIN_UI_MODES.md</code>.
              </p>
              <p>
                <strong className="text-foreground">Cultural Protocols v2.0:</strong>{" "}
                Twelve governance protocols with enforcement matrix.
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}
