<![CDATA[# TypeScript General Rules

Best practices for type-safe TypeScript development.

## 1. Strict Mode

**Always enable strict mode in tsconfig.json:**

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noUncheckedIndexedAccess": true
  }
}
```

---

## 2. Type Declarations

**Prefer interfaces for objects, types for unions/primitives:**

```typescript
// Interface for objects (extendable)
interface User {
  id: number;
  email: string;
  name: string;
  createdAt: Date;
}

// Extended interface
interface AdminUser extends User {
  role: 'admin';
  permissions: string[];
}

// Type for unions and primitives
type Status = 'pending' | 'active' | 'suspended';
type ID = string | number;
type Handler = (event: Event) => void;

// Utility types
type PartialUser = Partial<User>;           // All props optional
type RequiredUser = Required<User>;          // All props required
type ReadonlyUser = Readonly<User>;          // All props readonly
type UserKeys = keyof User;                  // 'id' | 'email' | 'name' | 'createdAt'
type UserEmail = Pick<User, 'email'>;        // { email: string }
type UserWithoutId = Omit<User, 'id'>;       // User without id
```

---

## 3. Generics

**Use generics for reusable types:**

```typescript
// Generic function
function first<T>(array: T[]): T | undefined {
  return array[0];
}

// Generic interface
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

// Usage
const userResponse: ApiResponse<User> = await fetchUser();

// Generic constraints
interface HasId {
  id: number;
}

function findById<T extends HasId>(items: T[], id: number): T | undefined {
  return items.find(item => item.id === id);
}

// Multiple generics
function merge<T, U>(obj1: T, obj2: U): T & U {
  return { ...obj1, ...obj2 };
}
```

---

## 4. Enums vs Union Types

**Prefer union types over enums:**

```typescript
// Preferred: Union types
type Status = 'pending' | 'active' | 'completed';
type Direction = 'up' | 'down' | 'left' | 'right';

// Type-safe with autocomplete
const status: Status = 'active'; // ✓
const status: Status = 'unknown'; // Error

// If you need values, use const objects
const HttpStatus = {
  OK: 200,
  NOT_FOUND: 404,
  SERVER_ERROR: 500
} as const;

type HttpStatusCode = typeof HttpStatus[keyof typeof HttpStatus];
// 200 | 404 | 500

// Only use enums when you need reverse mapping
enum LogLevel {
  Debug = 0,
  Info = 1,
  Warn = 2,
  Error = 3
}
console.log(LogLevel[0]); // "Debug" - reverse lookup
```

---

## 5. Null Safety

**Handle null/undefined explicitly:**

```typescript
// Optional properties
interface Config {
  required: string;
  optional?: string;  // string | undefined
}

// Nullish coalescing
const name = user.name ?? 'Anonymous';

// Optional chaining
const city = user?.address?.city;

// Non-null assertion (use sparingly)
const element = document.getElementById('app')!; // You KNOW it exists

// Type guards
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'email' in value
  );
}

if (isUser(data)) {
  console.log(data.email); // TypeScript knows it's User
}

// Discriminated unions
type Result<T> = 
  | { success: true; data: T }
  | { success: false; error: string };

function handleResult<T>(result: Result<T>) {
  if (result.success) {
    console.log(result.data);  // T
  } else {
    console.log(result.error); // string
  }
}
```

---

## 6. Function Typing

**Fully type function signatures:**

```typescript
// Function type
type Comparator<T> = (a: T, b: T) => number;

// Function with optional and default params
function greet(name: string, greeting: string = 'Hello', loud?: boolean): string {
  const message = `${greeting}, ${name}!`;
  return loud ? message.toUpperCase() : message;
}

// Overloaded functions
function parse(input: string): string;
function parse(input: number): number;
function parse(input: string | number): string | number {
  return typeof input === 'string' ? input.trim() : input * 2;
}

// Generic async function
async function fetchData<T>(url: string): Promise<T> {
  const response = await fetch(url);
  return response.json();
}

const user = await fetchData<User>('/api/user');
```

---

## 7. Classes

**Type classes properly:**

```typescript
class UserService {
  private readonly baseUrl: string;
  private cache: Map<number, User> = new Map();

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  async getUser(id: number): Promise<User> {
    const cached = this.cache.get(id);
    if (cached) return cached;

    const response = await fetch(`${this.baseUrl}/users/${id}`);
    const user: User = await response.json();
    this.cache.set(id, user);
    return user;
  }

  // Static factory method
  static create(env: 'dev' | 'prod'): UserService {
    const url = env === 'dev' 
      ? 'http://localhost:3000' 
      : 'https://api.example.com';
    return new UserService(url);
  }
}

// Abstract class
abstract class Repository<T extends { id: number }> {
  abstract findById(id: number): Promise<T | null>;
  abstract save(entity: T): Promise<T>;
  
  async findByIdOrThrow(id: number): Promise<T> {
    const result = await this.findById(id);
    if (!result) throw new Error(`Entity ${id} not found`);
    return result;
  }
}
```

---

## 8. Modules

**Use ES modules properly:**

```typescript
// Named exports (preferred)
export interface User { }
export function validateUser(user: User): boolean { }
export const USER_ROLES = ['admin', 'user'] as const;

// Re-export from index
// models/index.ts
export * from './user';
export * from './product';
export type { Order } from './order'; // Type-only export

// Import
import { User, validateUser } from './models';
import type { User } from './models'; // Type-only import (erased at runtime)

// Default export (use sparingly)
export default class UserService { }
import UserService from './UserService';
```

---

## 9. Error Handling

**Type errors properly:**

```typescript
// Custom error types
class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public code: string
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

// Type guard for errors
function isApiError(error: unknown): error is ApiError {
  return error instanceof ApiError;
}

// Typed try-catch
async function fetchUser(id: number): Promise<User> {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) {
      throw new ApiError(
        `Failed to fetch user ${id}`,
        response.status,
        'USER_FETCH_FAILED'
      );
    }
    return response.json();
  } catch (error) {
    if (isApiError(error)) {
      console.error(`API Error ${error.code}: ${error.message}`);
    }
    throw error;
  }
}

// Result type pattern
type Result<T, E = Error> = 
  | { ok: true; value: T }
  | { ok: false; error: E };

function divide(a: number, b: number): Result<number, string> {
  if (b === 0) return { ok: false, error: 'Division by zero' };
  return { ok: true, value: a / b };
}
```

---

## 10. Declaration Files

**For external modules without types:**

```typescript
// types/my-untyped-lib.d.ts
declare module 'my-untyped-lib' {
  export function doSomething(input: string): number;
  export const VERSION: string;
  export default class MyClass {
    constructor(config: { name: string });
    run(): void;
  }
}

// Augmenting existing types
declare global {
  interface Window {
    myGlobalVar: string;
  }
}

// Ambient declarations for global scripts
declare const gtag: (command: string, ...args: unknown[]) => void;
```

---

## Quick Reference

```typescript
// Common patterns
const arr: readonly number[] = [1, 2, 3];    // Immutable array
const obj = { a: 1 } as const;               // Readonly object type
type Keys = keyof User;                       // Union of keys
type Values = User[keyof User];              // Union of values
type Awaited<T> = T extends Promise<infer U> ? U : T;

// Assertion functions
function assert(condition: unknown, msg?: string): asserts condition {
  if (!condition) throw new Error(msg);
}

// Satisfies operator (TS 4.9+)
const routes = {
  home: '/',
  about: '/about'
} satisfies Record<string, string>;
```
]]>