<![CDATA[# Monetization Planner Skill

Design revenue strategies and pricing models that maximize conversion and lifetime value.

## When to Use

Use this skill when:
- Launching a new product (choose pricing model)
- Converting free users to paid
- Optimizing existing pricing
- Adding payment tiers
- Planning revenue targets
- Reducing churn

---

## How It Works

### Monetization Framework

```
┌────────────────────────────────────────────────────────┐
│               MONETIZATION PLANNING                     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  1. MODEL SELECTION    → How you charge                │
│  2. PRICING STRATEGY   → What you charge               │
│  3. TIER DESIGN        → What each level gets          │
│  4. CONVERSION TRIGGERS→ When users upgrade            │
│  5. RETENTION          → How you keep them             │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

## Step 1: Choose Your Model

### Model Comparison

| Model | Best For | Pros | Cons |
|-------|----------|------|------|
| **Freemium** | Products with viral potential | User acquisition, testing | Hard to convert |
| **Free Trial** | High-value B2B products | Qualified leads | Time pressure |
| **One-Time** | Simple tools, downloads | Simple, no churn | No recurring revenue |
| **Subscription** | Ongoing value delivery | Recurring revenue | Need constant value |
| **Usage-Based** | APIs, infrastructure | Fair pricing | Unpredictable revenue |
| **Lifetime Deal** | Early traction | Quick capital | Caps long-term revenue |

### Decision Matrix

```
Do users need it repeatedly?
├─ YES → Is value proportional to usage?
│        ├─ YES → Usage-based pricing
│        └─ NO → Subscription
│
└─ NO → Is it a tool or content?
         ├─ TOOL → One-time purchase
         └─ CONTENT → One-time or subscription bundle
```

---

## Step 2: Pricing Strategy

### Price Point Psychology

```
$0-$9       → Impulse purchase, credit card swipe
$10-$49     → Consider it, compare to coffee/lunch
$50-$199    → Sleep on it, discuss with partner
$200-$999   → Budget decision, business expense
$1,000+     → Committee decision, sales involvement
```

### Pricing Methods

**1. Value-Based Pricing:**
```
If your tool saves 5 hours/month
And user's time is worth $50/hour
Value created = $250/month
Price at 10-20% of value = $25-50/month
```

**2. Competitor-Based:**
```
Competitor A: $29/month
Competitor B: $49/month
Your price: $39/month (position in middle)
Or: $19/month (disrupt on price)
Or: $99/month (premium positioning)
```

**3. Cost-Plus:**
```
Your costs: $5/user/month
Target margin: 80%
Price: $25/month
```

---

## Step 3: Tier Design

### Classic 3-Tier Structure

```
╔══════════════════════════════════════════════════════════╗
║                    PRICING PLANS                          ║
╠═══════════════════╦═══════════════════╦══════════════════╣
║       FREE        ║        PRO        ║    ENTERPRISE    ║
╠═══════════════════╬═══════════════════╬══════════════════╣
║   Basic features  ║  All features     ║  Everything +    ║
║   Limited usage   ║  Higher limits    ║  Unlimited       ║
║   Community       ║  Email support    ║  Priority support║
║                   ║  API access       ║  SLA + Dedicated ║
╠═══════════════════╬═══════════════════╬══════════════════╣
║       $0          ║    $19/month      ║   Contact us     ║
║                   ║   →Most Popular←  ║                  ║
╚═══════════════════╩═══════════════════╩══════════════════╝
```

### Tier Differentiation Strategies

**1. Feature-Based:**
```javascript
const TIERS = {
  free: {
    features: ['basic_editor', 'export_pdf'],
    limits: { projects: 3 }
  },
  pro: {
    features: ['basic_editor', 'export_pdf', 'export_all', 'templates', 'ai_assist'],
    limits: { projects: 50 }
  },
  enterprise: {
    features: ['*'], // Everything
    limits: { projects: -1 } // Unlimited
  }
};
```

**2. Usage-Based:**
```javascript
const TIERS = {
  starter: { 
    price: 9,
    apiCalls: 1000,
    storage: '1GB'
  },
  growth: {
    price: 49,
    apiCalls: 10000,
    storage: '10GB'
  },
  scale: {
    price: 199,
    apiCalls: 100000,
    storage: '100GB'
  }
};
```

**3. Seat-Based:**
```javascript
const TIERS = {
  solo: { price: 15, seats: 1 },
  team: { price: 49, seats: 5 }, // $9.80/seat
  business: { price: 199, seats: 25 } // $7.96/seat - volume discount
};
```

---

## Step 4: Conversion Triggers

### When to Show Upgrade Prompts

```javascript
const UPGRADE_TRIGGERS = {
  // Usage limits
  hitUsageLimit: {
    message: "You've used 100% of your free quota",
    cta: "Upgrade for 10x more"
  },
  
  // Feature gates
  premiumFeatureClick: {
    message: "AI Assistant is a Pro feature",
    cta: "Start 14-day free trial"
  },
  
  // Time-based
  freeTrialEnding: {
    message: "Your trial ends in 3 days",
    cta: "Subscribe to keep access"
  },
  
  // Value moments
  successMilestone: {
    message: "You've saved 10 hours this month!",
    cta: "Go Pro and save even more"
  },
  
  // Social
  teamGrowth: {
    message: "Invite your team to collaborate",
    cta: "Upgrade to Team plan"
  }
};
```

### Upgrade Flow Best Practices

```
1. SHOW VALUE FIRST
   ├─ Let users experience core value
   └─ Gate expansion, not essentials

2. MAKE IT REVERSIBLE
   ├─ "Try Pro free for 14 days"
   └─ "Cancel anytime"

3. REDUCE FRICTION
   ├─ One-click upgrade
   ├─ Save payment info
   └─ Instant access (no waiting)

4. CLEAR COMPARISON
   ├─ Show what they get
   ├─ Show what they pay
   └─ Highlight best value
```

---

## Step 5: Retention Strategy

### Prevent Churn Before It Happens

```javascript
const RETENTION_TRIGGERS = {
  // Inactivity warning
  noLoginIn14Days: {
    action: 'send_win_back_email',
    message: "We miss you! Here's what's new..."
  },
  
  // Failed payment
  paymentFailed: {
    action: 'email_sequence',
    steps: ['retry_1day', 'retry_3days', 'final_warning', 'downgrade']
  },
  
  // Cancel intent
  cancelButtonClick: {
    action: 'show_save_flow',
    offers: ['pause_subscription', 'downgrade_tier', 'discount_offer']
  },
  
  // Low usage
  lowUsageAlert: {
    action: 'send_tips_email',
    message: "Get more from your subscription..."
  }
};
```

### Cancellation Save Flow

```
User clicks "Cancel" →
├─ Step 1: Ask why
│   - Too expensive
│   - Missing feature
│   - Not using it
│   - Found alternative
│
├─ Step 2: Offer solution
│   - Too expensive → Offer discount or downgrade
│   - Missing feature → Show roadmap or workaround
│   - Not using it → Offer pause instead
│   - Alternative → Offer price match or differentiator
│
├─ Step 3: Make it easy (don't block exit!)
│   - Clear cancel button
│   - No guilt tripping
│   - Thank them
│
└─ Step 4: Post-cancel
    - Win-back email in 30 days
    - Keep data (retention period)
    - Easy reactivation
```

---

## Revenue Projections Template

```
MONTHLY RECURRING REVENUE (MRR) PROJECTION

Month 1:
├─ Free users: 1,000
├─ Free→Paid conversion: 5%
├─ Paid users: 50
├─ ARPU: $25
└─ MRR: $1,250

Month 6:
├─ Free users: 10,000
├─ Free→Paid conversion: 5%
├─ Paid users: 500 (some churned, new converts)
├─ ARPU: $28 (upsells)
├─ Monthly churn: 5%
└─ MRR: $14,000

Month 12:
├─ Free users: 50,000
├─ Paid users: 2,000
├─ ARPU: $32
└─ MRR: $64,000
└─ ARR: $768,000
```

---

## Output

Deliverables:
1. Recommended pricing model
2. tier structure with pricing
3. Feature allocation per tier
4. Upgrade trigger specifications
5. Retention flow designs
6. Revenue projections
]]>