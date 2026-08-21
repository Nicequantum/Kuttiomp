"""Identity verification for keeper and admin FastAPI routes.

Public learner routes (``/api/v1/public/*``) and health checks do not use this
module.

Send: ``Authorization: Bearer <jwt>``

Accepted tokens (first successful verify wins):

1. ``AUTH_DEV_SECRET`` HS256 with ``iss=kuttiomp-dev`` — local/test only
2. Clerk session JWT (admin portal) — RS256 via Clerk JWKS
3. Supabase user JWT (Flutter) — HS256 via ``SUPABASE_JWT_SECRET``

``approved_by`` / ``reviewed_by`` are taken from ``speakers.clerk_user_id``
(or a test claim). Client-supplied reviewer UUIDs are ignored.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

import httpx
import jwt
from fastapi import Depends
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jwt import PyJWKSet

from app.config import settings
from app.database import get_supabase
from app.exceptions import ForbiddenError, UnauthorizedError

bearer_scheme = HTTPBearer(auto_error=False)

KEEPER_SPEAKER_ROLES = frozenset(
    {
        "grandmother",
        "grandfather",
        "sharente",
        "parent",
        "sibling",
        "clan_member",
    }
)
ELDER_SPEAKER_ROLES = frozenset({"grandmother", "grandfather", "sharente"})

_clerk_jwks_cache: dict | None = None


@dataclass(frozen=True)
class Actor:
    subject: str
    issuer: str
    speaker_id: UUID | None
    is_keeper: bool
    is_elder: bool
    access_token: str | None = None

    @property
    def can_view_sacred(self) -> bool:
        """Sacred rows are elder-only. A Clerk cookie or keeper role is not enough."""
        return self.is_elder

    def require_speaker_id(self) -> UUID:
        if self.speaker_id is None:
            raise ForbiddenError(
                "This action requires a speakers row linked to your account "
                "(set speakers.clerk_user_id to your Clerk user id)."
            )
        return self.speaker_id


def _parse_uuid(value: object) -> UUID | None:
    if value is None:
        return None
    try:
        return UUID(str(value))
    except (TypeError, ValueError):
        return None


def _dev_auth_enabled() -> bool:
    return bool(settings.auth_dev_secret) and settings.api_env != "production"


def _lookup_speaker(*, clerk_user_id: str | None) -> dict | None:
    if not clerk_user_id:
        return None
    try:
        result = (
            get_supabase()
            .table("speakers")
            .select("id, is_elder, role, generation, clerk_user_id")
            .eq("clerk_user_id", clerk_user_id)
            .limit(1)
            .execute()
        )
        rows = result.data or []
        return rows[0] if rows else None
    except Exception:
        return None


def _roles_from_speaker(speaker: dict | None) -> tuple[bool, bool]:
    if not speaker:
        return False, False
    role = speaker.get("role")
    generation = speaker.get("generation")
    is_elder = bool(speaker.get("is_elder")) or role in ELDER_SPEAKER_ROLES or generation == "elder"
    is_keeper = is_elder or role in KEEPER_SPEAKER_ROLES
    return is_keeper, is_elder


def _fetch_clerk_jwks() -> dict:
    global _clerk_jwks_cache
    if _clerk_jwks_cache is not None:
        return _clerk_jwks_cache
    url = settings.clerk_jwks_url or "https://api.clerk.com/v1/jwks"
    headers: dict[str, str] = {}
    if "api.clerk.com" in url:
        headers["Authorization"] = f"Bearer {settings.clerk_secret_key}"
    with httpx.Client(timeout=10.0) as client:
        response = client.get(url, headers=headers)
        response.raise_for_status()
        _clerk_jwks_cache = response.json()
    return _clerk_jwks_cache


def _clerk_signing_key(token: str):
    header = jwt.get_unverified_header(token)
    kid = header.get("kid")
    jwk_set = PyJWKSet.from_dict(_fetch_clerk_jwks())
    for key in jwk_set.keys:
        if kid is None or key.key_id == kid:
            return key.key
    raise UnauthorizedError("Unable to verify Clerk token")


def actor_from_speaker(
    *,
    subject: str,
    issuer: str,
    speaker: dict | None,
    access_token: str | None = None,
    speaker_id_override: UUID | None = None,
) -> Actor:
    """Build an Actor from a verified subject + speakers row (no Clerk shortcut)."""
    is_keeper, is_elder = _roles_from_speaker(speaker)
    speaker_id = speaker_id_override
    if speaker_id is None and speaker:
        speaker_id = _parse_uuid(speaker.get("id"))
    return Actor(
        subject=subject,
        issuer=issuer,
        speaker_id=speaker_id,
        is_keeper=is_keeper,
        is_elder=is_elder,
        access_token=access_token,
    )


def _verify_dev(token: str) -> Actor:
    claims = jwt.decode(token, settings.auth_dev_secret, algorithms=["HS256"])
    if claims.get("iss") != "kuttiomp-dev":
        raise UnauthorizedError("Invalid development token")
    role = str(claims.get("role") or "")
    is_elder = bool(claims.get("is_elder")) or role == "elder"
    is_keeper = is_elder or role == "keeper"
    return Actor(
        subject=str(claims.get("sub") or "dev-user"),
        issuer=str(claims.get("actor_issuer") or "dev"),
        speaker_id=_parse_uuid(claims.get("speaker_id")),
        is_keeper=is_keeper,
        is_elder=is_elder,
        access_token=None,
    )


def _verify_clerk(token: str) -> Actor:
    key = _clerk_signing_key(token)
    decode_kwargs: dict = {
        "algorithms": ["RS256"],
        "options": {"verify_aud": False},
    }
    if settings.clerk_issuer:
        decode_kwargs["issuer"] = settings.clerk_issuer
    claims = jwt.decode(token, key, **decode_kwargs)
    subject = str(claims.get("sub") or "")
    if not subject:
        raise UnauthorizedError("Clerk token missing subject")
    speaker = _lookup_speaker(clerk_user_id=subject)
    return actor_from_speaker(subject=subject, issuer="clerk", speaker=speaker)


def _verify_supabase(token: str) -> Actor:
    if not settings.supabase_jwt_secret:
        raise UnauthorizedError("Supabase JWT verification is not configured")
    claims = jwt.decode(
        token,
        settings.supabase_jwt_secret,
        algorithms=["HS256"],
        audience="authenticated",
    )
    subject = str(claims.get("sub") or "")
    if not subject:
        raise UnauthorizedError("Supabase token missing subject")
    speaker = _lookup_speaker(clerk_user_id=subject)
    return actor_from_speaker(
        subject=subject,
        issuer="supabase",
        speaker=speaker,
        access_token=token,
    )


def verify_bearer_token(token: str) -> Actor:
    if _dev_auth_enabled():
        try:
            return _verify_dev(token)
        except UnauthorizedError:
            raise
        except (jwt.InvalidTokenError, jwt.InvalidKeyError, jwt.DecodeError):
            pass
        except Exception:
            pass
    try:
        header = jwt.get_unverified_header(token)
    except jwt.DecodeError as exc:
        raise UnauthorizedError("Malformed token") from exc
    alg = header.get("alg")
    if alg == "RS256":
        try:
            return _verify_clerk(token)
        except UnauthorizedError:
            raise
        except Exception as exc:
            raise UnauthorizedError("Invalid or expired Clerk token") from exc
    if settings.supabase_jwt_secret:
        try:
            return _verify_supabase(token)
        except UnauthorizedError:
            raise
        except jwt.InvalidTokenError as exc:
            raise UnauthorizedError("Invalid or expired Supabase token") from exc
    raise UnauthorizedError("Invalid or expired token")


def require_identity(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
) -> Actor:
    if credentials is None or credentials.scheme.lower() != "bearer" or not credentials.credentials:
        raise UnauthorizedError("Send Authorization: Bearer <jwt>")
    return verify_bearer_token(credentials.credentials)


def require_keeper(actor: Actor = Depends(require_identity)) -> Actor:
    if not actor.is_keeper:
        raise ForbiddenError("This route is limited to Knowledge Keepers")
    return actor


def require_elder(actor: Actor = Depends(require_identity)) -> Actor:
    if not actor.is_elder:
        raise ForbiddenError("Sacred content requires an elder session")
    return actor
