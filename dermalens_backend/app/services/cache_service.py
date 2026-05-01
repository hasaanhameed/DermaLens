import redis
import os
import json

class CacheService:
    def __init__(self):
        redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
        self.redis = redis.from_url(redis_url, decode_responses=True)

    def get_cached_recommendation(self, condition: str):
        """Retrieve cached recommendation for a condition."""
        key = f"recommendation:{condition.lower().replace(' ', '_')}"
        data = self.redis.get(key)
        if data:
            return json.loads(data)
        return None

    def cache_recommendation(self, condition: str, recommendation: str, days=7):
        """Cache recommendation for a specific condition."""
        key = f"recommendation:{condition.lower().replace(' ', '_')}"
        self.redis.setex(
            key,
            days * 24 * 60 * 60,
            json.dumps(recommendation)
        )

    def invalidate_cache(self, key: str):
        """Remove a specific key from cache."""
        self.redis.delete(key)

    # --- User Profile Caching ---
    def get_user_profile(self, user_id: str):
        """Retrieve cached profile for a user."""
        key = f"user_profile:{user_id}"
        data = self.redis.get(key)
        if data:
            return json.loads(data)
        return None

    def cache_user_profile(self, user_id: str, profile_data: dict, hours=1):
        """Cache user profile data (short-lived)."""
        key = f"user_profile:{user_id}"
        self.redis.setex(
            key,
            hours * 3600,
            json.dumps(profile_data)
        )

    def invalidate_user_cache(self, user_id: str):
        """Invalidate a specific user's cached profile."""
        self.redis.delete(f"user_profile:{user_id}")
