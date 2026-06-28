import { ApiError } from "./api-client";

/** User-facing message for save/upload failures — never implies data was lost client-side. */
export function formatSaveError(err: unknown, action = "Save"): string {
  if (err instanceof ApiError) {
    if (err.status === 409) {
      return "This record may already exist. Refresh the page and edit the existing entry to avoid duplicates.";
    }
    if (err.status === 422) {
      return err.message || "Validation failed. Check required fields and try again.";
    }
    if (err.status >= 500) {
      return `${action} could not complete — the server is temporarily unavailable. Your work on this page is preserved. Try again.`;
    }
    return err.message;
  }
  return `${action} could not complete — unable to reach the Kuttiomp API. Your work on this page is preserved. Try again when connected.`;
}

export function isNetworkOrTransientError(err: unknown): boolean {
  if (err instanceof ApiError) {
    return err.status === 502 || err.status === 503 || err.status === 504;
  }
  return err instanceof TypeError;
}