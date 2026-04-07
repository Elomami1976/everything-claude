<![CDATA[# SaaS JavaScript Rules

Best practices for building SaaS products with JavaScript/TypeScript.

## 1. Stripe Integration

**Never handle raw card numbers:**

```javascript
// Frontend: Use Stripe Elements
import { loadStripe } from '@stripe/stripe-js';

const stripe = await loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY);

// Create payment element
const elements = stripe.elements({
  clientSecret // From your server
});
const paymentElement = elements.create('payment');
paymentElement.mount('#payment-element');

// Submit payment
const { error } = await stripe.confirmPayment({
  elements,
  confirmParams: {
    return_url: `${window.location.origin}/payment/success`
  }
});
```

**Server-side setup:**
```javascript
import Stripe from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// Create checkout session
app.post('/api/create-checkout', async (req, res) => {
  const { priceId, userId } = req.body;
  
  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${process.env.APP_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.APP_URL}/pricing`,
    client_reference_id: userId,
    metadata: { userId }
  });
  
  res.json({ url: session.url });
});
```

**Webhook handling (CRITICAL):**
```javascript
// This is how you fulfill orders!
app.post('/api/webhooks/stripe', express.raw({ type: 'application/json' }), async (req, res) => {
  const sig = req.headers['stripe-signature'];
  
  let event;
  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
  
  switch (event.type) {
    case 'checkout.session.completed':
      const session = event.data.object;
      await activateSubscription(session.client_reference_id);
      break;
      
    case 'customer.subscription.updated':
      const subscription = event.data.object;
      await updateSubscriptionStatus(subscription);
      break;
      
    case 'customer.subscription.deleted':
      await cancelSubscription(event.data.object);
      break;
      
    case 'invoice.payment_failed':
      await handleFailedPayment(event.data.object);
      break;
  }
  
  res.json({ received: true });
});
```

---

## 2. Supabase Auth Patterns

**Client-side auth:**
```javascript
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

// Sign up
async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${window.location.origin}/auth/callback`
    }
  });
  return { data, error };
}

// Sign in
async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  });
  return { data, error };
}

// OAuth
async function signInWithGoogle() {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${window.location.origin}/auth/callback`
    }
  });
  return { data, error };
}

// Listen to auth changes
supabase.auth.onAuthStateChange((event, session) => {
  if (event === 'SIGNED_IN') {
    // User signed in
  } else if (event === 'SIGNED_OUT') {
    // User signed out
  }
});
```

**Server-side auth (API routes):**
```javascript
import { createServerClient } from '@supabase/ssr';

export async function getUser(req, res) {
  const supabase = createServerClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    { cookies: req.cookies }
  );
  
  const { data: { user }, error } = await supabase.auth.getUser();
  return user;
}

// Protected route middleware
export async function requireAuth(req, res, next) {
  const user = await getUser(req, res);
  
  if (!user) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  
  req.user = user;
  next();
}
```

---

## 3. Freemium Architecture

**Tier configuration:**
```javascript
const PLANS = {
  free: {
    name: 'Free',
    price: 0,
    limits: {
      projects: 3,
      apiCalls: 100,
      storage: 100 * 1024 * 1024, // 100MB
      features: ['basic_analytics']
    }
  },
  pro: {
    name: 'Pro',
    price: 19,
    stripePriceId: 'price_xxx',
    limits: {
      projects: 50,
      apiCalls: 10000,
      storage: 10 * 1024 * 1024 * 1024, // 10GB
      features: ['basic_analytics', 'advanced_analytics', 'api_access']
    }
  },
  enterprise: {
    name: 'Enterprise',
    price: 99,
    stripePriceId: 'price_yyy',
    limits: {
      projects: -1, // Unlimited
      apiCalls: -1,
      storage: 100 * 1024 * 1024 * 1024, // 100GB
      features: ['basic_analytics', 'advanced_analytics', 'api_access', 'sso', 'priority_support']
    }
  }
};
```

**Usage checking middleware:**
```javascript
async function checkUsage(req, res, next) {
  const { user } = req;
  const usage = await getUserUsage(user.id);
  const limits = PLANS[user.plan].limits;
  
  if (limits.apiCalls !== -1 && usage.apiCalls >= limits.apiCalls) {
    return res.status(429).json({
      error: 'Usage limit exceeded',
      upgrade: true,
      currentPlan: user.plan,
      limit: limits.apiCalls,
      used: usage.apiCalls
    });
  }
  
  // Increment usage
  await incrementUsage(user.id, 'apiCalls');
  next();
}
```

**Feature gating:**
```javascript
function hasFeature(user, feature) {
  const plan = PLANS[user.plan];
  return plan.limits.features.includes(feature);
}

// Usage
if (!hasFeature(user, 'api_access')) {
  return res.status(403).json({ error: 'Upgrade to Pro for API access' });
}
```

---

## 4. Landing Page Patterns

**Critical elements for conversion:**

```html
<!-- Above the fold -->
<section class="hero">
  <h1>Primary Benefit Statement</h1>
  <p class="subtitle">How you solve their problem in one sentence</p>
  <div class="cta-group">
    <a href="/signup" class="cta-primary">Start Free Trial</a>
    <a href="#demo" class="cta-secondary">Watch Demo</a>
  </div>
  <p class="trust">No credit card required • 14-day free trial</p>
</section>

<!-- Social proof -->
<section class="social-proof">
  <p>Trusted by 10,000+ developers</p>
  <div class="logos"><!-- Customer logos --></div>
</section>

<!-- Feature grid -->
<section class="features">
  <div class="feature">
    <span class="icon">⚡</span>
    <h3>Speed</h3>
    <p>10x faster than alternatives</p>
  </div>
  <!-- More features -->
</section>

<!-- Testimonials -->
<section class="testimonials">
  <blockquote>
    <p>"Saved us 20 hours per week"</p>
    <cite>— Jane Doe, CEO at TechCo</cite>
  </blockquote>
</section>

<!-- Pricing -->
<section class="pricing" id="pricing">
  <!-- Clear pricing table -->
</section>

<!-- Final CTA -->
<section class="final-cta">
  <h2>Ready to start?</h2>
  <a href="/signup" class="cta-primary">Get Started Free</a>
</section>
```

**JavaScript for conversion:**
```javascript
// Track CTA clicks
document.querySelectorAll('.cta-primary').forEach(btn => {
  btn.addEventListener('click', () => {
    analytics.track('CTA Clicked', {
      location: btn.closest('section').className,
      text: btn.textContent
    });
  });
});

// Scroll-based pricing highlight
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, { threshold: 0.5 });

document.querySelectorAll('.pricing-card').forEach(card => {
  observer.observe(card);
});
```

---

## 5. API Rate Limiting

```javascript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

// Tiered rate limiting
const createRateLimiter = (tier) => {
  const limits = {
    free: { windowMs: 60000, max: 10 },
    pro: { windowMs: 60000, max: 100 },
    enterprise: { windowMs: 60000, max: 1000 }
  };
  
  return rateLimit({
    store: new RedisStore({ client: redis }),
    windowMs: limits[tier].windowMs,
    max: limits[tier].max,
    keyGenerator: (req) => `${req.user.id}:${tier}`,
    handler: (req, res) => {
      res.status(429).json({
        error: 'Rate limit exceeded',
        retryAfter: res.getHeader('Retry-After')
      });
    }
  });
};

// Apply per-user tier
app.use('/api', (req, res, next) => {
  const tier = req.user?.plan || 'free';
  return createRateLimiter(tier)(req, res, next);
});
```

---

## 6. Database Schema Patterns

**Supabase/PostgreSQL:**
```sql
-- Users (synced with Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  plan TEXT DEFAULT 'free',
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Users can only read/update their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Projects with usage tracking
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Usage tracking
CREATE TABLE usage (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  metric TEXT NOT NULL,
  count INTEGER DEFAULT 0,
  period DATE DEFAULT CURRENT_DATE,
  UNIQUE(user_id, metric, period)
);
```

---

## SaaS Checklist

- [ ] Stripe integration with webhook handling
- [ ] Supabase auth with session management
- [ ] Tiered pricing with usage limits
- [ ] Feature gating per plan
- [ ] Rate limiting per tier
- [ ] Landing page with clear CTA
- [ ] Email sequences (welcome, trial ending)
- [ ] Error tracking (Sentry)
- [ ] Analytics (Mixpanel/PostHog)
]]>