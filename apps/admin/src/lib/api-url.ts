/** Production admin portal URL (Vercel). */
export const PRODUCTION_ADMIN_URL = "https://kuttiomp-admin.vercel.app";
/** Production learner PWA (kuttiomp-learn on Vercel). */
export const PRODUCTION_LEARN_APP_URL = "https://kuttiomp-learn.vercel.app";

const LOCAL_API_URL = "http://localhost:8000";
const LOCAL_ADMIN_URL = "http://localhost:3000";
const LOCAL_LEARN_APP_URL = "http://localhost:8080";

function isProductionBuild(): boolean {
  return process.env.NODE_ENV === "production" || process.env.VERCEL === "1";
}

/** Admin portal URL for links and documentation. */
export function getAdminUrl(): string {
  const configured = process.env.NEXT_PUBLIC_ADMIN_URL?.replace(/\/$/, "");
  if (configured) return configured;
  return isProductionBuild() ? PRODUCTION_ADMIN_URL : LOCAL_ADMIN_URL;
}

/** Kuttiomp FastAPI backend base URL (no trailing slash). */
export function getApiUrl(): string {
  const configured = process.env.NEXT_PUBLIC_API_URL?.replace(/\/$/, "");
  if (configured) return configured;
  return LOCAL_API_URL;
}

/** Learner PWA URL for “Open learner demo” (no trailing slash). */
export function getLearnAppUrl(): string {
  const configured = process.env.NEXT_PUBLIC_LEARN_APP_URL?.replace(/\/$/, "");
  if (configured) return configured;
  return isProductionBuild() ? PRODUCTION_LEARN_APP_URL : LOCAL_LEARN_APP_URL;
}