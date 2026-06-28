import Link from "next/link";
import { BookOpen, Mic, Users, Shield, MapPin, FileEdit, GitBranch } from "lucide-react";
import { AcademicHeader, ProtocolBadge } from "@kuttiomp/ui";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { CULTURAL_PROTOCOLS } from "@kuttiomp/types";

const quickActions = [
  { href: "/lexicon/editor", label: "Create Lexical Entry", icon: FileEdit },
  { href: "/audio", label: "Record Audio", icon: Mic },
  { href: "/speakers", label: "View Clan Tree", icon: GitBranch },
  { href: "/contributions", label: "Submit Contribution", icon: Shield },
  { href: "/land", label: "Land Knowledge", icon: MapPin },
  { href: "/lexicon", label: "Browse Lexicon", icon: BookOpen },
];

export default function DashboardPage() {
  return (
    <>
      <AcademicHeader
        eyebrow="Narragansett Language Revitalization"
        title="Wunnegan — Welcome, Knowledge Keeper"
        subtitle="Kuttiomp is the gathering place where language lives in relationship — through the voices of Grandmother Comus, Grandfather, Sharente, parents, siblings, and clan members."
      />
      <div className="p-8 space-y-8">
        <div className="rounded-lg border border-emerald-900/15 bg-gradient-to-br from-emerald-50/50 to-stone-50 p-6">
          <h3 className="font-serif text-lg text-stone-800 mb-2">
            Twelve Cultural Governance Protocols
          </h3>
          <p className="text-sm text-stone-600 leading-relaxed mb-4 max-w-3xl">
            All content on this platform is governed by twelve protocols encoding speaker sovereignty,
            generational respect, Two-Spirit honor, sacred content protection, land relationship,
            and orthographic integrity.
          </p>
          <div className="flex flex-wrap gap-2">
            {CULTURAL_PROTOCOLS.map((p) => (
              <ProtocolBadge key={p.id} protocolId={p.id} />
            ))}
          </div>
        </div>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[
            { title: "Knowledge Keepers", value: "9+", desc: "Multi-generational speakers", icon: Users },
            { title: "Lexical Depth", value: "PhD", desc: "Phonemic, morphological, cultural", icon: BookOpen },
            { title: "Land Sites", value: "PostGIS", desc: "Place-based knowledge mapping", icon: MapPin },
            { title: "Protocols", value: "12", desc: "Cultural governance framework", icon: Shield },
          ].map((s) => (
            <Card key={s.title}>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">{s.title}</CardTitle>
                <s.icon className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold font-serif">{s.value}</div>
                <p className="text-xs text-muted-foreground">{s.desc}</p>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle className="font-serif text-lg">Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {quickActions.map((a) => {
                const Icon = a.icon;
                return (
                  <Link
                    key={a.href}
                    href={a.href}
                    className="flex items-center gap-2 text-sm text-emerald-800 hover:underline"
                  >
                    <Icon className="h-4 w-4" />
                    {a.label} →
                  </Link>
                );
              })}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="font-serif text-lg">Documentation</CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-muted-foreground space-y-2">
              <p>
                <strong className="text-foreground">Knowledge Keepers Guide:</strong>{" "}
                Comprehensive PhD-level manual for systematic knowledge input (see <code>docs/</code>).
              </p>
              <p>
                <strong className="text-foreground">Cultural Protocols v2.0:</strong>{" "}
                Twelve governance protocols with enforcement matrix.
              </p>
              <p>
                <strong className="text-foreground">Setup:</strong>{" "}
                See SETUP.md for local development and migration instructions.
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}