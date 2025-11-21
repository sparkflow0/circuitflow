import { createClient } from '@/lib/supabase/server';
import { upsertBlogPost } from '@/app/admin/actions';
import { Button } from '@/components/ui/Button';
import ImageUpload from '@/components/admin/ImageUpload';
import { Save } from 'lucide-react';

export default async function BlogPostEditor({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const isNew = params.id === 'new';
  
  let post: any = {};
  if (!isNew) {
      const { data } = await supabase.from('blog_posts').select('*').eq('id', params.id).single();
      if (data) post = data;
  }

  return (
    <div className="max-w-4xl mx-auto pb-20">
       <div className="flex justify-between items-center mb-6">
           <h1 className="text-2xl font-bold">{isNew ? 'New Blog Post' : 'Edit Post'}</h1>
           <Button form="blog-form" type="submit"><Save size={16} className="mr-2"/> Save Post</Button>
       </div>
       
       <form id="blog-form" action={upsertBlogPost} className="bg-white p-8 rounded-xl border border-slate-200 space-y-6">
           <input type="hidden" name="id" value={post.id || ''} />
           
           <div>
               <label className="block text-sm font-bold mb-2">Post Title</label>
               <input name="title" defaultValue={post.title} required className="w-full p-2 border rounded-lg"/>
           </div>
           
           <div>
                <label className="block text-sm font-bold mb-2">Slug</label>
                <input name="slug" defaultValue={post.slug} required className="w-full p-2 border rounded-lg"/>
           </div>
           
           <ImageUpload name="cover_image" label="Cover Image" defaultValue={post.cover_image}/>

           <div>
                <label className="block text-sm font-bold mb-2">Excerpt</label>
                <textarea name="excerpt" defaultValue={post.excerpt} className="w-full p-2 border rounded-lg h-24"/>
           </div>

           <div>
                <label className="block text-sm font-bold mb-2">Content (HTML)</label>
                <p className="text-xs text-slate-500 mb-2">Tip: Use HTML tags for formatting.</p>
                <textarea name="content" defaultValue={post.content} className="w-full p-4 border rounded-lg h-96 font-mono text-sm bg-slate-50"/>
           </div>

           <div className="flex items-center gap-2 pt-4 border-t border-slate-100">
                <input type="checkbox" name="is_published" defaultChecked={post.is_published} id="pub"/>
                <label htmlFor="pub" className="font-medium">Publish Post</label>
           </div>
       </form>
    </div>
  );
}
