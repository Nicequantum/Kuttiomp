import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { SPEAKER_ROLE_LABELS, type Speaker } from "@kuttiomp/database";

interface SpeakerCardProps {
  speaker: Speaker;
}

export function SpeakerCard({ speaker }: SpeakerCardProps) {
  const roleLabel = SPEAKER_ROLE_LABELS[speaker.role];

  return (
    <Card className="transition-shadow hover:shadow-md">
      <CardHeader className="pb-3">
        <div className="flex items-start justify-between">
          <div>
            <CardTitle className="text-lg">{speaker.display_name}</CardTitle>
            {speaker.name_narragansett && (
              <p className="text-sm text-muted-foreground font-serif italic">
                {speaker.name_narragansett}
              </p>
            )}
          </div>
          <div className="flex flex-col gap-1 items-end">
            {speaker.is_elder && <Badge variant="elder">Elder</Badge>}
            {speaker.is_two_spirit && (
              <Badge variant="sharente">Sharente</Badge>
            )}
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          <div className="flex gap-2 flex-wrap">
            <Badge variant="secondary">{roleLabel}</Badge>
            <Badge variant="outline">{speaker.generation}</Badge>
          </div>
          {speaker.cultural_title && (
            <p className="text-sm font-medium text-kuttiomp-earth">
              {speaker.cultural_title}
            </p>
          )}
          {speaker.biography && (
            <p className="text-sm text-muted-foreground line-clamp-3">
              {speaker.biography}
            </p>
          )}
          {speaker.teaching_domains.length > 0 && (
            <div className="flex flex-wrap gap-1 pt-1">
              {speaker.teaching_domains.map((domain) => (
                <Badge key={domain} variant="outline" className="text-xs">
                  {domain.replace(/_/g, " ")}
                </Badge>
              ))}
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}