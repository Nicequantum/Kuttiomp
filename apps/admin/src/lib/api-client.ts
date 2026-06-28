import { getApiUrl } from "./api-url";

const API_URL = getApiUrl();

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

export async function apiFetch<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${API_URL}${path}`, {
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
  const res = await fetch(`${API_URL}${path}`, { method: "POST", body: formData });
  if (!res.ok) throw await ApiError.fromResponse(res);
  return res.json();
}