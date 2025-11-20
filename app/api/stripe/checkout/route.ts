import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-04-10', 
});

export async function POST(request: Request) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const body = await request.json();
  const { itemId, type } = body; 

  const table = type === 'course' ? 'courses' : 'products';
  const { data: item } = await supabase.from(table).select('*').eq('id', itemId).single();

  if (!item) return NextResponse.json({ error: 'Item not found' }, { status: 404 });

  // Create Stripe Session with SESSION_ID in success_url
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: [
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: item.title,
            description: item.short_description || item.description,
          },
          unit_amount: item.price, 
        },
        quantity: 1,
      },
    ],
    mode: 'payment',
    // IMPORTANT: We pass {CHECKOUT_SESSION_ID} so the success page can verify it
    success_url: `${process.env.NEXT_PUBLIC_BASE_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}&type=${type}&slug=${item.slug}`,
    cancel_url: `${process.env.NEXT_PUBLIC_BASE_URL}/${type === 'course' ? 'courses' : 'store'}/${item.slug}`,
    metadata: {
      userId: user.id,
      itemId: item.id,
      type: type, 
    },
  });

  return NextResponse.json({ sessionId: session.id, url: session.url });
}
