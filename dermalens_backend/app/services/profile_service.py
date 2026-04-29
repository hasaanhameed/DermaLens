from fastapi import HTTPException, status
from app.schemas.user import UserResponse, UserUpdate
from app.database.database import supabase

def update_user_profile(user_id: str, current_name: str, update_data: UserUpdate, token: str) -> UserResponse:
    try:
        # Extract the token string and authorize the client
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
            name=user.user_metadata.get("name", current_name),
            email=user.email,
            created_at=user.created_at
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

def update_user_password(password: str, token: str):
    try:
        supabase.postgrest.auth(token)
        supabase.auth.update_user({"password": password})
        return {"message": "Password updated successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

def delete_user_account(user_id: str):
    try:
        # Admin is still required for deletion
        supabase.auth.admin.delete_user(user_id)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
