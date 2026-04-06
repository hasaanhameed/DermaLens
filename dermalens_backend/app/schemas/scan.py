from pydantic import BaseModel
from datetime import datetime


class ScanResponse(BaseModel):
    id: str
    user_id: str
    image_url: str
    condition: str
    severity: str
    ai_recommendation: str | None = None
    created_at: datetime
