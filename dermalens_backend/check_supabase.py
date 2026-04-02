import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

url = os.getenv("SUPABASE_URL")
key = os.getenv("SECRET_KEY")

supabase = create_client(url, key)

try:
    buckets = supabase.storage.list_buckets()
    print("Buckets found:", [b.name for b in buckets])
    
    # Check if scan-images exists
    if any(b.name == "scan-images" for b in buckets):
        print("Bucket 'scan-images' exists.")
        bucket = next(b for b in buckets if b.name == "scan-images")
        print(f"Bucket 'scan-images' is public: {bucket.public}")
    else:
        print("ERROR: Bucket 'scan-images' does not exist!")

except Exception as e:
    print(f"FAILED to list buckets: {e}")
