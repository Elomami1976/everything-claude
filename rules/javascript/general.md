<![CDATA[# JavaScript General Rules

Modern JavaScript best practices for all JS projects.

## 1. Variable Declaration

**Always use `const` by default, `let` when reassignment is needed:**

```javascript
// Good
const MAX_RETRIES = 3;
const user = { name: 'John' }; // Object reference doesn't change

let attempts = 0;
attempts++; // Reassignment needed

// Never use var
var oldStyle = 'avoid this'; // Hoisting issues, function scoped
```

---

## 2. Arrow Functions

**Use arrow functions for callbacks and short functions:**

```javascript
// Good: Concise and lexical `this`
const doubled = numbers.map(n => n * 2);
const users = items.filter(item => item.type === 'user');

// Use block body for complex logic
const processItem = item => {
  const validated = validate(item);
  const transformed = transform(validated);
  return save(transformed);
};

// Use regular functions for:
// - Methods that need `this` bound to object
// - Generator functions
// - When you need `arguments` object
```

---

## 3. Async/Await Over Promises

**Prefer async/await for cleaner async code:**

```javascript
// Good: async/await
async function fetchUserData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error;
  }
}

// Avoid: Promise chains (harder to read)
function fetchUserData(userId) {
  return fetch(`/api/users/${userId}`)
    .then(response => response.json())
    .then(data => data)
    .catch(error => {
      console.error('Failed to fetch user:', error);
      throw error;
    });
}
```

**Parallel operations:**
```javascript
// Good: Run in parallel
const [users, products] = await Promise.all([
  fetchUsers(),
  fetchProducts()
]);

// Bad: Sequential when not needed
const users = await fetchUsers();
const products = await fetchProducts(); // Waits for users unnecessarily
```

---

## 4. Destructuring

**Use destructuring for cleaner code:**

```javascript
// Object destructuring
const { name, email, role = 'user' } = user;

// Array destructuring
const [first, second, ...rest] = items;

// Function parameters
function createUser({ name, email, role = 'user' }) {
  // Direct access without user.name
}

// Nested destructuring (use sparingly)
const { profile: { avatar } } = user;
```

---

## 5. Spread Operator

**Use spread for immutable operations:**

```javascript
// Clone and modify objects
const updatedUser = { ...user, name: 'New Name' };

// Clone arrays
const newItems = [...items, newItem];

// Merge objects
const config = { ...defaults, ...userConfig };

// Function arguments
const max = Math.max(...numbers);
```

---

## 6. Optional Chaining & Nullish Coalescing

**Safely access nested properties:**

```javascript
// Optional chaining
const city = user?.address?.city;
const firstItem = items?.[0];
const result = callback?.();

// Nullish coalescing (only null/undefined, not falsy)
const count = value ?? 0;      // 0 if null/undefined
const name = input ?? 'Guest'; // 'Guest' if null/undefined

// Combine them
const displayName = user?.profile?.name ?? 'Anonymous';

// Note: ?? vs ||
const port = config.port ?? 3000; // Uses default only for null/undefined
const port = config.port || 3000; // Uses default for any falsy (0, '', false)
```

---

## 7. Template Literals

**Use for string interpolation:**

```javascript
// Good
const message = `Hello ${name}, you have ${count} notifications`;
const multiline = `
  <div class="card">
    <h2>${title}</h2>
    <p>${description}</p>
  </div>
`;

// Tagged templates for SQL (with libraries like sql-template-strings)
const query = sql`SELECT * FROM users WHERE id = ${userId}`;
```

---

## 8. Modern Array Methods

**Use functional methods over loops:**

```javascript
// Transform
const names = users.map(user => user.name);

// Filter
const adults = users.filter(user => user.age >= 18);

// Find single item
const admin = users.find(user => user.role === 'admin');

// Check existence
const hasAdmin = users.some(user => user.role === 'admin');
const allVerified = users.every(user => user.verified);

// Reduce (use sparingly, can be hard to read)
const total = orders.reduce((sum, order) => sum + order.amount, 0);

// Chain operations
const activeAdminEmails = users
  .filter(user => user.active && user.role === 'admin')
  .map(user => user.email);
```

---

## 9. Modules

**Use ES modules:**

```javascript
// Named exports
export const API_URL = 'https://api.example.com';
export function fetchUser(id) { }

// Default export (one per file)
export default class UserService { }

// Import
import UserService from './userService.js';
import { API_URL, fetchUser } from './api.js';
import * as utils from './utils.js';
```

---

## 10. Error Handling

**Always handle async errors:**

```javascript
// Async/await
async function fetchData() {
  try {
    const response = await fetch('/api/data');
    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Fetch failed:', error);
    throw error; // Re-throw or handle appropriately
  }
}

// Custom error classes
class ValidationError extends Error {
  constructor(field, message) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}
```

---

## 11. Classes

**Use classes for complex objects:**

```javascript
class User {
  #password; // Private field
  
  constructor(name, email) {
    this.name = name;
    this.email = email;
    this.createdAt = new Date();
  }
  
  // Getter
  get displayName() {
    return this.name || this.email;
  }
  
  // Method
  async save() {
    return await db.users.insert(this);
  }
  
  // Static method
  static async findById(id) {
    return await db.users.findOne({ id });
  }
}
```

---

## 12. Avoid Common Pitfalls

```javascript
// Avoid floating point issues
// Bad
0.1 + 0.2 === 0.3 // false!

// Good: Use integers for money (cents)
const priceInCents = 1999; // $19.99

// Avoid == (use ===)
// Bad
if (value == null) { } // Matches null AND undefined

// Good
if (value === null || value === undefined) { }
if (value == null) { } // This specific case is okay

// Avoid index as key in React (if list can reorder)
// Bad
items.map((item, index) => <Item key={index} />)

// Good
items.map(item => <Item key={item.id} />)
```

---

## Quick Reference

```javascript
// Modern JS features
const { a, b } = obj;           // Destructuring
const arr = [...arr1, ...arr2]; // Spread
const val = a ?? b;             // Nullish coalescing
const x = user?.name;           // Optional chaining
const fn = async () => {};      // Async arrow
const str = `Hello ${name}`;    // Template literal
```
]]>