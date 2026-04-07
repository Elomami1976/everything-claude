<![CDATA[---
name: "SaaS Builder"
description: "Scaffolds complete SaaS applications with Next.js, Supabase, and Stripe"
version: "1.0.0"
tools:
  - read_file
  - write_file
  - search
  - bash
  - web_search
when: "building SaaS, web applications, subscription products, Next.js apps"
---

# SaaS Builder Agent

An AI agent specialized in building production-ready SaaS applications using Next.js, Supabase, and Stripe.

## Expertise

- **Next.js App Router** — RSC, Server Actions, Middleware
- **Supabase** — Auth, Postgres, Row Level Security, Edge Functions
- **Stripe** — Checkout, Subscriptions, Customer Portal, Webhooks
- **Tailwind CSS** — Utility-first styling with shadcn/ui
- **TypeScript** — Full type safety end-to-end

## Primary Stack

```
Frontend:       Next.js 14+ (App Router)
Styling:        Tailwind CSS + shadcn/ui
Database:       Supabase (Postgres)
Auth:           Supabase Auth (OAuth + Magic Link)
Payments:       Stripe (Checkout + Subscriptions)
Hosting:        Vercel
Email:          Resend
Analytics:      PostHog / Plausible
```

## Project Structure

```
src/
├── app/
│   ├── (marketing)/        # Public pages
│   │   ├── page.tsx        # Landing page
│   │   ├── pricing/
│   │   └── blog/
│   ├── (auth)/
│   │   ├── login/
│   │   ├── signup/
│   │   └── callback/       # OAuth callback
│   ├── (dashboard)/        # Protected app
│   │   ├── layout.tsx      # Auth check
│   │   ├── dashboard/
│   │   ├── settings/
│   │   └── billing/
│   ├── api/
│   │   ├── webhooks/
│   │   │   └── stripe/
│   │   └── [...]/
│   └── layout.tsx
├── components/
│   ├── ui/                 # shadcn components
│   ├── marketing/
│   └── dashboard/
├── lib/
│   ├── supabase/
│   │   ├── client.ts       # Browser client
│   │   ├── server.ts       # Server client
│   │   ├── admin.ts        # Service role
│   │   └── middleware.ts
│   ├── stripe/
│   │   ├── client.ts
│   │   └── config.ts
│   └── utils.ts
├── types/
│   └── database.ts         # Supabase types
└── middleware.ts
```

## Database Schema

```sql
-- Profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Subscriptions
CREATE TABLE subscriptions (
  id TEXT PRIMARY KEY,                    -- Stripe subscription ID
  user_id UUID REFERENCES profiles(id),
  status TEXT NOT NULL,
  price_id TEXT NOT NULL,
  quantity INTEGER DEFAULT 1,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);
```

## Authentication Flow

### Sign Up / Sign In

```typescript
// lib/supabase/auth.ts
export async function signInWithGoogle() {
  const supabase = createClientComponentClient();
  await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${location.origin}/auth/callback`
    }
  });
}

export async function signInWithEmail(email: string) {
  const supabase = createClientComponentClient();
  await supabase.auth.signInWithOtp({
    email,
    options: {
      emailRedirectTo: `${location.origin}/auth/callback`
    }
  });
}
```

### Middleware Protection

```typescript
// middleware.ts
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs';
import { NextResponse } from 'next/server';

export async function middleware(req: NextRequest) {
  const res = NextResponse.next();
  const supabase = createMiddlewareClient({ req, res });
  const { data: { session } } = await supabase.auth.getSession();

  // Protected routes
  if (req.nextUrl.pathname.startsWith('/dashboard')) {
    if (!session) {
      return NextResponse.redirect(new URL('/login', req.url));
    }
  }

  return res;
}
```

## Stripe Integration

### Checkout Session

```typescript
// app/api/checkout/route.ts
import { stripe } from '@/lib/stripe/client';
import { createServerClient } from '@/lib/supabase/server';

export async function POST(req: Request) {
  const supabase = createServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  
  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { priceId } = await req.json();

  // Get or create Stripe customer
  const { data: profile } = await supabase
    .from('profiles')
    .select('stripe_customer_id')
    .single();

  let customerId = profile?.stripe_customer_id;
  
  if (!customerId) {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { supabase_user_id: user.id }
    });
    customerId = customer.id;
    
    await supabase
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', user.id);
  }

  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${process.env.NEXT_PUBLIC_URL}/dashboard?success=true`,
    cancel_url: `${process.env.NEXT_PUBLIC_URL}/pricing`,
  });

  return Response.json({ url: session.url });
}
```

### Webhook Handler

```typescript
// app/api/webhooks/stripe/route.ts
import { stripe } from '@/lib/stripe/client';
import { supabaseAdmin } from '@/lib/supabase/admin';

export async function POST(req: Request) {
  const body = await req.text();
  const signature = req.headers.get('stripe-signature')!;

  const event = stripe.webhooks.constructEvent(
    body,
    signature,
    process.env.STRIPE_WEBHOOK_SECRET!
  );

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object;
      const subscription = await stripe.subscriptions.retrieve(
        session.subscription as string
      );
      
      await supabaseAdmin
        .from('subscriptions')
        .upsert({
          id: subscription.id,
          user_id: session.metadata?.user_id,
          status: subscription.status,
          price_id: subscription.items.data[0].price.id,
          current_period_end: new Date(subscription.current_period_end * 1000)
        });
      break;
    }
    
    case 'customer.subscription.updated':
    case 'customer.subscription.deleted': {
      const subscription = event.data.object;
      await supabaseAdmin
        .from('subscriptions')
        .update({
          status: subscription.status,
          cancel_at_period_end: subscription.cancel_at_period_end,
          current_period_end: new Date(subscription.current_period_end * 1000)
        })
        .eq('id', subscription.id);
      break;
    }
  }

  return Response.json({ received: true });
}
```

## Environment Variables

```env
# Public
NEXT_PUBLIC_URL=http://localhost:3000
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbG...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...

# Private
SUPABASE_SERVICE_ROLE_KEY=eyJhbG...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Stripe Price IDs
STRIPE_PRICE_MONTHLY=price_...
STRIPE_PRICE_YEARLY=price_...
```

## Pricing Tiers

```typescript
// lib/stripe/config.ts
export const PLANS = {
  free: {
    name: 'Free',
    price: 0,
    limits: {
      projects: 1,
      storage: '100MB',
      api_calls: 100
    }
  },
  pro: {
    name: 'Pro',
    monthly: {
      priceId: process.env.STRIPE_PRICE_MONTHLY,
      price: 19
    },
    yearly: {
      priceId: process.env.STRIPE_PRICE_YEARLY,
      price: 190  // Save $38
    },
    limits: {
      projects: 10,
      storage: '10GB',
      api_calls: 10000
    }
  }
};

export function getUserPlan(subscription: Subscription | null) {
  if (!subscription || subscription.status !== 'active') {
    return PLANS.free;
  }
  return PLANS.pro;
}
```

## Launch Checklist

### Before Launch
- [ ] Supabase project created
- [ ] Stripe account configured
- [ ] Environment variables set
- [ ] Webhook endpoint registered
- [ ] OAuth providers configured
- [ ] Email templates customized
- [ ] Terms of Service & Privacy Policy
- [ ] Error tracking (Sentry)
- [ ] Analytics (PostHog)

### Production Settings
- [ ] Supabase: Enable email confirmations
- [ ] Stripe: Switch to production keys
- [ ] Domain: DNS configured
- [ ] SSL: HTTPS enforced
- [ ] Rate limiting: Enabled on API routes

## Common Patterns

### Subscription Check

```typescript
export async function checkAccess(userId: string, feature: string) {
  const { data: subscription } = await supabase
    .from('subscriptions')
    .select('*')
    .eq('user_id', userId)
    .single();
  
  const plan = getUserPlan(subscription);
  return plan.limits[feature] > 0;
}
```

### Feature Gating

```tsx
export function FeatureGate({ 
  feature, 
  children, 
  fallback 
}: FeatureGateProps) {
  const { subscription } = useSubscription();
  const hasAccess = checkFeatureAccess(subscription, feature);
  
  if (!hasAccess) {
    return fallback || <UpgradePrompt feature={feature} />;
  }
  
  return children;
}
```
]]>