import { Header } from "@/components/layout/header";
import { GuideMarkdown } from "@/components/docs/guide-markdown";
import { loadKnowledgeKeepersGuide } from "@/lib/load-guide";
import { ScrollText } from "lucide-react";

export default function KnowledgeKeepersGuidePage() {
  const content = loadKnowledgeKeepersGuide();

  return (
    <>
      <Header
        title="Knowledge Keepers Guide"
        description="The definitive manual for Sharente, elders, and all who steward Narragansett linguistic and cultural knowledge"
      />
      <div className="border-b border-emerald-900/10 bg-emerald-50/60 px-8 py-4">
        <div className="mx-auto flex max-w-4xl items-start gap-3">
          <ScrollText className="mt-0.5 h-5 w-5 shrink-0 text-emerald-800" />
          <p className="text-sm leading-relaxed text-emerald-950">
            This is your primary reference for systematic knowledge input. Start with{" "}
            <a
              href="#quick-start--your-first-session"
              className="font-semibold text-emerald-800 underline underline-offset-2"
            >
              Quick Start — Your First Session
            </a>{" "}
            if you are beginning today.
          </p>
        </div>
      </div>
      <div className="p-8 pb-16">
        <div className="mx-auto max-w-4xl">
          <GuideMarkdown content={content} />
        </div>
      </div>
    </>
  );
}