from fastapi import APIRouter, HTTPException, status
from schemas.user import UserCreate, UserResponse
from database.database import supabase

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("/signup", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate):
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
            
        # Return the created user response
        return UserResponse(
            id=response.user.id,
            name=response.user.user_metadata.get("name", user.name),
            email=response.user.email,
            created_at=response.user.created_at
        )

    except Exception as e:
        # Catch Supabase AuthApiError
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
