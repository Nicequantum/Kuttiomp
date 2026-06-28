/** Production admin portal URL (Vercel). */
export const PRODUCTION_ADMIN_URL = "https://kuttiomp-admin.vercel.app";

const LOCAL_API_URL = "http://localhost:8000";
const LOCAL_ADMIN_URL = "http://localhost:3000";

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