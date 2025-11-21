import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Button } from '@/components/ui/Button';
import { Plus, Edit } from 'lucide-react';
import { deleteProduct } from '@/app/admin/actions';

export default async function AdminProducts() {
  const supabase = createClient();
  const { data: products } = await supabase.from('products').select('*').order('created_at');

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Products</h1>
        <Link href="/admin/products/new"><Button><Plus size={16} className="mr-2"/> New Product</Button></Link>
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
                {products?.map(p => (
                    <tr key={p.id} className="hover:bg-slate-50">
                        <td className="p-4 font-medium">{p.title}</td>
                        <td className="p-4">${p.price / 100}</td>
                        <td className="p-4"><span className={`px-2 py-1 rounded text-xs ${p.is_published ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>{p.is_published ? 'Published' : 'Draft'}</span></td>
                        <td className="p-4 text-right flex justify-end gap-2">
                            <Link href={`/admin/products/${p.id}`}>
                                <Button size="sm" variant="outline"><Edit size={14} className="mr-2"/> Edit</Button>
                            </Link>
                            <form action={deleteProduct.bind(null, p.id)}>
                                <Button size="sm" variant="ghost" className="text-red-600 hover:text-red-700">Delete</Button>
                            </form>
                        </td>
                    </tr>
                ))}
            </tbody>
         </table>
      </div>
    </div>
  );
}
