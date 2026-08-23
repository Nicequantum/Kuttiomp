from uuid import UUID

from fastapi import APIRouter, Query

from app.models.public_schemas import PublicHealthResponse, PublicLexiconResponse, PublicWord
from app.services.public_lexicon import get_public_health, get_public_word, list_public_words

router = APIRouter(
    prefix="/public",
    tags=["Public Lexicon"],
    responses={
        404: {"description": "Not found"},
    },
)


@router.get(
    "/health",
    response_model=PublicHealthResponse,
    summary="Public lexicon health",
    description="Unauthenticated readiness probe with publishable word count.",
)
async def public_health():
    return get_public_health()


@router.get(
    "/lexicon",
    response_model=PublicLexiconResponse,
    summary="List public lexicon entries",
    description=(
        "Learner-facing lexicon. The publish gate is applied on the server: "
        "approved, public, non-sacred, non-restricted, with a non-empty gloss."
    ),
)
async def public_lexicon(
    limit: int = Query(default=100, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    domain: str | None = Query(None, description="Filter by semantic domain"),
    q: str | None = Query(None, description="Search Narragansett or English"),
):
    return list_public_words(limit=limit, offset=offset, domain=domain, q=q)


@router.get(
    "/lexicon/{entry_id}",
    response_model=PublicWord,
    summary="Get one public lexical entry",
    description="Returns 404 if the entry is missing or not publishable. Sacred rows are not distinguished.",
)
async def public_entry(entry_id: UUID):
    return get_public_word(entry_id)


@router.get(
    "/forge-feed",
    summary="Language Forge rows visible to learners",
    description=(
        "Unauthenticated. Sacred and restricted dossiers never appear. "
        "In keeper_only mode only approved + production-ready rows are returned."
    ),
)
async def public_forge_feed():
    from app.routers.forge import learner_feed_payload

    return learner_feed_payload()

