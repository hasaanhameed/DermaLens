from fastapi import APIRouter, HTTPException, status, Depends
from schemas.user import UserResponse, UserUpdate, PasswordUpdate
from database.database import supabase
from services.auth_service import get_current_user

router = APIRouter(prefix="/profile", tags=["Profile"])

@router.get("", response_model=UserResponse)
async def get_profile(current_user: UserResponse = Depends(get_current_user)):
    return current_user

@router.put("", response_model=UserResponse)
async def update_profile(update_data: UserUpdate, current_user: UserResponse = Depends(get_current_user)):
    try:
        attributes = {}
        if update_data.email is not None:
            attributes["email"] = update_data.email
        if update_data.name is not None:
            attributes["user_metadata"] = {"name": update_data.name}

        if not attributes:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No fields to update"
            )

        response = supabase.auth.admin.update_user_by_id(
            current_user.id,
            attributes
        )
        user = response.user
        return UserResponse(
            id=user.id,
            name=user.user_metadata.get("name", current_user.name),
            email=user.email,
            created_at=user.created_at
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.put("/password")
async def update_password(update_data: PasswordUpdate, current_user: UserResponse = Depends(get_current_user)):
    try:
        supabase.auth.admin.update_user_by_id(
            current_user.id,
            {"password": update_data.password}
        )
        return {"message": "Password updated successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.delete("", status_code=status.HTTP_204_NO_CONTENT)
async def delete_profile(current_user: UserResponse = Depends(get_current_user)):
    try:
        supabase.auth.admin.delete_user(current_user.id)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
