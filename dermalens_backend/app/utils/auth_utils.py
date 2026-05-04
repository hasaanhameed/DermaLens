from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.database.database import supabase
from app.schemas.user import UserResponse
from app.services.cache_service import CacheService
import hashlib
import json

security = HTTPBearer()
cache_service = CacheService()

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> UserResponse:
    token = credentials.credentials
    # Use hash of token as key for security and length
    token_hash = hashlib.sha256(token.encode()).hexdigest()
    cache_key = f"auth_token:{token_hash}"
    
    # 1. Check cache first
    cached_user = cache_service.redis.get(cache_key)
    if cached_user:
        data = json.loads(cached_user)
        return UserResponse(**data)

    # 2. Fallback to Supabase
    try:
        response = supabase.auth.get_user(token)
        
        if not response.user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired token",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        user = response.user
        user_data = UserResponse(
            id=user.id,
            name=user.user_metadata.get("name", ""),
            email=user.email,
            created_at=user.created_at
        )

        # 3. Cache the result (for 1 hour)
        cache_service.redis.setex(
            cache_key,
            3600,
            user_data.model_dump_json()
        )
        
        return user_data
            
    except Exception as e:
        print(f"Auth error: {str(e)}")
        if isinstance(e, HTTPException):
            raise e
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication failed: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )
