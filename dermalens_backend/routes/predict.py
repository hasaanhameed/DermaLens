import uuid
import random
from fastapi import APIRouter, UploadFile, File, Depends, HTTPException, status
from schemas.scan import ScanResponse
from schemas.user import UserResponse
from services.auth_service import get_current_user
from database.database import supabase
from datetime import datetime, timezone

router = APIRouter(prefix="/scans", tags=["Scans"])

# --- PLACEHOLDER CONDITIONS ---
# Replace this with your real trained model later!
SKIN_CONDITIONS = [
    ("Benign Nevus", "Low Risk", "This appears to be a benign mole. Monitor for changes in size, shape, or color."),
    ("Melanoma", "High Risk", "Urgent: This may be melanoma. Please consult a dermatologist immediately."),
    ("Basal Cell Carcinoma", "Medium Risk", "This may be basal cell carcinoma. Schedule a dermatologist appointment soon."),
    ("Acne Vulgaris", "Low Risk", "This appears to be acne. Consider a consistent skincare routine."),
    ("Eczema", "Low Risk", "This appears to be eczema. Moisturize regularly and avoid known irritants."),
]

@router.post("/analyze", response_model=ScanResponse, status_code=status.HTTP_201_CREATED)
async def analyze_scan(
    file: UploadFile = File(...),
    current_user: UserResponse = Depends(get_current_user)
):
    # 1. Read the image bytes from the upload
    image_bytes = await file.read()

    # 2. Upload image to Supabase Storage bucket "scan-images"
    file_extension = file.filename.split(".")[-1] if file.filename else "jpg"
    unique_filename = f"{current_user.id}/{uuid.uuid4()}.{file_extension}"

    try:
        supabase.storage.from_("scan-images").upload(
            path=unique_filename,
            file=image_bytes,
            file_options={"content-type": file.content_type}
        )
        image_url = supabase.storage.from_("scan-images").get_public_url(unique_filename)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image upload failed: {str(e)}")

    # 3. Run prediction (placeholder - swap this for your real model!)
    condition, severity, recommendation = random.choice(SKIN_CONDITIONS)

    # 4. Save the result to the Supabase "scans" table
    scan_id = str(uuid.uuid4())
    scan_data = {
        "id": scan_id,
        "user_id": current_user.id,
        "image_url": image_url,
        "condition": condition,
        "severity": severity,
        "accuracy_score": 0.0,  # Dummy value to satisfy DB constraint
        "top1": "",             # Dummy value to satisfy DB constraint
        "top2": "",             # Dummy value to satisfy DB constraint
        "top3": "",             # Dummy value to satisfy DB constraint
        "ai_recommendation": recommendation,
    }

    try:
        supabase.table("scans").insert(scan_data).execute()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save scan: {str(e)}")

    # 5. Return the full result to Flutter
    return ScanResponse(
        id=scan_id,
        user_id=current_user.id,
        image_url=image_url,
        condition=condition,
        severity=severity,
        ai_recommendation=recommendation,
        created_at=datetime.now(timezone.utc)
    )
