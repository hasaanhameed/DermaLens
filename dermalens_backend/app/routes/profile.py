from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.security import HTTPAuthorizationCredentials
from app.schemas.user import UserResponse, UserUpdate, PasswordUpdate
from app.database.database import supabase
from app.services.auth_service import get_current_user, security

router = APIRouter(prefix="/profile", tags=["Profile"])

@router.get("", response_model=UserResponse)
async def get_profile(current_user: UserResponse = Depends(get_current_user)):
    return current_user

@router.put("", response_model=UserResponse)
async def update_profile(
    update_data: UserUpdate, 
    credentials: HTTPAuthorizationCredentials = Depends(security), # <--- Using HTTPBearer
    current_user: UserResponse = Depends(get_current_user)
):
    try:
        # Extract the token string and authorize the client
        token = credentials.credentials
        supabase.postgrest.auth(token) 
        
        attributes = {}
        if update_data.email is not None and update_data.email != "":
            attributes["email"] = update_data.email
        if update_data.name is not None and update_data.name != "":
            # Set user metadata for the name
            attributes["data"] = {"name": update_data.name}

        if not attributes:
             raise HTTPException(status_code=400, detail="No fields to update")

        # Standard update_user call
        response = supabase.auth.update_user(attributes)
        
        if response.user is None:
            raise HTTPException(status_code=400, detail="Update failed")

        user = response.user
        return UserResponse(
            id=user.id,
            name=user.user_metadata.get("name", current_user.name),
            email=user.email,
            created_at=user.created_at
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.put("/password")
async def update_password(
    update_data: PasswordUpdate, 
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    try:
        token = credentials.credentials
        supabase.postgrest.auth(token)
        supabase.auth.update_user({"password": update_data.password})
        return {"message": "Password updated successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.delete("", status_code=status.HTTP_204_NO_CONTENT)
async def delete_profile(current_user: UserResponse = Depends(get_current_user)):
    try:
        # Admin is still required for deletion
        supabase.auth.admin.delete_user(current_user.id)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )