# API Connector Skill

Integrate third-party APIs with consistent error handling, retries, and type safety.

## When to Use

Use this skill when:
- Adding payment processing (Stripe, Paddle)
- Integrating authentication providers (Auth0, Supabase)
- Connecting to AI APIs (OpenAI, Anthropic, Google)
- Adding email services (Resend, SendGrid)
- Connecting to analytics (Mixpanel, PostHog)
- Integrating social or data APIs (Twitter, GitHub, etc.)

---

## Architecture

Every integration follows the same 3-layer pattern:

| Layer | Purpose | Example |
|---|---|---|
| **Wrapper class** | Consistent interface, auth injection | `OpenAIClient`, `StripeService` |
| **HTTP client** | Retries, timeouts, error normalizing | `ApiClient.request()` |
| **Caller** | Business logic, no HTTP details | `createSubscription()` |

---

## Implementation Steps

### Step 1: Create a base HTTP client

Build a reusable client that handles auth, timeouts, retries, and normalizes errors.

Key responsibilities:
- Inject `Authorization` header from config (never hardcode)
- Set a timeout (30s default) with `AbortController`
- Retry on 5xx errors with exponential backoff
- Throw typed `ApiError` with `status` + `code` for callers to handle

```typescript
class ApiError extends Error {
  constructor(message: string, public status: number, public code?: string) {
    super(message);
    this.name = 'ApiError';
  }
}
```

### Step 2: Build service-specific wrappers

Wrap each third-party API in a dedicated class. Keep HTTP logic in the base client — the wrapper only knows about the API's domain concepts.

**OpenAI:**
```typescript
class OpenAI {
  async chat(messages: ChatMessage[], model = 'gpt-4o-mini'): Promise<string> {
    const res = await this.client.post<ChatCompletion>('/chat/completions', { model, messages });
    return res.choices[0].message.content;
  }
}
```

**Stripe:**
```typescript
const StripeService = {
  createCheckout: (customerId: string, priceId: string, urls: { success: string; cancel: string }) =>
    stripe.checkout.sessions.create({ customer: customerId, mode: 'subscription', line_items: [{ price: priceId, quantity: 1 }], ...urls }),
};
```

### Step 3: Add rate limiting

Use a token-bucket limiter before each external call. This prevents hitting provider rate limits and avoids 429 errors.

```typescript
const openaiLimiter = new RateLimiter(60, 1); // 60 req/min
async function callAI(prompt: string) {
  await openaiLimiter.acquire();
  return openai.complete(prompt);
}
```

### Step 4: Handle errors at the call site

Never let raw HTTP errors reach business logic. Map status codes to meaningful actions:

| Status | Meaning | Action |
|---|---|---|
| 401 | Invalid API key | Surface error to user to reconfigure |
| 429 | Rate limited | Wait and retry with backoff |
| 500+ | Provider down | Return cached result or graceful fallback |

---

## Security Rules

- Store all API keys in environment variables — never in source code
- Use server-side API calls for keys that must stay secret
- Validate all API responses before using the data
- Never log full request/response bodies that may contain PII

---

## Output Deliverables

1. Base `ApiClient` class with retry + timeout logic
2. Service wrappers for each required third-party API
3. `ApiError` class with typed status codes
4. Rate limiter utility
5. Error handling guide per status code
6. Environment variable list with descriptions
