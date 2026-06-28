from fastapi import APIRouter, HTTPException

from app.models.schemas import GrokLinguisticRequest, GrokLinguisticResponse
from app.services.grok import query_grok

router = APIRouter(prefix="/ai", tags=["AI Assistance"])


@router.post("/linguistic", response_model=GrokLinguisticResponse)
async def linguistic_assistance(request: GrokLinguisticRequest):
    valid_types = {"translation", "etymology", "pronunciation_help", "cultural_context"}
    if request.prompt_type not in valid_types:
        raise HTTPException(
            status_code=400,
            detail=f"prompt_type must be one of: {', '.join(valid_types)}",
        )

    try:
        response_text, interaction_id = await query_grok(
            prompt_type=request.prompt_type,
            text=request.text,
            speaker_context_id=(
                str(request.speaker_context_id) if request.speaker_context_id else None
            ),
            lexical_entry_id=(
                str(request.lexical_entry_id) if request.lexical_entry_id else None
            ),
        )
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Grok API error: {str(e)}")

    return GrokLinguisticResponse(
        response=response_text,
        interaction_id=interaction_id,
    )