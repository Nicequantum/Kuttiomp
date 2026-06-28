import { BookOpen, Mic, Users, Shield } from "lucide-react";
import { Header } from "@/components/layout/header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const stats = [
  {
    title: "Knowledge Keepers",
    value: "9",
    description: "Multi-generational speakers in the Kuttiomp clan",
    icon: Users,
  },
  {
    title: "Lexical Entries",
    value: "4+",
    description: "Words and phrases with cultural context",
    icon: BookOpen,
  },
  {
    title: "Audio Recordings",
    value: "—",
    description: "Speaker-attributed voice recordings",
    icon: Mic,
  },
  {
    title: "Pending Approvals",
    value: "—",
    description: "Content awaiting elder review",
    icon: Shield,
  },
];

export default function DashboardPage() {
  return (
    <>
      <Header
        title="Wunnegan — Welcome"
        description="Narragansett Language Revitalization Platform"
      />
      <div className="p-8 space-y-8">
        <div className="rounded-lg border bg-kuttiomp-turtle/5 p-6">
          <h3 className="font-serif text-lg text-kuttiomp-bark mb-2">
            Kuttiomp — Family, Home, Gathering Place
          </h3>
          <p className="text-sm text-muted-foreground leading-relaxed max-w-3xl">
            This platform honors the multi-generational transmission of Narragansett
            language through the voices of Grandmother Comus, Grandfather, Sharente
            (Two-Spirit Knowledge Keeper), parents, siblings, and clan members.
            Every word, every recording, every teaching carries the name of the
            speaker who gave it — because language lives in relationship.
          </p>
        </div>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {stats.map((stat) => (
            <Card key={stat.title}>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">
                  {stat.title}
                </CardTitle>
                <stat.icon className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{stat.value}</div>
                <p className="text-xs text-muted-foreground">
                  {stat.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Cultural Protocols</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3 text-sm text-muted-foreground">
              <p>
                <strong className="text-foreground">Speaker Attribution:</strong>{" "}
                Every audio recording is permanently linked to the speaker whose
                voice is captured.
              </p>
              <p>
                <strong className="text-foreground">Elder Approval:</strong>{" "}
                Sacred and ceremonial content requires review by Knowledge Keepers
                before publication.
              </p>
              <p>
                <strong className="text-foreground">Sharente Honor:</strong>{" "}
                Two-Spirit knowledge and inclusive kinship terms are stewarded
                with particular care.
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 text-sm">
              <a href="/audio" className="block text-primary hover:underline">
                Record new audio with speaker attribution →
              </a>
              <a href="/lexicon" className="block text-primary hover:underline">
                Browse and add lexical entries →
              </a>
              <a href="/speakers" className="block text-primary hover:underline">
                View clan speaker tree →
              </a>
              <a href="/approvals" className="block text-primary hover:underline">
                Review pending content →
              </a>
            </CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}