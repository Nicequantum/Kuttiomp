from functools import lru_cache

from supabase import Client, create_client

from app.config import settings
from app.exceptions import ServiceUnavailableError


def _require_supabase_url_and_key(key: str | None, *, missing: str) -> tuple[str, str]:
    url = settings.supabase_url
    if not url or not key:
        raise ServiceUnavailableError(missing)
    return url, key


@lru_cache
def get_supabase() -> Client:
    """Service-role client for privileged server jobs only.

    Use for writes/approvals after FastAPI has verified the actor, speaker
    lookups, signed-URL minting, and migrations. Do not use for anonymous
    learner reads — those must go through ``get_anon_supabase`` so RLS applies.
    """
    url, key = _require_supabase_url_and_key(
        settings.supabase_service_role_key,
        missing="Supabase service role is not configured",
    )
    return create_client(url, key)


@lru_cache
def get_anon_supabase() -> Client:
    """Anon-key client. PostgREST runs as ``anon`` and RLS can constrain rows."""
    url, key = _require_supabase_url_and_key(
        settings.supabase_anon_key,
        missing="Supabase is not configured",
    )
    return create_client(url, key)


def get_user_supabase(access_token: str) -> Client:
    """Anon-key client carrying a Supabase user JWT so RLS sees ``authenticated``."""
    url, key = _require_supabase_url_and_key(
        settings.supabase_anon_key,
        missing="Supabase is not configured",
    )
    client = create_client(url, key)
    client.postgrest.auth(access_token)
    return client


def get_scoped_supabase(actor=None) -> Client:
    """Pick the least-privileged client that can serve this caller.

    * No actor → anon (public / learner reads).
    * Supabase user JWT → user-scoped client (RLS applies).
    * Clerk / dev keeper → service role. Clerk identity is verified in FastAPI;
      Supabase RLS cannot see Clerk users until a Clerk→Supabase mapping exists.
    """
    if actor is None:
        return get_anon_supabase()
    if getattr(actor, "access_token", None) and getattr(actor, "issuer", None) == "supabase":
        return get_user_supabase(actor.access_token)
    if getattr(actor, "is_keeper", False) or getattr(actor, "is_elder", False):
        return get_supabase()
    return get_anon_supabase()
