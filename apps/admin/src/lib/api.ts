const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

export async function apiFetch<T>(
  path: string,
  options?: RequestInit
): Promise<T> {
  const res = await fetch(`${API_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...options?.headers,
    },
  });
  if (!res.ok) throw new Error(`API error: ${res.status} ${res.statusText}`);
  return res.json();
}

export const api = {
  health: () => apiFetch<{ status: string }>("/health"),
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
    create: (data: Record<string, unknown>) =>
      apiFetch("/api/v1/lexicon", { method: "POST", body: JSON.stringify(data) }),
    update: (id: string, data: Record<string, unknown>) =>
      apiFetch(`/api/v1/lexicon/${id}`, { method: "PATCH", body: JSON.stringify(data) }),
  },
  cultural: {
    contexts: (params?: Record<string, string>) => {
      const q = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/cultural/contexts${q}`);
    },
    narratives: () => apiFetch("/api/v1/cultural/narratives"),
    createContext: (data: Record<string, unknown>) =>
      apiFetch("/api/v1/cultural/contexts", { method: "POST", body: JSON.stringify(data) }),
  },
  land: {
    sites: () => apiFetch("/api/v1/land/sites"),
    get: (id: string) => apiFetch(`/api/v1/land/sites/${id}`),
  },
  contributions: {
    list: (status?: string) => {
      const q = status ? `?status=${status}` : "";
      return apiFetch(`/api/v1/contributions${q}`);
    },
    pending: () => apiFetch("/api/v1/contributions/pending"),
    submit: (data: Record<string, unknown>) =>
      apiFetch("/api/v1/contributions", { method: "POST", body: JSON.stringify(data) }),
    submitForReview: (id: string) =>
      apiFetch(`/api/v1/contributions/${id}/submit`, { method: "POST" }),
    review: (id: string, data: Record<string, unknown>) =>
      apiFetch(`/api/v1/contributions/${id}/review`, {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
  orthographies: {
    list: () => apiFetch("/api/v1/orthographies"),
    spellings: (entryId: string) =>
      apiFetch(`/api/v1/orthographies/${entryId}/spellings`),
  },
  audio: {
    pending: () => apiFetch("/api/v1/audio/pending"),
    upload: async (formData: FormData) => {
      const res = await fetch(`${API_URL}/api/v1/audio/upload`, {
        method: "POST",
        body: formData,
      });
      if (!res.ok) throw new Error(`Upload failed: ${res.status}`);
      return res.json();
    },
  },
  ai: {
    linguistic: (data: { prompt_type: string; text: string }) =>
      apiFetch("/api/v1/ai/linguistic", {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
};