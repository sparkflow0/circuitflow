import { createClient } from '@/lib/supabase/server';
import ComponentEditorClient from './ComponentEditorClient';

export default async function ComponentEditor({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const isNew = params.id === 'new';

  let component: any = {};
  if (!isNew) {
    const { data } = await supabase.from('components').select('*').eq('id', params.id).single();
    if (data) component = data;
  }

  return <ComponentEditorClient initialComponent={component} isNew={isNew} />;
}
