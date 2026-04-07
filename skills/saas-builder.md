# SaaS Builder Skill

Build production-ready SaaS products with authentication, subscriptions, and scalable architecture.

## When to Use

Use this skill when building:
- Subscription or freemium web applications
- API-as-a-service products
- Team or collaboration tools
- B2B software with usage limits
- Marketplace platforms
- Any product with user accounts + payments

---

## Recommended Stack

| Layer | Option A (JS) | Option B (Python) |
|---|---|---|
| **Frontend** | Next.js 14 (App Router) | Next.js or plain HTML |
| **Auth** | Supabase Auth | Supabase Auth |
| **Database** | Supabase (Postgres) | Supabase (Postgres) |
| **Payments** | Stripe | Stripe |
| **Backend** | Next.js API routes | FastAPI |
| **Deployment** | Vercel | Railway or Fly.io |

---

## Step 1: Database Schema

Design three core tables. Run in Supabase SQL editor:

```sql
-- User profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT NOT NULL,
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Active subscriptions
CREATE TABLE subscriptions (
  id TEXT PRIMARY KEY,          -- Stripe subscription ID
  user_id UUID REFERENCES profiles(id),
  status TEXT NOT NULL,         -- active | canceled | past_due
  plan TEXT NOT NULL,           -- price ID or tier name
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT FALSE
);

-- Row-level security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Own profile" ON profiles FOR ALL USING (auth.uid() = id);
CREATE POLICY "Own subscription" ON subscriptions FOR SELECT USING (auth.uid() = user_id);
```

---

## Step 2: Auth + Route Protection

Use middleware to protect dashboard routes and redirect unauthenticated users.

```typescript
// middleware.ts
const PROTECTED = ['/dashboard', '/settings', '/billing'];
const AUTH_ONLY = ['/login', '/signup'];

export async function middleware(req: NextRequest) {
  const { data: { session } } = await supabase.auth.getSession();

  if (session && AUTH_ONLY.some(r => req.nextUrl.pathname.startsWith(r)))
    return NextResponse.redirect(new URL('/dashboard', req.url));

  if (!session && PROTECTED.some(r => req.nextUrl.pathname.startsWith(r)))
    return NextResponse.redirect(new URL('/login', req.url));
}
```

---

## Step 3: Stripe Checkout

Create a checkout session server-side. Never expose the secret key to the browser.

```typescript
// POST /api/checkout
const session = await stripe.checkout.sessions.create({
  customer: customerId,
  mode: 'subscription',
  line_items: [{ price: priceId, quantity: 1 }],
  success_url: `${process.env.NEXT_PUBLIC_URL}/dashboard?success=true`,
  cancel_url: `${process.env.NEXT_PUBLIC_URL}/pricing`,
  metadata: { user_id: userId },
});
return Response.json({ url: session.url });
```

---

## Step 4: Stripe Webhooks

Handle subscription lifecycle events to keep your database in sync with Stripe.

Events to handle:

| Event | Action |
|---|---|
| `checkout.session.completed` | Insert subscription record |
| `customer.subscription.updated` | Update status, period end |
| `customer.subscription.deleted` | Set status to `canceled` |
| `invoice.payment_failed` | Email user, show dunning UI |

Always verify the webhook signature before processing:

```typescript
const event = stripe.webhooks.constructEvent(body, signature, process.env.STRIPE_WEBHOOK_SECRET!);
```

---

## Step 5: Freemium Enforcement

Check subscription status before serving premium features:

```typescript
async function requiresPro(userId: string) {
  const { data } = await supabase
    .from('subscriptions')
    .select('status')
    .eq('user_id', userId)
    .eq('status', 'active')
    .single();
  return !!data;
}
```

Show a clear upgrade prompt when a free user tries to access a Pro feature.

---

## Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_PRICE_MONTHLY=
STRIPE_PRICE_YEARLY=

NEXT_PUBLIC_URL=http://localhost:3000
```

---

## Output Deliverables

1. Database schema (profiles + subscriptions + RLS policies)
2. Auth middleware for route protection
3. Stripe checkout endpoint
4. Webhook handler for subscription events
5. `requiresPro()` gate utility
6. Environment variable template
7. Landing page with pricing section
