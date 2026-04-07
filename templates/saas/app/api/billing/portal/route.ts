import Stripe from 'stripe';
import { createServerClient } from '@/lib/supabase/server';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST() {
  const supabase = createServerClient();

  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  // Get or create Stripe customer
  const { data: profile } = await supabase
    .from('profiles')
    .select('stripe_customer_id')
    .eq('id', user.id)
    .single();

  let customerId = profile?.stripe_customer_id;

  if (!customerId) {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { supabase_user_id: user.id },
    });
    customerId = customer.id;

    await supabase
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', user.id);
  }

  // Create billing portal session
  const portalSession = await stripe.billingPortal.sessions.create({
    customer: customerId,
    return_url: `${process.env.NEXT_PUBLIC_URL}/dashboard/billing`,
  });

  return Response.json({ url: portalSession.url });
}
