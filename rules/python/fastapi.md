<![CDATA[# FastAPI Rules

Best practices for building APIs with FastAPI.

## 1. Router Organization

**Organize routes by domain:**

```
app/
├── main.py
├── config.py
├── routers/
│   ├── __init__.py
│   ├── users.py
│   ├── products.py
│   └── orders.py
├── models/
│   ├── __init__.py
│   └── user.py
├── schemas/
│   ├── __init__.py
│   └── user.py
├── services/
│   ├── __init__.py
│   └── user_service.py
└── dependencies.py
```

**Router pattern:**
```python
# routers/users.py
from fastapi import APIRouter, Depends, HTTPException
from ..schemas import UserCreate, UserResponse
from ..services import UserService
from ..dependencies import get_current_user

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)

@router.get("/", response_model=list[UserResponse])
async def list_users(
    skip: int = 0,
    limit: int = 100,
    service: UserService = Depends()
):
    return await service.get_all(skip=skip, limit=limit)

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, service: UserService = Depends()):
    user = await service.get_by_id(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

**Main app:**
```python
# main.py
from fastapi import FastAPI
from .routers import users, products, orders

app = FastAPI(
    title="My API",
    version="1.0.0",
    description="API description"
)

app.include_router(users.router)
app.include_router(products.router)
app.include_router(orders.router)
```

---

## 2. Pydantic Models (Schemas)

**Always use Pydantic for request/response validation:**

```python
# schemas/user.py
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from typing import Optional

# Base schema with shared fields
class UserBase(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=100)

# For creating (input)
class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

# For updating (optional fields)
class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    
    model_config = {"extra": "forbid"}  # Reject unknown fields

# For responses (output)
class UserResponse(UserBase):
    id: int
    created_at: datetime
    is_active: bool = True
    
    model_config = {"from_attributes": True}  # Enable ORM mode
```

**Using in routes:**
```python
@router.post("/", response_model=UserResponse, status_code=201)
async def create_user(user: UserCreate, service: UserService = Depends()):
    # user is already validated by Pydantic
    return await service.create(user)
```

---

## 3. Async Endpoints

**Use async for I/O operations:**

```python
# Good: Async for I/O
@router.get("/users/{user_id}")
async def get_user(user_id: int):
    user = await db.fetch_one("SELECT * FROM users WHERE id = $1", user_id)
    return user

# Good: Use run_in_executor for sync libraries
import asyncio
from concurrent.futures import ThreadPoolExecutor

executor = ThreadPoolExecutor(max_workers=4)

@router.get("/file/{filename}")
async def read_file(filename: str):
    loop = asyncio.get_event_loop()
    content = await loop.run_in_executor(
        executor,
        lambda: Path(filename).read_text()
    )
    return {"content": content}

# Async database with asyncpg
from databases import Database

database = Database(DATABASE_URL)

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()
```

---

## 4. Error Handling

**Use HTTPException with proper status codes:**

```python
from fastapi import HTTPException, status

# Standard HTTP exceptions
@router.get("/users/{user_id}")
async def get_user(user_id: int):
    user = await db.get_user(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user

# Custom exception with headers
raise HTTPException(
    status_code=401,
    detail="Invalid token",
    headers={"WWW-Authenticate": "Bearer"}
)

# Global exception handler
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    return JSONResponse(
        status_code=400,
        content={"detail": str(exc)}
    )

# Custom exception types
class NotFoundError(Exception):
    def __init__(self, resource: str, id: int):
        self.resource = resource
        self.id = id

@app.exception_handler(NotFoundError)
async def not_found_handler(request: Request, exc: NotFoundError):
    return JSONResponse(
        status_code=404,
        content={"detail": f"{exc.resource} with id {exc.id} not found"}
    )
```

---

## 5. CORS Middleware

**Configure CORS properly:**

```python
from fastapi.middleware.cors import CORSMiddleware

# Development (permissive)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Production (restrictive)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://yourdomain.com",
        "https://app.yourdomain.com"
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
    max_age=600,  # Cache preflight for 10 minutes
)

# Dynamic origins from config
from functools import lru_cache
from .config import Settings

@lru_cache()
def get_settings():
    return Settings()

settings = get_settings()
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins.split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 6. Dependencies

**Use dependency injection:**

```python
# dependencies.py
from fastapi import Depends, HTTPException, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Security(security)
) -> User:
    token = credentials.credentials
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user = await get_user_by_id(int(user_id))
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    return user

async def get_current_admin(
    user: User = Depends(get_current_user)
) -> User:
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin required")
    return user

# Usage
@router.delete("/users/{user_id}")
async def delete_user(
    user_id: int,
    admin: User = Depends(get_current_admin)  # Requires admin
):
    await delete_user_by_id(user_id)
    return {"ok": True}
```

---

## 7. Background Tasks

```python
from fastapi import BackgroundTasks

def send_email(email: str, message: str):
    # Send email logic
    pass

@router.post("/notify")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks
):
    background_tasks.add_task(send_email, email, "Welcome!")
    return {"message": "Notification queued"}

# For longer tasks, use Celery or ARQ
```

---

## 8. File Uploads

```python
from fastapi import File, UploadFile
from pathlib import Path
import aiofiles

UPLOAD_DIR = Path("uploads")
ALLOWED_TYPES = {"image/jpeg", "image/png", "image/webp"}
MAX_SIZE = 5 * 1024 * 1024  # 5MB

@router.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    # Validate type
    if file.content_type not in ALLOWED_TYPES:
        raise HTTPException(400, "Invalid file type")
    
    # Validate size (check first 5MB)
    contents = await file.read()
    if len(contents) > MAX_SIZE:
        raise HTTPException(400, "File too large")
    
    # Generate safe filename
    import uuid
    ext = Path(file.filename).suffix
    filename = f"{uuid.uuid4()}{ext}"
    filepath = UPLOAD_DIR / filename
    
    # Save file
    async with aiofiles.open(filepath, "wb") as f:
        await f.write(contents)
    
    return {"filename": filename}
```

---

## Quick Reference

```python
# FastAPI essentials
from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel, Field, EmailStr

# Response models
response_model=UserResponse
status_code=201

# Path/Query parameters
user_id: int                    # Path parameter
skip: int = 0                   # Query parameter with default
q: Optional[str] = None         # Optional query parameter

# Validation
Field(..., min_length=1)        # Required with validation
Field(None, max_length=100)     # Optional with validation
```
]]>