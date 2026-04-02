import os
import uuid
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

url = os.getenv("SUPABASE_URL")
key = os.getenv("SECRET_KEY")

print(f"URL: {url}")
print(f"Key starts with: {key[:10]}...")

supabase = create_client(url, key)

bucket_name = "scan-images"
file_content = b"test upload"
file_path = f"test/{uuid.uuid4()}.txt"

print(f"Attempting upload to bucket '{bucket_name}' at path '{file_path}'...")

try:
    response = supabase.storage.from_(bucket_name).upload(
        path=file_path,
        file=file_content,
        file_options={"content-type": "text/plain"}
    )
    print("SUCCESS: Upload works perfectly!")
    
    # Clean up
    supabase.storage.from_(bucket_name).remove(file_path)
    print("SUCCESS: Delete works too!")
    
except Exception as e:
    print(f"FAILED: {e}")
