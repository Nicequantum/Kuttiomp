import { apiFetch, apiUpload } from "./api-client";
import type { LexicalEntryForm } from "@kuttiomp/validation";

export { ApiError } from "./api-client";

export const api = {
  health: () => apiFetch<{ status: string; version?: string }>("/health"),
  speakers: {
    list: (params?: Record<string, string>) => {
      const q = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/speakers${q}`);
    },
    tree: (clanId?: string) => {
      const q = clanId ? `?clan_id=${clanId}` : "";
      return apiFetch(`/api/v1/speakers/tree${q}`);
    },
    get: (id: string) => apiFetch(`/api/v1/speakers/${id}`),
  },
  clans: { list: () => apiFetch("/api/v1/clans") },
  lexicon: {
    list: (params?: Record<string, string>) => {
      const q = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/lexicon${q}`);
    },
    get: (id: string) => apiFetch(`/api/v1/lexicon/${id}`),
    create: (data: LexicalEntryForm) =>
      apiFetch("/api/v1/lexicon", { method: "POST", body: JSON.stringify(data) }),
    update: (id: string, data: Partial<LexicalEntryForm>) =>
      apiFetch(`/api/v1/lexicon/${id}`, { method: "PATCH", body: JSON.stringify(data) }),
  },
  cultural: {
    contexts: (params?: Record<string, string>) => {
      const q = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/cultural/contexts${q}`);
    },
    narratives: () => apiFetch("/api/v1/cultural/narratives"),
  },
  land: {
    sites: () => apiFetch("/api/v1/land/sites"),
    get: (id: string) => apiFetch(`/api/v1/land/sites/${id}`),
  },
  contributions: {
    pending: () => apiFetch("/api/v1/contributions/pending"),
    submit: (data: Record<string, unknown>) =>
      apiFetch("/api/v1/contributions", { method: "POST", body: JSON.stringify(data) }),
    review: (id: string, data: Record<string, unknown>) =>
      apiFetch(`/api/v1/contributions/${id}/review`, {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
  orthographies: { list: () => apiFetch("/api/v1/orthographies") },
  audio: {
    pending: () => apiFetch("/api/v1/audio/pending"),
    upload: (formData: FormData) => apiUpload("/api/v1/audio/upload", formData),
  },
  ai: {
    linguistic: (data: { prompt_type: string; text: string }) =>
      apiFetch("/api/v1/ai/linguistic", {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
};