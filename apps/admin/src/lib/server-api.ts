import { getApiUrl } from "./api-url";

export type ServerApiResult<T> =
  | { ok: true; data: T }
  | { ok: false; reason: "unreachable" | "http_error"; message: string; status?: number };

export async function serverApiFetch<T>(
  path: string,
  options?: { revalidate?: number }
): Promise<ServerApiResult<T>> {
  const url = `${getApiUrl()}${path}`;
  try {
    const res = await fetch(url, {
      next: options?.revalidate !== undefined ? { revalidate: options.revalidate } : undefined,
    });
    if (!res.ok) {
      return {
        ok: false,
        reason: "http_error",
        status: res.status,
        message: `API request failed (${res.status})`,
      };
    }
    const data = (await res.json()) as T;
    return { ok: true, data };
  } catch {
    return {
      ok: false,
      reason: "unreachable",
      message:
        "Unable to connect to the Kuttiomp API. Verify NEXT_PUBLIC_API_URL is set for this deployment.",
    };
  }
}