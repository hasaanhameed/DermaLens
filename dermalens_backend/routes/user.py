from fastapi import APIRouter, HTTPException, status, Depends
from schemas.user import UserCreate, UserResponse
from database.database import supabase
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials


security = HTTPBearer()

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Extracts the JWT token from the header and verifies it with Supabase"""
    try:
        response = supabase.auth.get_user(credentials.credentials)
        if not response.user:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")
        return response.user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=str(e))


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




@router.get("/me", response_model=UserResponse)
async def get_my_profile(current_user: dict = Depends(get_current_user)):
    """Returns the profile of the currently logged-in user."""
    return UserResponse(
        id=current_user.id,
        name=current_user.user_metadata.get("name", "Unknown User"),
        email=current_user.email,
        created_at=current_user.created_at
    )
