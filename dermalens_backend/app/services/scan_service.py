import uuid
from fastapi import UploadFile, HTTPException
from app.schemas.scan import ScanResponse
from app.database.database import supabase
from app.services.prediction_service import predict_image
from datetime import datetime, timezone

async def process_new_scan(user_id: str, file: UploadFile) -> ScanResponse:
    # 1. Read the image bytes from the upload
    image_bytes = await file.read()

    # 2. Upload image to Supabase Storage bucket "scan-images"
    file_extension = file.filename.split(".")[-1] if file.filename else "jpg"
    unique_filename = f"{user_id}/{uuid.uuid4()}.{file_extension}"

    try:
        supabase.storage.from_("scan-images").upload(
            path=unique_filename,
            file=image_bytes,
            file_options={"content-type": file.content_type}
        )
        image_url = supabase.storage.from_("scan-images").get_public_url(unique_filename)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image upload failed: {str(e)}")

    # 3. Run prediction using the real model
    try:
        prediction = predict_image(image_bytes)
        condition = prediction["condition"]
        accuracy_score = prediction["confidence"]
        
        # Logging for tracking model performance
        print(f"--- Scan Analysis Complete ---")
        print(f"User ID: {user_id}")
        print(f"Predicted Condition: {condition}")
        print(f"Accuracy Score: {accuracy_score:.4f}")
        print(f"------------------------------")
        
    except Exception as e:
        print(f"Prediction failed: {e}")
        raise HTTPException(status_code=500, detail=f"Model inference failed: {str(e)}")

    # Risk levels based on standard dermatological triage (High/Medium/Low)
    CONDITION_SEVERITY = {
        "Melanoma": "High Risk",
        "Basal Cell Carcinoma": "Medium Risk",
        "Eczema": "Low Risk",
        "Atopic Dermatitis": "Low Risk",
        "Viral Infections": "Low Risk",
        "Fungal Infections": "Low Risk",
        "Psoriasis & Lichen Planus": "Medium Risk",
        "Melanocytic Nevi": "Low Risk",
        "Benign Keratosis": "Low Risk",
        "Seborrheic Keratoses": "Low Risk"
    }

    severity = CONDITION_SEVERITY.get(condition, "Low Risk")

    # 4. Save the result to the Supabase "scans" table
    scan_id = str(uuid.uuid4())
    scan_data = {
        "id": scan_id,
        "user_id": user_id,
        "image_url": image_url,
        "condition": condition,
        "severity": severity,
        "accuracy_score": accuracy_score,
        "top1": condition,
        "top2": "",
        "top3": "",
    }

    try:
        supabase.table("scans").insert(scan_data).execute()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save scan: {str(e)}")

    # 5. Return the full result
    return ScanResponse(
        id=scan_id,
        user_id=user_id,
        image_url=image_url,
        condition=condition,
        severity=severity,
        created_at=datetime.now(timezone.utc)
    )

async def get_user_scan_history(user_id: str):
    try:
        response = supabase.table("scans") \
            .select("*") \
            .eq("user_id", user_id) \
            .order("created_at", desc=True) \
            .execute()
        return response.data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch history: {str(e)}")
