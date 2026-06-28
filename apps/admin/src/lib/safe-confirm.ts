/** Confirm before removing in-progress form content (unsaved until Save). */
export function confirmRemoveItem(label: string): boolean {
  return window.confirm(
    `Remove this ${label}? It will be removed from the form only — click Save Entry to persist other changes.`
  );
}