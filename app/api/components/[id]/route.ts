import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

const isAdmin = async (supabase: ReturnType<typeof createClient>) => {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { user: null, role: null };
  const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();
  return { user, role: profile?.role ?? 'user' };
};

export async function GET(request: Request, { params }: { params: { id: string } }) {
  const supabase = createClient();
  const { id } = params;
  const { data, error } = await supabase.from('components').select('*').eq('id', id).single();
  if (error) return NextResponse.json({ error: 'Component not found', details: error.message }, { status: 404 });
  return NextResponse.json({ component: data });
}

export async function PUT(request: Request, { params }: { params: { id: string } }) {
  const supabase = createClient();
  const { role } = await isAdmin(supabase);
  if (role !== 'admin') return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });

  const updates = await request.json();
  const payload: any = { ...updates, updated_at: new Date().toISOString() };
  if (updates.type) payload.type = updates.type.toUpperCase();
  if (updates.type === undefined) delete payload.type;
  const { id } = params;
  const { data, error } = await supabase
    .from('components')
    .update(payload)
    .eq('id', id)
    .select()
    .single();

  if (error) return NextResponse.json({ error: 'Failed to update component', details: error.message }, { status: 500 });
  return NextResponse.json({ component: data });
}

export async function DELETE(request: Request, { params }: { params: { id: string } }) {
  const supabase = createClient();
  const { role } = await isAdmin(supabase);
  if (role !== 'admin') return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });

  const { id } = params;
  const { error } = await supabase.from('components').delete().eq('id', id);
  if (error) return NextResponse.json({ error: 'Failed to delete component', details: error.message }, { status: 500 });
  return NextResponse.json({ success: true });
}
