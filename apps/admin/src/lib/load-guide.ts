import { existsSync, readFileSync } from "fs";
import { join } from "path";

const GUIDE_FILENAME = "KNOWLEDGE_KEEPERS_GUIDE.md";

function guideCandidates(): string[] {
  return [
    join(process.cwd(), "content", GUIDE_FILENAME),
    join(process.cwd(), "docs", GUIDE_FILENAME),
    join(process.cwd(), "../../docs", GUIDE_FILENAME),
  ];
}

export function loadKnowledgeKeepersGuide(): string {
  for (const path of guideCandidates()) {
    if (existsSync(path)) {
      return readFileSync(path, "utf-8");
    }
  }

  throw new Error(
    `Knowledge Keepers Guide not found. Expected ${GUIDE_FILENAME} in docs/ or content/.`
  );
}