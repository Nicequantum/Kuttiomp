from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field


class SpeakerRole(str, Enum):
    grandmother = "grandmother"
    grandfather = "grandfather"
    sharente = "sharente"
    parent = "parent"
    sibling = "sibling"
    clan_member = "clan_member"
    learner = "learner"
    guest_speaker = "guest_speaker"


class GenerationTier(str, Enum):
    elder = "elder"
    middle = "middle"
    younger = "younger"
    ancestral = "ancestral"


class ContentVisibility(str, Enum):
    public = "public"
    clan = "clan"
    family = "family"
    elders_only = "elders_only"
    sacred = "sacred"


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
    other = "other"


class AudioQuality(str, Enum):
    archival = "archival"
    studio = "studio"
    field = "field"
    practice = "practice"
    live_ceremony = "live_ceremony"


class ApprovalStatus(str, Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"
    requires_elder_review = "requires_elder_review"


# --- Clan ---

class ClanBase(BaseModel):
    name_narragansett: str
    name_english: Optional[str] = None
    clan_animal: Optional[str] = None
    clan_color: Optional[str] = None
    territory_description: Optional[str] = None
    cultural_notes: Optional[str] = None
    is_primary_family_clan: bool = False


class ClanCreate(ClanBase):
    pass


class ClanResponse(ClanBase):
    id: UUID
    created_at: datetime
    updated_at: datetime


# --- Speaker ---

class SpeakerBase(BaseModel):
    display_name: str
    name_narragansett: Optional[str] = None
    role: SpeakerRole
    generation: GenerationTier = GenerationTier.middle
    clan_id: Optional[UUID] = None
    parent_speaker_id: Optional[UUID] = None
    biography: Optional[str] = None
    cultural_title: Optional[str] = None
    is_two_spirit: bool = False
    is_elder: bool = False
    is_active: bool = True
    birth_year: Optional[int] = None
    photo_url: Optional[str] = None
    voice_description: Optional[str] = None
    teaching_domains: list[str] = Field(default_factory=list)


class SpeakerCreate(SpeakerBase):
    clerk_user_id: Optional[str] = None


class SpeakerUpdate(BaseModel):
    display_name: Optional[str] = None
    name_narragansett: Optional[str] = None
    role: Optional[SpeakerRole] = None
    generation: Optional[GenerationTier] = None
    clan_id: Optional[UUID] = None
    parent_speaker_id: Optional[UUID] = None
    biography: Optional[str] = None
    cultural_title: Optional[str] = None
    is_two_spirit: Optional[bool] = None
    is_elder: Optional[bool] = None
    is_active: Optional[bool] = None
    teaching_domains: Optional[list[str]] = None


class SpeakerResponse(SpeakerBase):
    id: UUID
    clerk_user_id: Optional[str] = None
    created_at: datetime
    updated_at: datetime


class SpeakerTreeNode(SpeakerResponse):
    children: list["SpeakerTreeNode"] = Field(default_factory=list)


# --- Lexical Entry ---

class LexicalEntryBase(BaseModel):
    word_narragansett: str
    english_gloss: str
    alternate_spellings: list[str] = Field(default_factory=list)
    ipa_transcription: Optional[str] = None
    morphological_breakdown: Optional[str] = None
    etymology_notes: Optional[str] = None
    usage_notes: Optional[str] = None
    cultural_context: Optional[str] = None
    category: LexicalCategory = LexicalCategory.other
    domain_id: Optional[UUID] = None
    visibility: ContentVisibility = ContentVisibility.clan
    is_sacred: bool = False
    is_archaic: bool = False
    primary_speaker_id: Optional[UUID] = None


class LexicalEntryCreate(LexicalEntryBase):
    created_by: Optional[UUID] = None


class LexicalEntryUpdate(BaseModel):
    word_narragansett: Optional[str] = None
    english_gloss: Optional[str] = None
    alternate_spellings: Optional[list[str]] = None
    ipa_transcription: Optional[str] = None
    cultural_context: Optional[str] = None
    category: Optional[LexicalCategory] = None
    visibility: Optional[ContentVisibility] = None
    is_sacred: Optional[bool] = None
    primary_speaker_id: Optional[UUID] = None
    approval_status: Optional[ApprovalStatus] = None


class LexicalEntryResponse(LexicalEntryBase):
    id: UUID
    word_normalized: str
    approval_status: ApprovalStatus
    approved_by: Optional[UUID] = None
    approved_at: Optional[datetime] = None
    created_by: Optional[UUID] = None
    created_at: datetime
    updated_at: datetime


# --- Audio Recording ---

class AudioRecordingBase(BaseModel):
    lexical_entry_id: Optional[UUID] = None
    speaker_id: UUID
    recorded_by: Optional[UUID] = None
    quality: AudioQuality = AudioQuality.field
    recording_context: Optional[str] = None
    location_description: Optional[str] = None
    visibility: ContentVisibility = ContentVisibility.clan
    is_primary_recording: bool = False
    transcript: Optional[str] = None
    notes: Optional[str] = None


class AudioRecordingCreate(AudioRecordingBase):
    storage_path: str
    file_format: str = "webm"
    duration_seconds: Optional[float] = None
    sample_rate: Optional[int] = None


class AudioRecordingResponse(AudioRecordingBase):
    id: UUID
    storage_path: str
    storage_bucket: str
    file_format: str
    duration_seconds: Optional[float] = None
    sample_rate: Optional[int] = None
    approval_status: ApprovalStatus
    approved_by: Optional[UUID] = None
    approved_at: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime


class AudioUploadResponse(BaseModel):
    recording: AudioRecordingResponse
    public_url: Optional[str] = None


# --- Grok AI ---

class GrokLinguisticRequest(BaseModel):
    prompt_type: str = Field(
        description="translation | etymology | pronunciation_help | cultural_context"
    )
    text: str
    speaker_context_id: Optional[UUID] = None
    lexical_entry_id: Optional[UUID] = None


class GrokLinguisticResponse(BaseModel):
    response: str
    interaction_id: Optional[UUID] = None
    cultural_disclaimer: str = (
        "This AI assistance is a learning tool only. "
        "Elder knowledge keepers hold authoritative understanding of Narragansett language and culture."
    )


# --- Health ---

class HealthResponse(BaseModel):
    status: str
    service: str
    version: str


SpeakerTreeNode.model_rebuild()