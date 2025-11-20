import { headers } from 'next/headers';
import { NextResponse } from 'next/server';
import Stripe from 'stripe';
import { createClient } from '@supabase/supabase-js';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

// Use service role to bypass RLS for admin writes
const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export async function POST(request: Request) {
  const body = await request.text();
  const signature = headers().get('stripe-signature')!;

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(body, signature, webhookSecret);
  } catch (err) {
    return NextResponse.json({ error: 'Webhook Error' }, { status: 400 });
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object as Stripe.Checkout.Session;
    const { userId, itemId, type } = session.metadata!;

    if (type === 'course') {
      await supabaseAdmin.from('course_enrollments').insert({
        user_id: userId,
        course_id: itemId,
        payment_status: 'paid',
      });
    } else if (type === 'product') {
      await supabaseAdmin.from('product_purchases').insert({
        user_id: userId,
        product_id: itemId,
        payment_status: 'paid',
      });
    }
  }

  return NextResponse.json({ received: true });
}
