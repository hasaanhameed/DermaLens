from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes import user, predict


app = FastAPI(title="DermaLens API")

# CORS Middleware - Added it only for testing, will remove in production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "DermaLens API is running"}

# Register routes
app.include_router(user.router)
app.include_router(predict.router)  