<![CDATA[# SaaS Builder Skill

Build production-ready SaaS products with authentication, payments, and scalable architecture.

## When to Use

Use this skill when building:
- Subscription-based web applications
- Freemium products with usage limits
- API-as-a-service products
- Team/collaboration tools
- B2B software
- Marketplace platforms

---

## How It Works

### Tech Stack Options

**Option A: Full-Stack JavaScript**
```
Next.js + Supabase + Stripe
- Frontend: Next.js with App Router
- Auth: Supabase Auth
- Database: Supabase (PostgreSQL)
- Payments: Stripe
- Deployment: Vercel
```

**Option B: Simple HTML + Backend**
```
HTML/CSS/JS + FastAPI + Stripe
- Frontend: Single HTML file or simple pages
- Backend: FastAPI (Python)
- Database: PostgreSQL or SQLite
- Payments: Stripe
- Deployment: Railway, Render, or Fly.io
```

### System Architecture

```
┌──────────────────────────────────────────────────────────┐
│                        Frontend                           │
│  Landing Page | Dashboard | Settings | Billing           │
└────────────────────────┬─────────────────────────────────┘
                         │ API Calls
                         ▼
┌──────────────────────────────────────────────────────────┐
│                      Backend API                          │
│  Auth | CRUD | Usage Tracking | Webhook Handlers         │
└────────────────────────┬─────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
    ┌─────────┐    ┌──────────┐    ┌─────────┐
    │Supabase │    │  Stripe  │    │  Redis  │
    │   DB    │    │ Payments │    │  Cache  │
    └─────────┘    └──────────┘    └─────────┘
```

---

## Implementation Steps

### Step 1: Supabase Schema

```sql
-- Enable RLS
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Users profile (extends Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  plan TEXT DEFAULT 'free' CHECK (plan IN ('free', 'pro', 'enterprise')),
  stripe_customer_id TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Automatically create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Subscriptions
CREATE TABLE subscriptions (
  id TEXT PRIMARY KEY, -- Stripe subscription ID
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL,
  plan TEXT NOT NULL,
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Usage tracking
CREATE TABLE usage (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  metric TEXT NOT NULL,
  count INTEGER DEFAULT 0,
  period DATE DEFAULT CURRENT_DATE,
  UNIQUE(user_id, metric, period)
);

-- Increment usage function
CREATE OR REPLACE FUNCTION increment_usage(
  p_user_id UUID,
  p_metric TEXT,
  p_amount INTEGER DEFAULT 1
) RETURNS INTEGER AS $$
DECLARE
  new_count INTEGER;
BEGIN
  INSERT INTO usage (user_id, metric, count, period)
  VALUES (p_user_id, p_metric, p_amount, CURRENT_DATE)
  ON CONFLICT (user_id, metric, period)
  DO UPDATE SET count = usage.count + p_amount
  RETURNING count INTO new_count;
  
  RETURN new_count;
END;
$$ LANGUAGE plpgsql;

-- RLS Policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view own usage"
  ON usage FOR SELECT USING (auth.uid() = user_id);
```

### Step 2: Authentication

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

// hooks/useAuth.ts
import { useEffect, useState } from 'react';
import { User } from '@supabase/supabase-js';
import { supabase } from '@/lib/supabase';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    // Listen for changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setUser(session?.user ?? null);
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });
    if (error) throw error;
    return data;
  };

  const signUp = async (email: string, password: string, name: string) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { full_name: name }
      }
    });
    if (error) throw error;
    return data;
  };

  const signOut = () => supabase.auth.signOut();

  return { user, loading, signIn, signUp, signOut };
}
```

### Step 3: Stripe Integration

```typescript
// app/api/checkout/route.ts
import { NextRequest, NextResponse } from 'next/server';
import Stripe from 'stripe';
import { createClient } from '@supabase/supabase-js';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export async function POST(req: NextRequest) {
  const { priceId, userId, email } = await req.json();

  // Get or create Stripe customer
  const { data: profile } = await supabaseAdmin
    .from('profiles')
    .select('stripe_customer_id')
    .eq('id', userId)
    .single();

  let customerId = profile?.stripe_customer_id;

  if (!customerId) {
    const customer = await stripe.customers.create({ email });
    customerId = customer.id;
    
    await supabaseAdmin
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', userId);
  }

  // Create checkout session
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard?success=true`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/pricing`,
    metadata: { userId }
  });

  return NextResponse.json({ url: session.url });
}

// app/api/webhooks/stripe/route.ts
export async function POST(req: NextRequest) {
  const body = await req.text();
  const sig = req.headers.get('stripe-signature')!;

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(
      body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch (err) {
    return new NextResponse('Webhook Error', { status: 400 });
  }

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session;
      const subscription = await stripe.subscriptions.retrieve(
        session.subscription as string
      );
      
      await supabaseAdmin.from('subscriptions').upsert({
        id: subscription.id,
        user_id: session.metadata!.userId,
        status: subscription.status,
        plan: 'pro',
        current_period_start: new Date(subscription.current_period_start * 1000),
        current_period_end: new Date(subscription.current_period_end * 1000)
      });
      
      await supabaseAdmin
        .from('profiles')
        .update({ plan: 'pro' })
        .eq('id', session.metadata!.userId);
      
      break;
    }

    case 'customer.subscription.updated': {
      const subscription = event.data.object as Stripe.Subscription;
      
      await supabaseAdmin.from('subscriptions').upsert({
        id: subscription.id,
        status: subscription.status,
        current_period_end: new Date(subscription.current_period_end * 1000),
        cancel_at: subscription.cancel_at 
          ? new Date(subscription.cancel_at * 1000) 
          : null
      });
      
      break;
    }

    case 'customer.subscription.deleted': {
      const subscription = event.data.object as Stripe.Subscription;
      
      await supabaseAdmin
        .from('subscriptions')
        .update({ status: 'canceled' })
        .eq('id', subscription.id);
      
      // Downgrade user
      const { data } = await supabaseAdmin
        .from('subscriptions')
        .select('user_id')
        .eq('id', subscription.id)
        .single();
      
      if (data) {
        await supabaseAdmin
          .from('profiles')
          .update({ plan: 'free' })
          .eq('id', data.user_id);
      }
      
      break;
    }
  }

  return NextResponse.json({ received: true });
}
```

### Step 4: Usage Limits

```typescript
// lib/usage.ts
const LIMITS = {
  free: {
    apiCalls: 100,
    projects: 3,
    storage: 100 * 1024 * 1024 // 100MB
  },
  pro: {
    apiCalls: 10000,
    projects: 50,
    storage: 10 * 1024 * 1024 * 1024 // 10GB
  },
  enterprise: {
    apiCalls: -1, // Unlimited
    projects: -1,
    storage: -1
  }
};

export async function checkUsage(userId: string, metric: keyof typeof LIMITS.free) {
  // Get user plan
  const { data: profile } = await supabase
    .from('profiles')
    .select('plan')
    .eq('id', userId)
    .single();

  const plan = profile?.plan || 'free';
  const limit = LIMITS[plan as keyof typeof LIMITS][metric];

  // Unlimited
  if (limit === -1) return { allowed: true, remaining: -1 };

  // Get current usage
  const today = new Date().toISOString().split('T')[0];
  const { data: usage } = await supabase
    .from('usage')
    .select('count')
    .eq('user_id', userId)
    .eq('metric', metric)
    .eq('period', today)
    .single();

  const used = usage?.count || 0;
  const remaining = limit - used;

  return {
    allowed: remaining > 0,
    used,
    limit,
    remaining,
    plan
  };
}

export async function incrementUsage(userId: string, metric: string) {
  const { data, error } = await supabase.rpc('increment_usage', {
    p_user_id: userId,
    p_metric: metric,
    p_amount: 1
  });
  
  return data;
}
```

### Step 5: Landing Page

Key sections:
1. Hero with clear value proposition
2. Social proof (logos, testimonials)
3. Feature grid
4. Pricing table
5. FAQ
6. Final CTA

```tsx
// app/page.tsx
export default function LandingPage() {
  return (
    <>
      <header className="fixed w-full bg-white/80 backdrop-blur z-50">
        <nav className="container mx-auto px-6 py-4 flex justify-between">
          <Logo />
          <div className="flex gap-4 items-center">
            <Link href="/pricing">Pricing</Link>
            <Link href="/login">Login</Link>
            <Link href="/signup" className="btn-primary">
              Start Free
            </Link>
          </div>
        </nav>
      </header>

      <main>
        {/* Hero */}
        <section className="pt-32 pb-20 bg-gradient-to-b from-blue-50">
          <div className="container mx-auto px-6 text-center">
            <h1 className="text-5xl font-bold mb-6">
              Primary Benefit Statement
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
              How you solve their problem in one sentence
            </p>
            <div className="flex gap-4 justify-center">
              <Link href="/signup" className="btn-primary text-lg px-8 py-4">
                Start Free Trial
              </Link>
              <Link href="#demo" className="btn-secondary text-lg px-8 py-4">
                Watch Demo
              </Link>
            </div>
            <p className="mt-4 text-sm text-gray-500">
              No credit card required • 14-day free trial
            </p>
          </div>
        </section>

        {/* Social proof, Features, Pricing, FAQ, CTA */}
      </main>
    </>
  );
}
```

---

## Deployment Checklist

- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Stripe webhooks configured
- [ ] Email templates set up
- [ ] Error tracking enabled (Sentry)
- [ ] Analytics added
- [ ] SSL certificate active
- [ ] Backup strategy in place

---

## Output

Deliverables:
1. Full project directory structure
2. Supabase schema SQL
3. Stripe product/price creation commands
4. Environment variables template
5. Deployment configuration
6. README with setup instructions
]]>