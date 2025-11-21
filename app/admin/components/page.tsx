import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import { Button } from '@/components/ui/Button';
import { Plus, Edit, Trash2, Cpu } from 'lucide-react';
import { deleteComponent } from '@/app/admin/actions';

export default async function AdminComponents() {
  const supabase = createClient();
  const { data: components } = await supabase.from('components').select('*').order('name');

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold flex items-center gap-2"><Cpu size={20}/> Components</h1>
        <Link href="/admin/components/new"><Button><Plus size={16} className="mr-2"/> New Component</Button></Link>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <table className="w-full text-left text-sm">
          <thead className="bg-slate-50 border-b border-slate-200">
            <tr>
              <th className="p-4 font-medium text-slate-500">Name</th>
              <th className="p-4 font-medium text-slate-500">Type</th>
              <th className="p-4 font-medium text-slate-500">Pins</th>
              <th className="p-4 font-medium text-slate-500">Size</th>
              <th className="p-4 font-medium text-slate-500">Updated</th>
              <th className="p-4 font-medium text-slate-500 text-right">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {components?.map((c) => (
              <tr key={c.id} className="hover:bg-slate-50">
                <td className="p-4 font-medium">{c.name}</td>
                <td className="p-4 uppercase">{c.type}</td>
                <td className="p-4">{Array.isArray(c.pins) ? c.pins.length : 0}</td>
                <td className="p-4">{c.width} x {c.height}</td>
                <td className="p-4 text-xs text-slate-500">{new Date(c.updated_at).toLocaleDateString()}</td>
                <td className="p-4 text-right flex justify-end gap-2">
                  <Link href={`/admin/components/${c.id}`}>
                    <Button size="sm" variant="outline"><Edit size={14} className="mr-2"/> Edit</Button>
                  </Link>
                  <form action={deleteComponent.bind(null, c.id)}>
                    <Button size="sm" variant="ghost" className="text-red-600 hover:text-red-700 flex items-center gap-1"><Trash2 size={14}/> Delete</Button>
                  </form>
                </td>
              </tr>
            ))}
            {(!components || components.length === 0) && (
              <tr>
                <td className="p-4 text-center text-slate-500" colSpan={6}>No components yet</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
