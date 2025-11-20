import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16', // matched to the typed Stripe API version
});

export async function POST(request: Request) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const body = await request.json();
  const { itemId, type } = body; // type: 'course' | 'product'

  // 1. Fetch item details from DB to ensure price integrity
  const table = type === 'course' ? 'courses' : 'products';
  const { data: item } = await supabase.from(table).select('*').eq('id', itemId).single();

  if (!item) return NextResponse.json({ error: 'Item not found' }, { status: 404 });

  // 2. Create Stripe Session
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
          unit_amount: item.price, // Assumes price is in cents in DB
        },
        quantity: 1,
      },
    ],
    mode: 'payment',
    success_url: `${process.env.NEXT_PUBLIC_BASE_URL}/dashboard?success=true`,
    cancel_url: `${process.env.NEXT_PUBLIC_BASE_URL}/${type === 'course' ? 'courses' : 'store'}/${item.slug}`,
    metadata: {
      userId: user.id,
      itemId: item.id,
      type: type, // Used in webhook to determine table to update
    },
  });

  return NextResponse.json({ sessionId: session.id, url: session.url });
}
