from pydantic import BaseModel
from datetime import datetime


class UserCreate(BaseModel):
    name: str 
    email: str
    password: str 


class UserResponse(BaseModel):
    id: str
    name: str
    email: str
    created_at: datetime


class UserLogin(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse


class UserUpdate(BaseModel):
    name: str | None = None
    email: str | None = None


class PasswordUpdate(BaseModel):
    password: str