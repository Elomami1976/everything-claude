# SaaS Starter Template

Full-stack SaaS application with Next.js, Supabase, and Stripe — production-ready.

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 14+ (App Router) |
| Styling | Tailwind CSS + shadcn/ui |
| Database | Supabase (Postgres) |
| Auth | Supabase Auth |
| Payments | Stripe Checkout + Subscriptions |
| Deployment | Vercel |

## Quick Start

```bash
# Clone and install
npx create-next-app@latest my-saas --typescript --tailwind --app
cd my-saas
npm install @supabase/supabase-js @supabase/auth-helpers-nextjs stripe

# Copy src/ structure from this template
# Set environment variables
cp .env.example .env.local
```

## Environment Variables

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbG...
SUPABASE_SERVICE_ROLE_KEY=eyJhbG...

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_MONTHLY=price_...
STRIPE_PRICE_YEARLY=price_...

# App
NEXT_PUBLIC_URL=http://localhost:3000
```

## Project Structure

```
src/
├── app/
│   ├── (marketing)/          # Public pages
│   │   ├── page.tsx          # Landing page
│   │   └── pricing/
│   │       └── page.tsx
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── callback/
│   │       └── route.ts
│   ├── (dashboard)/          # Protected app
│   │   ├── layout.tsx        # Auth guard
│   │   └── dashboard/
│   │       └── page.tsx
│   └── api/
│       ├── checkout/
│       │   └── route.ts
│       ├── billing/portal/
│       │   └── route.ts
│       └── webhooks/stripe/
│           └── route.ts
├── components/
│   ├── ui/                   # shadcn components
│   └── app/                  # App-specific components
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── admin.ts
│   └── stripe.ts
└── middleware.ts
```

## Database Schema

Run in your Supabase SQL editor:

```sql
-- Profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Subscriptions table
CREATE TABLE subscriptions (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  status TEXT NOT NULL,
  price_id TEXT NOT NULL,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can read own subscription"
  ON subscriptions FOR SELECT USING (auth.uid() = user_id);
```

## Key Files to Copy

Copy these from `src/` to your project:

| File | Purpose |
|---|---|
| `lib/supabase/client.ts` | Browser Supabase client |
| `lib/supabase/server.ts` | Server-side client |
| `lib/stripe.ts` | Stripe instance |
| `middleware.ts` | Auth route protection |
| `app/api/checkout/route.ts` | Create Stripe session |
| `app/api/webhooks/stripe/route.ts` | Handle Stripe events |

## See Also

- [saas-builder skill](../../skills/saas-builder.md)
- [saas-agent](../../agents/saas-agent.md)
- [SaaS rules](../../rules/javascript/saas.md)
