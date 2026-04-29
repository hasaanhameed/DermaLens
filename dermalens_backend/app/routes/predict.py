from fastapi import APIRouter, UploadFile, File, Depends, status
from app.schemas.scan import ScanResponse
from app.schemas.user import UserResponse
from app.utils.auth_utils import get_current_user
from app.services.scan_service import process_new_scan, get_user_scan_history

router = APIRouter(prefix="/scans", tags=["Scans"])

@router.post("/analyze", response_model=ScanResponse, status_code=status.HTTP_201_CREATED)
async def analyze_scan_route(
    file: UploadFile = File(...),
    current_user: UserResponse = Depends(get_current_user)
):
    return await process_new_scan(current_user.id, file)

@router.get("", response_model=list[ScanResponse])
async def get_scans_route(current_user: UserResponse = Depends(get_current_user)):
    return await get_user_scan_history(current_user.id)
