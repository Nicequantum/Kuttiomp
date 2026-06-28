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

  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }

  return res.json();
}

export const api = {
  health: () => apiFetch<{ status: string }>("/health"),
  speakers: {
    list: (params?: Record<string, string>) => {
      const query = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/speakers${query}`);
    },
    tree: (clanId?: string) => {
      const query = clanId ? `?clan_id=${clanId}` : "";
      return apiFetch(`/api/v1/speakers/tree${query}`);
    },
    get: (id: string) => apiFetch(`/api/v1/speakers/${id}`),
  },
  clans: {
    list: () => apiFetch("/api/v1/clans"),
    get: (id: string) => apiFetch(`/api/v1/clans/${id}`),
    speakers: (id: string) => apiFetch(`/api/v1/clans/${id}/speakers`),
  },
  lexicon: {
    list: (params?: Record<string, string>) => {
      const query = params ? `?${new URLSearchParams(params)}` : "";
      return apiFetch(`/api/v1/lexicon${query}`);
    },
    get: (id: string) => apiFetch(`/api/v1/lexicon/${id}`),
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
    linguistic: (data: {
      prompt_type: string;
      text: string;
      speaker_context_id?: string;
    }) =>
      apiFetch("/api/v1/ai/linguistic", {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
};