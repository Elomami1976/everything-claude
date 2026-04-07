import Stripe from 'stripe';
import { createAdminClient } from '@/lib/supabase/admin';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST(req: Request) {
  const body = await req.text();
  const signature = req.headers.get('stripe-signature');

  if (!signature) {
    return Response.json({ error: 'Missing stripe-signature header' }, { status: 400 });
  }

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch {
    return Response.json({ error: 'Invalid webhook signature' }, { status: 400 });
  }

  const supabase = createAdminClient();

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.CheckoutSession;

      if (session.mode === 'subscription' && session.subscription) {
        const subscription = await stripe.subscriptions.retrieve(
          session.subscription as string
        );

        await supabase.from('subscriptions').upsert({
          id: subscription.id,
          user_id: session.metadata?.user_id,
          status: subscription.status,
          price_id: subscription.items.data[0].price.id,
          current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
          cancel_at_period_end: subscription.cancel_at_period_end,
        });
      }
      break;
    }

    case 'customer.subscription.updated':
    case 'customer.subscription.deleted': {
      const subscription = event.data.object as Stripe.Subscription;

      await supabase
        .from('subscriptions')
        .update({
          status: subscription.status,
          price_id: subscription.items.data[0].price.id,
          current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
          cancel_at_period_end: subscription.cancel_at_period_end,
        })
        .eq('id', subscription.id);
      break;
    }
  }

  return Response.json({ received: true });
}
