import os
from supabase import create_client, Client
from core.config import Settings

settings = Settings()

supabase: Client = create_client(settings.supabase_url, settings.secret_key)