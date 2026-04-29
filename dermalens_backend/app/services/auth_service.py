from fastapi import HTTPException, status
from app.schemas.user import UserCreate, UserResponse, UserLogin, TokenResponse
from app.database.database import supabase

def create_user(user: UserCreate) -> UserResponse:
    try:
        response = supabase.auth.sign_up({
            "email": user.email,
            "password": user.password,
            "options": {
                "data": {
                    "name": user.name
                }
            }
        })
        
        if not response.user:
            raise HTTPException(status_code=400, detail="Signup failed. No user returned.")
            
        return UserResponse(
            id=response.user.id,
            name=response.user.user_metadata.get("name", user.name),
            email=response.user.email,
            created_at=response.user.created_at
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

def login_user(user: UserLogin) -> TokenResponse:
    try:
        response = supabase.auth.sign_in_with_password({
            "email": user.email,
            "password": user.password
        })
        
        if not response.session:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Login failed. Check your email and password."
            )
            
        return TokenResponse(
            access_token=response.session.access_token,
            token_type="bearer",
            user=UserResponse(
                id=response.user.id,
                name=response.user.user_metadata.get("name", response.user.user_metadata.get("full_name", "")),
                email=response.user.email,
                created_at=response.user.created_at
            )
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e)
        )
