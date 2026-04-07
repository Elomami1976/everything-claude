<![CDATA[# Python General Rules

Modern Python best practices for clean, maintainable code.

## 1. Type Hints

**Always use type hints for function signatures:**

```python
from typing import Optional, List, Dict, Union, Callable

# Function parameters and return types
def process_user(user_id: int, options: Optional[Dict[str, str]] = None) -> User:
    pass

# Variables (when not obvious)
users: List[User] = []
config: Dict[str, Any] = {}

# Union types
def get_value(key: str) -> Union[str, int, None]:
    pass

# Python 3.10+ union syntax
def get_value(key: str) -> str | int | None:
    pass

# Callable types
def apply_filter(data: List[int], filter_fn: Callable[[int], bool]) -> List[int]:
    return [x for x in data if filter_fn(x)]
```

---

## 2. String Formatting

**Use f-strings (Python 3.6+):**

```python
# Good: f-strings
name = "Alice"
age = 30
message = f"Hello {name}, you are {age} years old"

# With expressions
message = f"Total: ${price * quantity:.2f}"

# Multi-line
sql = f"""
    SELECT * FROM users
    WHERE id = {user_id}
    AND status = {status!r}
"""

# Avoid: .format() and %
message = "Hello {}".format(name)  # Less readable
message = "Hello %s" % name        # Old style
```

---

## 3. List Comprehensions

**Use for simple transformations:**

```python
# Good: Simple comprehension
squares = [x ** 2 for x in range(10)]
names = [user.name for user in users if user.active]

# Good: Dict comprehension
user_dict = {user.id: user for user in users}

# Set comprehension
unique_names = {user.name for user in users}

# When NOT to use (too complex)
# Bad: Nested with multiple conditions
result = [x.value for x in items if x.active for y in x.children if y.valid]

# Better: Use regular loop
result = []
for x in items:
    if x.active:
        for y in x.children:
            if y.valid:
                result.append(x.value)
```

---

## 4. Exception Handling

**Be specific with exceptions:**

```python
# Good: Specific exceptions
try:
    value = config["key"]
except KeyError:
    value = "default"

# Good: Multiple specific exceptions
try:
    await fetch_data()
except ConnectionError:
    logger.error("Network unavailable")
except TimeoutError:
    logger.error("Request timed out")

# Bad: Bare except
try:
    risky_operation()
except:  # Catches everything, including KeyboardInterrupt!
    pass

# Bad: Overly broad exception
try:
    risky_operation()
except Exception:  # Better than bare, but still hides issues
    pass

# Custom exceptions
class ValidationError(Exception):
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")
```

---

## 5. Context Managers

**Use `with` for resource management:**

```python
# Files
with open("file.txt", "r") as f:
    content = f.read()

# Multiple resources
with open("input.txt") as f_in, open("output.txt", "w") as f_out:
    f_out.write(f_in.read().upper())

# Database connections
with get_db_connection() as conn:
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM users")

# Custom context manager
from contextlib import contextmanager

@contextmanager
def timer(name: str):
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f}s")

with timer("Processing"):
    process_data()
```

---

## 6. Classes and Dataclasses

**Use dataclasses for data containers:**

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class User:
    id: int
    email: str
    name: str
    active: bool = True
    roles: List[str] = field(default_factory=list)
    
    # Computed property
    @property
    def display_name(self) -> str:
        return self.name or self.email

# Usage
user = User(id=1, email="user@example.com", name="John")

# For immutability
@dataclass(frozen=True)
class Config:
    api_key: str
    base_url: str
```

---

## 7. Path Handling

**Use pathlib, not os.path:**

```python
from pathlib import Path

# Create paths
config_dir = Path.home() / ".config" / "myapp"
config_file = config_dir / "config.json"

# Check existence
if not config_dir.exists():
    config_dir.mkdir(parents=True)

# Read/write
content = config_file.read_text()
config_file.write_text(json.dumps(data))

# Iterate files
for py_file in Path(".").glob("**/*.py"):
    print(py_file)

# Get parts
print(config_file.stem)       # "config"
print(config_file.suffix)     # ".json"
print(config_file.parent)     # ~/.config/myapp
```

---

## 8. Logging

**Use logging module, not print:**

```python
import logging

# Configure once at startup
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

# Usage
logger.debug("Detailed debugging info")
logger.info("General information")
logger.warning("Something unexpected")
logger.error("Error occurred", exc_info=True)  # Include traceback
logger.critical("Critical failure")

# Never use print for logging
print("Debug info")  # Bad: Can't control level, format, destination
```

---

## 9. Async/Await

**For I/O-bound code:**

```python
import asyncio
import aiohttp

async def fetch_url(url: str) -> str:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.text()

async def fetch_all(urls: List[str]) -> List[str]:
    tasks = [fetch_url(url) for url in urls]
    return await asyncio.gather(*tasks)

# Run async code
results = asyncio.run(fetch_all(urls))

# With timeout
async def fetch_with_timeout(url: str, timeout: float = 10.0):
    async with asyncio.timeout(timeout):
        return await fetch_url(url)
```

---

## 10. Virtual Environments

**Always use virtual environments:**

```bash
# Create
python -m venv venv

# Activate (Unix)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Freeze dependencies
pip freeze > requirements.txt
```

**requirements.txt:**
```
# Pin versions for reproducibility
fastapi==0.104.1
pydantic==2.5.0
uvicorn[standard]==0.24.0
python-dotenv==1.0.0
```

---

## 11. Code Organization

```python
# Import order (use isort)
# 1. Standard library
import json
import os
from datetime import datetime
from typing import List, Optional

# 2. Third-party
import requests
from pydantic import BaseModel

# 3. Local
from .models import User
from .utils import validate_email

# Module structure
my_project/
├── __init__.py
├── main.py
├── config.py
├── models/
│   ├── __init__.py
│   └── user.py
├── services/
│   ├── __init__.py
│   └── user_service.py
└── utils/
    ├── __init__.py
    └── validators.py
```

---

## Quick Reference

```python
# Modern Python features
f"String {variable}"              # f-strings
[x for x in items if condition]   # List comprehension
x if condition else y             # Ternary
a := expensive_call()             # Walrus operator (3.8+)
**kwargs                          # Unpack dict
*args                             # Unpack list
match value:                      # Pattern matching (3.10+)
    case 1: ...
```
]]>