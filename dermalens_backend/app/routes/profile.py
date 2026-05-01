from fastapi import APIRouter, status, Depends
from fastapi.security import HTTPAuthorizationCredentials
from app.schemas.user import UserResponse, UserUpdate, PasswordUpdate
from app.utils.auth_utils import get_current_user, security
from app.services.profile_service import update_user_profile, update_user_password, delete_user_account
from app.services.cache_service import CacheService
import hashlib

router = APIRouter(prefix="/profile", tags=["Profile"])
cache_service = CacheService()

@router.get("", response_model=UserResponse)
async def get_profile(current_user: UserResponse = Depends(get_current_user)):
    return current_user

@router.put("", response_model=UserResponse)
async def update_profile(
    update_data: UserUpdate, 
    credentials: HTTPAuthorizationCredentials = Depends(security),
    current_user: UserResponse = Depends(get_current_user)
):
    result = update_user_profile(
        user_id=current_user.id, 
        current_name=current_user.name, 
        update_data=update_data, 
        token=credentials.credentials
    )
    
    # Invalidate cache
    token_hash = hashlib.sha256(credentials.credentials.encode()).hexdigest()
    cache_service.redis.delete(f"auth_token:{token_hash}")
    
    return result

@router.put("/password")
async def update_password_route(
    update_data: PasswordUpdate, 
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    result = update_user_password(
        password=update_data.password, 
        token=credentials.credentials
    )
    
    # Invalidate cache
    token_hash = hashlib.sha256(credentials.credentials.encode()).hexdigest()
    cache_service.redis.delete(f"auth_token:{token_hash}")
    
    return result

@router.delete("", status_code=status.HTTP_204_NO_CONTENT)
async def delete_profile(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    current_user: UserResponse = Depends(get_current_user)
):
    # Invalidate cache
    token_hash = hashlib.sha256(credentials.credentials.encode()).hexdigest()
    cache_service.redis.delete(f"auth_token:{token_hash}")
    
    return delete_user_account(current_user.id)