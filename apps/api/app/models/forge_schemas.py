from typing import Any, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class ForgeEntryCreate(BaseModel):
    proposed_word: str = Field(min_length=1)
    english_gloss: str = Field(min_length=1)
    english_meaning: Optional[str] = None
    part_of_speech: str = "other"
    semantic_domain: str = "other"
    spiritual_significance: str = "none"
    visibility: str = "clan"
    orthographic_form: Optional[str] = None
    phonemic_transcription: Optional[str] = None
    ipa_transcription: Optional[str] = None
    pronunciation_notes: Optional[str] = None
    stress_pattern: Optional[str] = None
    morphological_breakdown: Optional[str] = None
    morpheme_gloss: Optional[str] = None
    derivation_type: Optional[str] = None
    generation_rule: Optional[str] = None
    source_roots_or_stems: list[dict[str, Any]] = Field(default_factory=list)
    related_existing_words: list[dict[str, Any]] = Field(default_factory=list)
    algonquian_cognates: Optional[str] = None
    proto_algonquian_or_deeper_roots: Optional[str] = None
    historical_attestation_status: Optional[str] = None
    source_citations: Optional[str] = None
    linguistic_justification: Optional[str] = None
    cultural_notes: Optional[str] = None
    confidence_score: int = 50
    confidence_rationale: Optional[str] = None
    potential_issues: Optional[str] = None
    usage_notes: Optional[str] = None
    collocations: Optional[str] = None
    tags: list[str] = Field(default_factory=list)
    is_demo_visible: bool = False
    submitted_by: Optional[UUID] = None
    last_updated_by: Optional[UUID] = None


class ForgeEntryResponse(BaseModel):
    id: UUID
    proposed_word: str
    english_gloss: str
    status: str
    semantic_domain: Optional[str] = None
    confidence_score: int = 50
    is_demo_visible: bool = True
    is_production_ready: bool = False
    version: int = 1
    lexical_entry_id: Optional[UUID] = None

    class Config:
        extra = "allow"


class ForgeStatusChange(BaseModel):
    status: str
    actor_id: Optional[UUID] = None
    notes: Optional[str] = None


class ForgeVisibilityUpdate(BaseModel):
    actor_id: Optional[UUID] = None
    demo_visible: bool = True
    production_ready: bool = False


class ForgeCommentCreate(BaseModel):
    author_id: Optional[UUID] = None
    body: str = Field(min_length=1)


class CorpusModulesUpdate(BaseModel):
    """Partial module patch. Omitted flags stay as they are."""

    model_config = ConfigDict(populate_by_name=True)

    feed_historical: Optional[bool] = Field(default=None, alias="feedHistorical")
    feed_approved_living: Optional[bool] = Field(default=None, alias="feedApprovedLiving")
    feed_forge_demo_merge: Optional[bool] = Field(default=None, alias="feedForgeDemoMerge")
