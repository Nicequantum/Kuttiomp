"use client";

import { useCallback, useEffect, useState } from "react";
import { EmptyState, ErrorAlert, LoadingState } from "@kuttiomp/ui";
import { ApiError } from "@/lib/api";

interface AsyncContentProps<T> {
  fetcher: () => Promise<T>;
  loadingMessage?: string;
  emptyTitle: string;
  emptyDescription?: string;
  emptyIcon?: React.ReactNode;
  children: (data: T) => React.ReactNode;
}

export function AsyncContent<T>({
  fetcher,
  loadingMessage,
  emptyTitle,
  emptyDescription,
  emptyIcon,
  children,
}: AsyncContentProps<T>) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await fetcher();
      setData(result);
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Unable to load data");
    } finally {
      setLoading(false);
    }
  }, [fetcher]);

  useEffect(() => { load(); }, [load]);

  if (loading) return <LoadingState message={loadingMessage} />;
  if (error) return <ErrorAlert message={error} onRetry={load} />;
  if (!data || (Array.isArray(data) && data.length === 0)) {
    return <EmptyState icon={emptyIcon} title={emptyTitle} description={emptyDescription} />;
  }
  return <>{children(data)}</>;
}