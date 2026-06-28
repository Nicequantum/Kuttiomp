from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers import audio, clans, grok, health, lexicon, speakers

app = FastAPI(
    title="Kuttiomp API",
    description=(
        "Backend for the Narragansett Language Revitalization Platform. "
        "Honoring multi-generational clan-based knowledge transmission."
    ),
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(clans.router, prefix="/api/v1")
app.include_router(speakers.router, prefix="/api/v1")
app.include_router(lexicon.router, prefix="/api/v1")
app.include_router(audio.router, prefix="/api/v1")
app.include_router(grok.router, prefix="/api/v1")


@app.get("/")
async def root():
    return {
        "name": "Kuttiomp",
        "description": "Narragansett Language Revitalization Platform",
        "message": "Wunnegan — Welcome. The API is running.",
        "docs": "/docs",
    }