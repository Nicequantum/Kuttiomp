from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi

from app.config import settings
from app.exceptions import (
    KuttiompAPIError,
    kuttiomp_exception_handler,
    validation_exception_handler,
)
from app.routers import (
    audio,
    clans,
    contributions,
    cultural,
    grok,
    grok_test,
    health,
    land,
    lexicon,
    orthographies,
    speakers,
)

API_DESCRIPTION = """
## Kuttiomp API — Narragansett Language Revitalization Platform

Backend for the sacred work of preserving and transmitting Narragansett language
through multi-generational clan-based knowledge transmission.

### Cultural Governance
All endpoints operate under the **Twelve Cultural Governance Protocols**.
Sacred content is restricted from public endpoints.

### Authentication
Admin dashboard uses Clerk. Backend operations use Supabase service role.

### Key Resources
- **Speakers** — Multi-generational Knowledge Keepers
- **Lexicon** — PhD-grade lexical documentation
- **Audio** — Speaker-attributed recordings
- **Cultural** — Mother Earth, ceremony, TEK contexts
- **Land** — PostGIS place-based knowledge
- **Contributions** — Knowledge Keeper submission workflow
"""

app = FastAPI(
    title="Kuttiomp API",
    description=API_DESCRIPTION,
    version="0.4.0",
    docs_url="/docs",
    redoc_url="/redoc",
    contact={
        "name": "Kuttiomp — Narragansett Language Revitalization",
        "url": "https://github.com/Nicequantum/Kuttiomp",
    },
    license_info={
        "name": "Cultural content belongs to the Narragansett people",
    },
)

app.add_exception_handler(KuttiompAPIError, kuttiomp_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(grok_test.router)
app.include_router(clans.router, prefix="/api/v1")
app.include_router(speakers.router, prefix="/api/v1")
app.include_router(lexicon.router, prefix="/api/v1")
app.include_router(audio.router, prefix="/api/v1")
app.include_router(grok.router, prefix="/api/v1")
app.include_router(cultural.router, prefix="/api/v1")
app.include_router(land.router, prefix="/api/v1")
app.include_router(contributions.router, prefix="/api/v1")
app.include_router(orthographies.router, prefix="/api/v1")


def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
    )
    schema["info"]["x-cultural-protocols"] = 12
    schema["info"]["x-platform"] = "kuttiomp"
    app.openapi_schema = schema
    return app.openapi_schema


app.openapi = custom_openapi


@app.get("/", tags=["Root"])
async def root():
    return {
        "name": "Kuttiomp",
        "version": "0.4.0",
        "description": "Narragansett Language Revitalization Platform",
        "message": "Wunnegan — Welcome. The API is running.",
        "docs": "/docs",
        "cultural_protocols": 12,
    }