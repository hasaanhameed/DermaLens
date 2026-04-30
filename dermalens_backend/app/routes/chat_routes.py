from fastapi import APIRouter, HTTPException
from app.schemas.chat import ChatRequest, ChatResponse
from app.services.chat_service import generate_chat_response

router = APIRouter(prefix="/chat", tags=["chat"])

@router.post("/", response_model=ChatResponse)
async def chat_with_ai(request: ChatRequest):
    """
    Endpoint to chat with the AI about a diagnosed skin condition.
    """
    try:
        # Convert Pydantic models in history to list of dicts for the service
        history_dicts = [{"role": msg.role, "content": msg.content} for msg in request.history]
        
        response_text = generate_chat_response(
            message=request.message,
            history=history_dicts,
            condition=request.condition
        )
        
        return ChatResponse(response=response_text)
        
    except Exception as e:
        print(f"Route Error: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")
