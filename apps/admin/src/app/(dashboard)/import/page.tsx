import { Header } from "@/components/layout/header";
import { BulkImport } from "@/components/lexicon/bulk-import";

export default function ImportPage() {
  return (
    <>
      <Header
        title="Seed / Import"
        description="Bulk-load lexical entries for fast Knowledge Keeper data entry"
      />
      <div className="p-6">
        <BulkImport />
      </div>
    </>
  );
}