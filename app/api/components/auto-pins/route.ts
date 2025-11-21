import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export async function POST(request: Request) {
  const supabase = createClient();

  const { type } = await request.json();
  if (!type) return NextResponse.json({ error: 'Missing component type' }, { status: 400 });

  const { data, error } = await supabase
    .from('components')
    .select('type,width,height,pins')
    .eq('type', type.toUpperCase())
    .limit(1)
    .single();

  if (error || !data) {
    return NextResponse.json({ error: 'No template found for this type' }, { status: 404 });
  }

  return NextResponse.json({ pins: data.pins || [], width: data.width, height: data.height });
}
