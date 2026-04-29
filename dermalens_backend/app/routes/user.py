from fastapi import APIRouter, status, Depends
from app.schemas.user import UserCreate, UserResponse, UserLogin, TokenResponse
from app.utils.auth_utils import get_current_user
from app.services.auth_service import create_user, login_user

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("/signup", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def signup_route(user: UserCreate):
    return create_user(user)

@router.post("/login", response_model=TokenResponse)
async def login_route(user: UserLogin):
    return login_user(user)

@router.get("/me", response_model=UserResponse)
async def get_me(current_user: UserResponse = Depends(get_current_user)):
    return current_user
