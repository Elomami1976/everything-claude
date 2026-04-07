<![CDATA[# /plan Command

Generate a detailed implementation plan for a feature request.

## Usage

```
/plan <feature description>
/plan "Add user authentication with Google OAuth"
/plan Add Stripe subscription with monthly/yearly plans
```

## Output Format

---

```markdown
# Implementation Plan: [Feature Name]

**Requested**: [Brief description]
**Complexity**: [Low | Medium | High | Very High]
**Estimated Time**: [X hours/days]
**Risk Level**: [Low | Medium | High]

---

## 📋 Summary

[2-3 sentence summary of what will be built and how]

---

## 📁 Files to Create

| File | Purpose | Lines (est) |
|------|---------|-------------|
| `path/to/file.ts` | [Purpose] | ~50 |
| `path/to/file.ts` | [Purpose] | ~30 |

---

## ✏️ Files to Modify

| File | Changes | Risk |
|------|---------|------|
| `path/to/file.ts` | [What changes] | Low |
| `path/to/file.ts` | [What changes] | Medium |

---

## 🔧 Implementation Steps

### Phase 1: [Name] ([time estimate])

1. **[Step Title]**
   - What: [Detailed description]
   - Where: `file.ts`
   - Code:
   \`\`\`typescript
   // Example snippet
   \`\`\`

2. **[Step Title]**
   - What: [Detailed description]
   - Depends on: Step 1

### Phase 2: [Name] ([time estimate])

3. **[Step Title]**
   - What: [Detailed description]
   
4. **[Step Title]**
   - What: [Detailed description]

### Phase 3: [Name] ([time estimate])

5. **[Step Title]** (Testing)
6. **[Step Title]** (Documentation)

---

## ⚠️ Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | Medium | High | [How to mitigate] |
| [Risk 2] | Low | Medium | [How to mitigate] |

---

## 🔗 Dependencies

### External Services
- [Service 1]: [Why needed, how to set up]
- [Service 2]: [Why needed, how to set up]

### NPM Packages
\`\`\`bash
npm install package1 package2
\`\`\`

### Environment Variables
\`\`\`env
NEW_VAR_1=value
NEW_VAR_2=value
\`\`\`

---

## 🧪 Testing Plan

| Test Type | Coverage |
|-----------|----------|
| Unit tests | [Functions to test] |
| Integration | [Flows to test] |
| E2E | [User journeys] |

---

## 📚 Documentation Updates

- [ ] README.md - Add [section]
- [ ] API docs - Document [endpoints]
- [ ] .env.example - Add new variables

---

## ✅ Acceptance Criteria

- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]
- [ ] [Criteria 4]

---

## 🚀 Rollout Plan

1. **Development**: [X days]
2. **Code Review**: [X days]
3. **Staging**: [X days]
4. **Production**: [Deploy strategy]
```

---

## Example Output

### Input
```
/plan Add Stripe subscription with monthly and yearly plans
```

### Output
```markdown
# Implementation Plan: Stripe Subscription

**Requested**: Add subscription billing with monthly ($19) and yearly ($190) plans
**Complexity**: High
**Estimated Time**: 3-4 days
**Risk Level**: Medium (payment processing requires careful testing)

---

## 📋 Summary

Implement Stripe Checkout for subscription handling with two tiers (monthly/yearly). Users will be redirected to Stripe's hosted checkout page for payment, then returned to the app. Subscription status will be tracked via webhooks and stored in the database.

---

## 📁 Files to Create

| File | Purpose | Lines (est) |
|------|---------|-------------|
| `src/lib/stripe.ts` | Stripe client + helpers | ~80 |
| `src/app/api/checkout/route.ts` | Create checkout session | ~50 |
| `src/app/api/webhooks/stripe/route.ts` | Handle Stripe webhooks | ~100 |
| `src/app/api/billing/portal/route.ts` | Customer portal link | ~30 |
| `src/app/pricing/page.tsx` | Pricing page UI | ~150 |
| `src/components/PricingCard.tsx` | Pricing card component | ~80 |

---

## ✏️ Files to Modify

| File | Changes | Risk |
|------|---------|------|
| `src/lib/supabase/schema.sql` | Add subscriptions table | Low |
| `src/lib/auth.ts` | Add subscription check to user | Low |
| `src/middleware.ts` | Gate premium features | Medium |
| `src/app/dashboard/page.tsx` | Show subscription status | Low |

---

## 🔧 Implementation Steps

### Phase 1: Setup (2-3 hours)

1. **Create Stripe Products & Prices**
   - What: Set up products in Stripe Dashboard
   - Create "Monthly Pro" ($19/month) and "Yearly Pro" ($190/year)
   - Save price IDs for use in code

2. **Add Database Schema**
   - Where: `schema.sql`
   - Code:
   \`\`\`sql
   CREATE TABLE subscriptions (
     id TEXT PRIMARY KEY, -- Stripe subscription ID
     user_id UUID REFERENCES auth.users,
     status TEXT NOT NULL,
     price_id TEXT NOT NULL,
     current_period_end TIMESTAMPTZ,
     cancel_at_period_end BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMPTZ DEFAULT NOW()
   );

   ALTER TABLE profiles ADD COLUMN stripe_customer_id TEXT;
   \`\`\`

3. **Install Dependencies**
   \`\`\`bash
   npm install stripe @stripe/stripe-js
   \`\`\`

### Phase 2: Backend (4-5 hours)

4. **Create Stripe Client**
   - Where: `src/lib/stripe.ts`
   \`\`\`typescript
   import Stripe from 'stripe';

   export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

   export const PRICES = {
     monthly: process.env.STRIPE_PRICE_MONTHLY!,
     yearly: process.env.STRIPE_PRICE_YEARLY!
   };
   \`\`\`

5. **Checkout Session Endpoint**
   - Where: `src/app/api/checkout/route.ts`
   - Creates Stripe customer if needed
   - Returns checkout session URL

6. **Webhook Handler**
   - Where: `src/app/api/webhooks/stripe/route.ts`
   - Handle: checkout.session.completed
   - Handle: customer.subscription.updated
   - Handle: customer.subscription.deleted

7. **Billing Portal Endpoint**
   - Where: `src/app/api/billing/portal/route.ts`
   - Returns portal URL for managing subscription

### Phase 3: Frontend (3-4 hours)

8. **Pricing Page**
   - Where: `src/app/pricing/page.tsx`
   - Two pricing cards (monthly/yearly)
   - Highlight yearly savings
   - Checkout button calls API

9. **Subscription Status in Dashboard**
   - Show current plan
   - "Manage Subscription" link to portal
   - Upgrade prompt for free users

### Phase 4: Testing & Polish (2-3 hours)

10. **Test with Stripe Test Mode**
    - Test card: 4242 4242 4242 4242
    - Test subscription lifecycle
    - Test webhook handling

11. **Add Error Handling**
    - Payment failures
    - Webhook verification failures
    - Network errors

---

## ⚠️ Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Webhook failures | Medium | High | Add retry logic, monitor failed webhooks |
| Double charges | Low | High | Check for existing subscription before creating |
| Missing webhook events | Low | High | Set up Stripe webhook monitoring |

---

## 🔗 Dependencies

### External Services
- **Stripe**: Create account, get API keys, configure webhooks

### Environment Variables
\`\`\`env
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_MONTHLY=price_...
STRIPE_PRICE_YEARLY=price_...
\`\`\`

---

## ✅ Acceptance Criteria

- [ ] Users can view pricing page with monthly/yearly options
- [ ] Clicking "Subscribe" redirects to Stripe Checkout
- [ ] After payment, user's plan is updated in database
- [ ] User can manage subscription via Stripe portal
- [ ] Cancellation properly downgrades user
- [ ] Failed payments are handled gracefully
- [ ] Yearly plan shows savings compared to monthly
```
]]>