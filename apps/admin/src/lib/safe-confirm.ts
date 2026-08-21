/** Confirm before removing in-progress form content (unsaved until Save). */
export function confirmRemoveItem(label: string): boolean {
  return window.confirm(
    `Remove this ${label}? It will be removed from the form only — click Save Entry to persist other changes.`
  );
}

/** Confirm publishing a lexical entry to the public learner API. */
export function confirmPublishForLearners(word: string): boolean {
  return window.confirm(
    `Publish “${word}” for learners? This sets visibility to public and approval to approved. Sacred or restricted entries cannot be published.`
  );
}