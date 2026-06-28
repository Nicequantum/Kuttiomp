import { AcademicHeader } from "@kuttiomp/ui";
import { ContributionWorkflow } from "@/components/contributions/contribution-workflow";

export default function ContributionsPage() {
  return (
    <>
      <AcademicHeader
        eyebrow="Protocol 7: Audit & Accountability"
        title="Knowledge Keeper Contributions"
        subtitle="Systematic workflow for submitting, reviewing, and approving linguistic and cultural knowledge with protocol acknowledgment."
      />
      <div className="p-8 max-w-4xl">
        <ContributionWorkflow />
      </div>
    </>
  );
}