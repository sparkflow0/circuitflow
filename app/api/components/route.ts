import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

const isAdmin = async (supabase: ReturnType<typeof createClient>) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { user: null, role: null };
  const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();
  return { user, role: profile?.role ?? 'user' };
};

export async function GET() {
  const supabase = createClient();
  const { data, error } = await supabase.from('components').select('*').order('name');
  if (error) {
    return NextResponse.json({ error: 'Failed to fetch components', details: error.message }, { status: 500 });
  }
  return NextResponse.json({ components: data ?? [] });
}

export async function POST(request: Request) {
  const supabase = createClient();
  const { role } = await isAdmin(supabase);
  if (role !== 'admin') return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });

  const payload = await request.json();
  const { name, type, slug, category, image_url, width, height, pins = [], metadata = {} } = payload;

  if (!name || !type || !slug || !width || !height) {
    return NextResponse.json({ error: 'Missing required fields' }, { status: 400 });
  }

  const record = {
    name,
    type: type.toUpperCase(),
    slug,
    category,
    image_url,
    width,
    height,
    pins,
    metadata,
    updated_at: new Date().toISOString(),
  };

  const { data, error } = await supabase
    .from('components')
    .insert(record)
    .select()
    .single();

  if (error) {
    return NextResponse.json({ error: 'Failed to create component', details: error.message }, { status: 500 });
  }

  return NextResponse.json({ component: data }, { status: 201 });
}
