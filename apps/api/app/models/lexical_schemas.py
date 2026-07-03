from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field, field_validator, model_validator


class SemanticDomain(str, Enum):
    flora = "flora"
    fauna = "fauna"
    weather = "weather"
    water = "water"
    geography = "geography"
    kinship = "kinship"
    ceremony = "ceremony"
    tools = "tools"
    food = "food"
    medicine = "medicine"
    spiritual = "spiritual"
    governance = "governance"
    emotion = "emotion"
    movement = "movement"
    time = "time"
    color = "color"
    other = "other"


class SeasonalUsage(str, Enum):
    spring = "spring"
    summer = "summer"
    fall = "fall"
    winter = "winter"
    year_round = "year_round"
    ceremonial_season = "ceremonial_season"
    harvest = "harvest"
    planting = "planting"


class SpiritualSignificance(str, Enum):
    none = "none"
    respectful = "respectful"
    ceremonial = "ceremonial"
    sacred = "sacred"
    restricted = "restricted"


class LexicalCategory(str, Enum):
    noun = "noun"
    verb = "verb"
    adjective = "adjective"
    adverb = "adverb"
    pronoun = "pronoun"
    particle = "particle"
    interjection = "interjection"
    phrase = "phrase"
    proverb = "proverb"
    prayer = "prayer"
    ceremonial = "ceremonial"
    place_name = "place_name"
    personal_name = "personal_name"
    kinship_term = "kinship_term"
    natural_world = "natural_world"
    numeral = "numeral"
    classifier = "classifier"
    incorporative = "incorporative"
    other = "other"


class ContentVisibility(str, Enum):
    public = "public"
    clan = "clan"
    family = "family"
    elders_only = "elders_only"
    sacred = "sacred"


class ApprovalStatus(str, Enum):
    draft = "draft"
    pending = "pending"
    under_review = "under_review"
    requires_elder_review = "requires_elder_review"
    approved = "approved"
    rejected = "rejected"
    archived = "archived"


class CulturalContextType(str, Enum):
    mother_earth = "mother_earth"
    ceremony = "ceremony"
    traditional_ecological_knowledge = "traditional_ecological_knowledge"
    kinship = "kinship"
    seasonal_cycle = "seasonal_cycle"
    spiritual_significance = "spiritual_significance"
    historical = "historical"
    contemporary_usage = "contemporary_usage"


class SpellingVariantInput(BaseModel):
    orthography_id: Optional[UUID] = None
    spelling: str = Field(min_length=1, max_length=500)
    notes: Optional[str] = None
    is_preferred: bool = False


class ExampleSentenceInput(BaseModel):
    sentence_narragansett: str = Field(min_length=1)
    sentence_english: str = Field(min_length=1)
    literal_gloss: Optional[str] = None
    cultural_context: Optional[str] = None
    speaker_id: Optional[UUID] = None


class CulturalContextInput(BaseModel):
    context_type: CulturalContextType
    title: str = Field(min_length=1, max_length=500)
    narrative: str = Field(min_length=10)
    mother_earth_connection: Optional[str] = None
    ceremonial_notes: Optional[str] = None
    tek_notes: Optional[str] = None
    seasonal_usage: Optional[str] = None
    spiritual_significance: Optional[str] = None
    visibility: ContentVisibility = ContentVisibility.clan


class LexicalEntryCreateV2(BaseModel):
    word_narragansett: str = Field(min_length=1, max_length=500)
    english_gloss: str = Field(min_length=1, max_length=1000)
    english_gloss_extended: Optional[str] = None
    alternate_spellings: list[str] = Field(default_factory=list)
    phonemic_transcription: Optional[str] = None
    ipa_transcription: Optional[str] = None
    morphological_breakdown: Optional[str] = None
    morpheme_gloss: Optional[str] = None
    etymology_notes: Optional[str] = None
    etymology_source: Optional[str] = None
    usage_notes: Optional[str] = None
    register: Optional[str] = None
    category: LexicalCategory = LexicalCategory.other
    semantic_domain: SemanticDomain = SemanticDomain.other
    domain_id: Optional[UUID] = None
    ecological_connection: Optional[str] = None
    seasonal_usage: list[SeasonalUsage] = Field(default_factory=list)
    spiritual_significance: SpiritualSignificance = SpiritualSignificance.none
    cultural_context_summary: Optional[str] = None
    visibility: ContentVisibility = ContentVisibility.clan
    is_sacred: bool = False
    is_archaic: bool = False
    is_neologism: bool = False
    primary_speaker_id: Optional[UUID] = None
    primary_orthography_id: Optional[UUID] = None
    created_by: Optional[UUID] = None
    spelling_variants: list[SpellingVariantInput] = Field(default_factory=list)
    example_sentences: list[ExampleSentenceInput] = Field(default_factory=list)
    cultural_contexts: list[CulturalContextInput] = Field(default_factory=list)

    @model_validator(mode="after")
    def validate_sacred_rules(self):
        if self.is_sacred and self.visibility == ContentVisibility.public:
            raise ValueError("Sacred content cannot have public visibility (Protocol 4)")
        if self.spiritual_significance == SpiritualSignificance.sacred and not self.is_sacred:
            raise ValueError("Spiritual significance 'sacred' requires is_sacred=true")
        return self


class LexicalEntryUpdateV2(BaseModel):
    word_narragansett: Optional[str] = Field(None, min_length=1, max_length=500)
    english_gloss: Optional[str] = Field(None, min_length=1, max_length=1000)
    english_gloss_extended: Optional[str] = None
    alternate_spellings: Optional[list[str]] = None
    phonemic_transcription: Optional[str] = None
    ipa_transcription: Optional[str] = None
    morphological_breakdown: Optional[str] = None
    morpheme_gloss: Optional[str] = None
    etymology_notes: Optional[str] = None
    etymology_source: Optional[str] = None
    usage_notes: Optional[str] = None
    register: Optional[str] = None
    category: Optional[LexicalCategory] = None
    semantic_domain: Optional[SemanticDomain] = None
    domain_id: Optional[UUID] = None
    ecological_connection: Optional[str] = None
    seasonal_usage: Optional[list[SeasonalUsage]] = None
    spiritual_significance: Optional[SpiritualSignificance] = None
    cultural_context_summary: Optional[str] = None
    visibility: Optional[ContentVisibility] = None
    is_sacred: Optional[bool] = None
    is_archaic: Optional[bool] = None
    is_neologism: Optional[bool] = None
    primary_speaker_id: Optional[UUID] = None
    primary_orthography_id: Optional[UUID] = None
    approval_status: Optional[ApprovalStatus] = None


class BulkLexicalEntryInput(LexicalEntryCreateV2):
    land_site_id: Optional[UUID] = None
    speaker_ids: list[UUID] = Field(default_factory=list)


class BulkImportRowResult(BaseModel):
    index: int
    word_narragansett: str
    status: str
    entry_id: Optional[UUID] = None
    error: Optional[str] = None


class BulkImportResponse(BaseModel):
    total: int
    approved: int
    requires_elder_review: int
    failed: int
    results: list[BulkImportRowResult]


class LexicalEntryResponseV2(BaseModel):
    id: UUID
    word_narragansett: str
    word_normalized: str
    english_gloss: str
    english_gloss_extended: Optional[str] = None
    alternate_spellings: list[str] | None = Field(default_factory=list)
    phonemic_transcription: Optional[str] = None
    ipa_transcription: Optional[str] = None
    morphological_breakdown: Optional[str] = None
    morpheme_gloss: Optional[str] = None
    etymology_notes: Optional[str] = None
    etymology_source: Optional[str] = None
    usage_notes: Optional[str] = None
    register: Optional[str] = None
    category: str
    semantic_domain: Optional[str] = None
    domain_id: Optional[UUID] = None
    ecological_connection: Optional[str] = None
    seasonal_usage: Optional[list[str]] = None
    spiritual_significance: Optional[str] = None
    cultural_context_summary: Optional[str] = None
    visibility: str
    is_sacred: bool = False
    is_archaic: bool = False
    is_neologism: bool = False
    primary_speaker_id: Optional[UUID] = None
    primary_orthography_id: Optional[UUID] = None
    approval_status: str
    approved_by: Optional[UUID] = None
    approved_at: Optional[datetime] = None
    created_by: Optional[UUID] = None
    created_at: datetime
    updated_at: datetime
   
    model_config = {"extra": "ignore"}
