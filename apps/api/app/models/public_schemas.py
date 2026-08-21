"""CamelCase wire types for the public learner lexicon (contract v1)."""

from typing import Optional

from pydantic import BaseModel, Field


class PublicAudio(BaseModel):
    url: str
    contentType: Optional[str] = None
    durationMs: Optional[int] = None
    speakerName: Optional[str] = None


class PublicWord(BaseModel):
    id: str
    wordNarragansett: str
    wordNormalized: Optional[str] = None
    englishGloss: str
    category: Optional[str] = None
    semanticDomain: str
    seasonalUsage: list[str] = Field(default_factory=list)
    isPhrase: bool = False
    orthographyNote: Optional[str] = None
    speakerAttribution: str
    speakerId: Optional[str] = None
    speakerRole: Optional[str] = None
    elderApproved: bool = True
    isSacred: bool = False
    source: str = "keeper_approved"
    authority: str = "living_speaker"
    primaryAudio: Optional[PublicAudio] = None
    tags: Optional[list[str]] = None
    updatedAt: Optional[str] = None


class PublicHealthResponse(BaseModel):
    ok: bool
    service: str = "kuttiomp-public"
    corpusVersion: Optional[str] = None
    wordCount: int = 0
    reason: Optional[str] = None


class PublicLexiconResponse(BaseModel):
    corpusVersion: str
    total: int
    limit: int
    offset: int
    words: list[PublicWord]
