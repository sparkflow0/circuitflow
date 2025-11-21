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
    // If user is not logged in, we could technically redirect to login with return_url
    // For API, return 401
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const body = await request.json();
  const { itemId, type, variantName } = body; 

  const table = type === 'course' ? 'courses' : 'products';
  const { data: item } = await supabase.from(table).select('*').eq('id', itemId).single();

  if (!item) return NextResponse.json({ error: 'Item not found' }, { status: 404 });

  // Calculate Dynamic Price based on Variant
  let finalPrice = item.price;
  let description = item.short_description || item.description || "";

  if (type === 'product' && variantName && Array.isArray(item.variants)) {
      const variant = item.variants.find((v: any) => v.name === variantName);
      if (variant) {
          finalPrice += (variant.price_mod || 0);
          description += ` (${variantName})`;
      }
  }

  // Create Stripe Session
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: [
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: item.title,
            description: description.substring(0, 500), // Stripe limit
          },
          unit_amount: finalPrice, 
        },
        quantity: 1,
      },
    ],
    mode: 'payment',
    success_url: `${process.env.NEXT_PUBLIC_BASE_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}&type=${type}&slug=${item.slug}`,
    cancel_url: `${process.env.NEXT_PUBLIC_BASE_URL}/${type === 'course' ? 'courses' : 'store'}/${item.slug}`,
    metadata: {
      userId: user.id,
      itemId: item.id,
      type: type, 
      variant: variantName || 'default'
    },
  });

  return NextResponse.json({ sessionId: session.id, url: session.url });
}
