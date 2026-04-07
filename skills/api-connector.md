<![CDATA[# API Connector Skill

Integrate third-party APIs into your applications with proper error handling and authentication.

## When to Use

Use this skill when:
- Adding payment processing (Stripe, Paddle)
- Integrating authentication providers (Auth0, Supabase)
- Connecting to analytics services (Mixpanel, PostHog)
- Using AI APIs (OpenAI, Anthropic)
- Adding email services (Resend, SendGrid)
- Integrating social APIs (Twitter, GitHub)

---

## How It Works

### API Integration Pattern

```
Application Code
       │
       ▼
┌──────────────────┐
│   API Wrapper    │ ← Consistent interface
│   - Auth         │
│   - Retry logic  │
│   - Rate limits  │
│   - Error types  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   HTTP Client    │ ← fetch / axios
└────────┬─────────┘
         │
         ▼
   External API
```

---

## Implementation Steps

### Step 1: API Client Base Class

```typescript
// lib/api-client.ts

interface ApiClientConfig {
  baseUrl: string;
  apiKey?: string;
  timeout?: number;
  retries?: number;
}

interface RequestOptions {
  method?: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';
  body?: unknown;
  headers?: Record<string, string>;
}

class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
    public code?: string,
    public details?: unknown
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

class ApiClient {
  private baseUrl: string;
  private apiKey?: string;
  private timeout: number;
  private retries: number;

  constructor(config: ApiClientConfig) {
    this.baseUrl = config.baseUrl;
    this.apiKey = config.apiKey;
    this.timeout = config.timeout ?? 30000;
    this.retries = config.retries ?? 3;
  }

  private async request<T>(path: string, options: RequestOptions = {}): Promise<T> {
    const url = `${this.baseUrl}${path}`;
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...options.headers,
    };

    if (this.apiKey) {
      headers['Authorization'] = `Bearer ${this.apiKey}`;
    }

    let lastError: Error | null = null;

    for (let attempt = 0; attempt < this.retries; attempt++) {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), this.timeout);

        const response = await fetch(url, {
          method: options.method ?? 'GET',
          headers,
          body: options.body ? JSON.stringify(options.body) : undefined,
          signal: controller.signal,
        });

        clearTimeout(timeoutId);

        if (!response.ok) {
          const error = await response.json().catch(() => ({}));
          throw new ApiError(
            error.message || `HTTP ${response.status}`,
            response.status,
            error.code,
            error
          );
        }

        return await response.json();
      } catch (error) {
        lastError = error as Error;
        
        // Don't retry on client errors (4xx)
        if (error instanceof ApiError && error.status < 500) {
          throw error;
        }

        // Exponential backoff for retries
        if (attempt < this.retries - 1) {
          await new Promise(r => setTimeout(r, Math.pow(2, attempt) * 1000));
        }
      }
    }

    throw lastError;
  }

  get<T>(path: string, options?: Omit<RequestOptions, 'method'>): Promise<T> {
    return this.request<T>(path, { ...options, method: 'GET' });
  }

  post<T>(path: string, body: unknown, options?: Omit<RequestOptions, 'method' | 'body'>): Promise<T> {
    return this.request<T>(path, { ...options, method: 'POST', body });
  }

  put<T>(path: string, body: unknown, options?: Omit<RequestOptions, 'method' | 'body'>): Promise<T> {
    return this.request<T>(path, { ...options, method: 'PUT', body });
  }

  delete<T>(path: string, options?: Omit<RequestOptions, 'method'>): Promise<T> {
    return this.request<T>(path, { ...options, method: 'DELETE' });
  }
}

export { ApiClient, ApiError };
```

### Step 2: OpenAI Integration

```typescript
// lib/openai.ts
import { ApiClient } from './api-client';

interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

interface ChatCompletionResponse {
  id: string;
  choices: {
    index: number;
    message: ChatMessage;
    finish_reason: string;
  }[];
  usage: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

class OpenAI {
  private client: ApiClient;

  constructor(apiKey: string) {
    this.client = new ApiClient({
      baseUrl: 'https://api.openai.com/v1',
      apiKey,
      timeout: 60000, // AI calls can be slow
    });
  }

  async chat(
    messages: ChatMessage[],
    options: {
      model?: string;
      temperature?: number;
      maxTokens?: number;
    } = {}
  ): Promise<string> {
    const response = await this.client.post<ChatCompletionResponse>('/chat/completions', {
      model: options.model ?? 'gpt-4o-mini',
      messages,
      temperature: options.temperature ?? 0.7,
      max_tokens: options.maxTokens ?? 2000,
    });

    return response.choices[0].message.content;
  }

  async complete(prompt: string, options = {}): Promise<string> {
    return this.chat([{ role: 'user', content: prompt }], options);
  }
}

export const openai = new OpenAI(process.env.OPENAI_API_KEY!);
```

### Step 3: Stripe Integration

```typescript
// lib/stripe.ts
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
});

export const StripeService = {
  // Create a customer
  async createCustomer(email: string, metadata?: Record<string, string>) {
    return stripe.customers.create({
      email,
      metadata,
    });
  },

  // Create checkout session
  async createCheckoutSession(params: {
    customerId: string;
    priceId: string;
    successUrl: string;
    cancelUrl: string;
    metadata?: Record<string, string>;
  }) {
    return stripe.checkout.sessions.create({
      customer: params.customerId,
      mode: 'subscription',
      payment_method_types: ['card'],
      line_items: [{ price: params.priceId, quantity: 1 }],
      success_url: params.successUrl,
      cancel_url: params.cancelUrl,
      metadata: params.metadata,
    });
  },

  // Create billing portal session
  async createPortalSession(customerId: string, returnUrl: string) {
    return stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: returnUrl,
    });
  },

  // Get subscription
  async getSubscription(subscriptionId: string) {
    return stripe.subscriptions.retrieve(subscriptionId);
  },

  // Cancel subscription
  async cancelSubscription(subscriptionId: string, immediately = false) {
    if (immediately) {
      return stripe.subscriptions.cancel(subscriptionId);
    }
    return stripe.subscriptions.update(subscriptionId, {
      cancel_at_period_end: true,
    });
  },

  // Verify webhook signature
  constructWebhookEvent(body: string, signature: string) {
    return stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  },
};

export { stripe };
```

### Step 4: Resend Email Integration

```typescript
// lib/email.ts
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

export const EmailService = {
  async sendWelcome(to: string, name: string) {
    return resend.emails.send({
      from: 'Your App <hello@yourapp.com>',
      to,
      subject: 'Welcome to Your App!',
      html: `
        <h1>Welcome, ${name}!</h1>
        <p>Thanks for signing up. Here's what you can do next:</p>
        <ul>
          <li>Complete your profile</li>
          <li>Create your first project</li>
          <li>Invite team members</li>
        </ul>
        <a href="https://yourapp.com/dashboard">Go to Dashboard</a>
      `,
    });
  },

  async sendPasswordReset(to: string, resetUrl: string) {
    return resend.emails.send({
      from: 'Your App <security@yourapp.com>',
      to,
      subject: 'Reset Your Password',
      html: `
        <p>Click the link below to reset your password:</p>
        <a href="${resetUrl}">Reset Password</a>
        <p>This link expires in 1 hour.</p>
        <p>If you didn't request this, ignore this email.</p>
      `,
    });
  },

  async sendInvoice(to: string, invoiceUrl: string, amount: string) {
    return resend.emails.send({
      from: 'Your App <billing@yourapp.com>',
      to,
      subject: 'Your Invoice is Ready',
      html: `
        <p>Your invoice for ${amount} is ready.</p>
        <a href="${invoiceUrl}">View Invoice</a>
      `,
    });
  },
};
```

### Step 5: Rate Limiting

```typescript
// lib/rate-limit.ts

class RateLimiter {
  private tokens: number;
  private maxTokens: number;
  private refillRate: number; // tokens per second
  private lastRefill: number;

  constructor(maxTokens: number, refillRate: number) {
    this.maxTokens = maxTokens;
    this.tokens = maxTokens;
    this.refillRate = refillRate;
    this.lastRefill = Date.now();
  }

  private refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(this.maxTokens, this.tokens + elapsed * this.refillRate);
    this.lastRefill = now;
  }

  async acquire(tokens = 1): Promise<void> {
    this.refill();

    if (this.tokens >= tokens) {
      this.tokens -= tokens;
      return;
    }

    // Wait until we have enough tokens
    const waitTime = ((tokens - this.tokens) / this.refillRate) * 1000;
    await new Promise(resolve => setTimeout(resolve, waitTime));
    this.tokens = 0;
  }
}

// Usage
const openaiLimiter = new RateLimiter(60, 1); // 60 requests per minute

async function callOpenAI(prompt: string) {
  await openaiLimiter.acquire();
  return openai.complete(prompt);
}
```

---

## Error Handling Best Practices

```typescript
try {
  const result = await openai.chat(messages);
  return result;
} catch (error) {
  if (error instanceof ApiError) {
    switch (error.status) {
      case 401:
        throw new Error('Invalid API key');
      case 429:
        // Rate limited - retry after delay
        await sleep(60000);
        return callOpenAI(messages);
      case 500:
        throw new Error('Service temporarily unavailable');
      default:
        throw error;
    }
  }
  throw error;
}
```

---

## Output

Deliverables:
1. API client wrapper classes
2. Service-specific integrations
3. Type definitions
4. Error handling utilities
5. Rate limiting implementation
6. Usage examples
]]>