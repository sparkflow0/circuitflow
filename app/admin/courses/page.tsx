import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Button } from '@/components/ui/Button';
import { Plus, Edit } from 'lucide-react';

export default async function AdminCourses() {
  const supabase = createClient();
  const { data: courses } = await supabase.from('courses').select('*').order('created_at');

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Courses</h1>
        <Link href="/admin/courses/new"><Button><Plus size={16} className="mr-2"/> New Course</Button></Link>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
         <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 border-b border-slate-200">
                <tr>
                    <th className="p-4 font-medium text-slate-500">Title</th>
                    <th className="p-4 font-medium text-slate-500">Price</th>
                    <th className="p-4 font-medium text-slate-500">Status</th>
                    <th className="p-4 font-medium text-slate-500 text-right">Action</th>
                </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
                {courses?.map(c => (
                    <tr key={c.id} className="hover:bg-slate-50">
                        <td className="p-4 font-medium">{c.title}</td>
                        <td className="p-4">${c.price / 100}</td>
                        <td className="p-4"><span className={`px-2 py-1 rounded text-xs ${c.is_published ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>{c.is_published ? 'Live' : 'Draft'}</span></td>
                        <td className="p-4 text-right">
                            <Link href={`/admin/courses/${c.id}`}>
                                <Button size="sm" variant="outline"><Edit size={14} className="mr-2"/> Edit</Button>
                            </Link>
                        </td>
                    </tr>
                ))}
            </tbody>
         </table>
      </div>
    </div>
  );
}
