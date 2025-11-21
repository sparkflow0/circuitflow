import { createClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { Button } from '@/components/ui/Button';
import { Plus, Edit } from 'lucide-react';
import { deleteBlogPost } from '@/app/admin/actions';

export default async function AdminBlog() {
  const supabase = createClient();
  const { data: posts } = await supabase.from('blog_posts').select('*').order('published_at', { ascending: false });

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Blog Posts</h1>
        <Link href="/admin/blog/new"><Button><Plus size={16} className="mr-2"/> New Post</Button></Link>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
         <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 border-b border-slate-200">
                <tr>
                    <th className="p-4 font-medium text-slate-500">Title</th>
                    <th className="p-4 font-medium text-slate-500">Slug</th>
                    <th className="p-4 font-medium text-slate-500">Status</th>
                    <th className="p-4 font-medium text-slate-500 text-right">Action</th>
                </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
                {posts?.map(post => (
                    <tr key={post.id} className="hover:bg-slate-50">
                        <td className="p-4 font-medium">{post.title}</td>
                        <td className="p-4 text-slate-500">{post.slug}</td>
                        <td className="p-4"><span className={`px-2 py-1 rounded text-xs ${post.is_published ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>{post.is_published ? 'Published' : 'Draft'}</span></td>
                        <td className="p-4 text-right flex justify-end gap-2">
                            <Link href={`/admin/blog/${post.id}`}>
                                <Button size="sm" variant="outline"><Edit size={14} className="mr-2"/> Edit</Button>
                            </Link>
                            <form action={deleteBlogPost.bind(null, post.id)}>
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
