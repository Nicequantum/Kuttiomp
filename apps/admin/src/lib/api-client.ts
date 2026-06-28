import { getApiUrl } from "./api-url";

const API_URL = getApiUrl();

const TRANSIENT_STATUS = new Set([502, 503, 504]);
const MAX_RETRIES = 2;
const RETRY_DELAY_MS = 1000;

export interface ApiErrorBody {
  error?: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  };
}

export class ApiError extends Error {
  status: number;
  code: string;
  details?: Record<string, unknown>;

  constructor(status: number, code: string, message: string, details?: Record<string, unknown>) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
    this.details = details;
  }

  static async fromResponse(res: Response): Promise<ApiError> {
    let body: ApiErrorBody = {};
    try {
      body = await res.json();
    } catch {
      /* non-JSON */
    }
    const err = body.error;
    return new ApiError(
      res.status,
      err?.code ?? "UNKNOWN_ERROR",
      err?.message ?? res.statusText,
      err?.details
    );
  }
}

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchWithRetry(
  url: string,
  options?: RequestInit
): Promise<Response> {
  let lastError: unknown;

  for (let attempt = 0; attempt <= MAX_RETRIES; attempt++) {
    try {
      const res = await fetch(url, options);
      if (TRANSIENT_STATUS.has(res.status) && attempt < MAX_RETRIES) {
        await delay(RETRY_DELAY_MS * (attempt + 1));
        continue;
      }
      return res;
    } catch (err) {
      lastError = err;
      if (attempt < MAX_RETRIES) {
        await delay(RETRY_DELAY_MS * (attempt + 1));
        continue;
      }
      throw err;
    }
  }

  throw lastError ?? new TypeError("Network request failed");
}

export async function apiFetch<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetchWithRetry(`${API_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...options?.headers,
    },
  });

  if (!res.ok) throw await ApiError.fromResponse(res);
  return res.json();
}

export async function apiUpload<T>(path: string, formData: FormData): Promise<T> {
  const res = await fetchWithRetry(`${API_URL}${path}`, { method: "POST", body: formData });
  if (!res.ok) throw await ApiError.fromResponse(res);
  return res.json();
}